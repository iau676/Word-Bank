//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData
import AVFoundation
import Combine

private let reuseIdentifier = "ReusableCell"

class ResultController: UIViewController {

    private let exerciseKind: ExerciseKind
    private let exerciseType: ExerciseType
    
    var questionArray = [String]()
    var answerArray = [String]()
    var userAnswerArray = [String]()
    var userAnswerArrayBool = [Bool]()
    private var trueAnswerCount = 0
    
    private var wordBrain = WordBrain()
    private var addedHardWordsCount: Int {return UserDefault.addedHardWordsCount.getInt() }
    
    private let confettiButton: UIButton = {
        let button = UIButton()
        button.setImage(image: Images.confetti, width: 66, height: 66)
        return button
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.AvenirNextMedium19
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = Colors.cellRight
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Colors.raven
        view.register(WordCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.tableFooterView = UIView()
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    private lazy var addedHardWordsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.titleLabel?.font = Fonts.AvenirNextRegular15
        button.setTitleColor(Colors.yellow, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(addedHardWordsButtonPressed(_:)), for: .touchUpInside)
        
        let text = "\(addedHardWordsCount) \((addedHardWordsCount == 1) ? "Word" : "Words") Added to Hard Words"
        button.setTitle(addedHardWordsCount > 0 ? text : "", for: .normal)
        button.isHidden = addedHardWordsCount < 1
        
        return button
    }()
    
    private lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Images.house, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(Images.refresh, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(refreshButtonPressed(_:)), for: .touchUpInside)
        button.isHidden = exerciseKind == .hard && wordBrain.hardItemArray.count < 2
        return button
    }()
    
    //MARK: - Life Cycle
    
    init(exerciseKind: ExerciseKind, exerciseType: ExerciseType) {
        self.exerciseKind = exerciseKind
        self.exerciseType = exerciseType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        wordBrain.loadUser()
        
        configureUI()
        
        findTrueAnswerCount()
        checkAllTrue()
        checkLevelUp()
        updateUserData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Player.shared.removeAppEventsSubscribers()
        Player.shared.removePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Player.shared.playerLayer?.frame = view.bounds
    }
    
    //MARK: - Selectors
    
    @objc private func addedHardWordsButtonPressed(_ sender: UIButton) {
        let controller = WordsController(exerciseKind: ExerciseKind.hard)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func homeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func refreshButtonPressed(_ sender: Any) {
        var controller = UIViewController()
        switch exerciseType {
        case .test:
            controller = TestController(exerciseKind: exerciseKind)
        case .writing:
            controller = WritingController(exerciseKind: exerciseKind)
        case .listening:
            controller = ListeningController(exerciseKind: exerciseKind)
        case .card:
            controller = CardController()
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = Colors.raven
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        view.addSubview(confettiButton)
        confettiButton.centerX(inView: view)
        confettiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        view.addSubview(scoreLabel)
        scoreLabel.centerX(inView: view)
        let allTrue: Bool = trueAnswerCount == questionArray.count
        scoreLabel.anchor(top: allTrue ? view.safeAreaLayoutGuide.topAnchor : confettiButton.bottomAnchor, paddingTop: allTrue ? 45 : 16)
        
        let buttonStack = UIStackView(arrangedSubviews: [homeButton, refreshButton])
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.spacing = 130
        
        homeButton.setDimensions(width: 48, height: 40)
        refreshButton.setDimensions(width: 35, height: 40)
        
        view.addSubview(buttonStack)
        buttonStack.centerX(inView: view)
        buttonStack.anchor(bottom: view.bottomAnchor, paddingBottom: 32)
        
        view.addSubview(tableView)
        tableView.anchor(top: scoreLabel.bottomAnchor, left: view.leftAnchor,
                         bottom: buttonStack.topAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 16,
                         paddingBottom: addedHardWordsCount > 0 ? 48 : 32, paddingRight: 16)
        
        view.addSubview(addedHardWordsButton)
        addedHardWordsButton.anchor(left: view.leftAnchor, bottom: buttonStack.topAnchor,
                                    right: view.rightAnchor, paddingLeft: 32,
                                    paddingBottom: 8, paddingRight: 32)
    }
    
    private func updateUserData() {
        wordBrain.user[0].level      = Int16(UserDefault.level.getInt())
        wordBrain.user[0].lastPoint  = Int32(UserDefault.lastPoint.getInt())
        
        let trueCount = Int16(trueAnswerCount)
        let falseCount = Int16(userAnswerArray.count-trueAnswerCount)
        let hintCount = Int16(UserDefault.hintCount.getInt())
        
        wordBrain.addExercise(type: exerciseType, kind: exerciseKind,
                              trueCount: trueCount, falseCount: falseCount,
                              hintCount: hintCount)
    }
    
    private func findTrueAnswerCount() {
        for i in 0..<userAnswerArray.count {
            if userAnswerArray[i] == answerArray[i] {
                trueAnswerCount += 1
            }
        }
        scoreLabel.text = "\(trueAnswerCount)/\(questionArray.count)"
    }
    
    private func checkAllTrue() {
        if trueAnswerCount == questionArray.count {
            Player.shared.observeAppEvents()
            Player.shared.setupPlayerIfNeeded(view: view, videoName: Videos.alltrue)
            Player.shared.restartVideo()
            tableView.backgroundColor = .clear
            confettiButton.isHidden = true
            scoreLabel.text = exerciseType == .card ? "" : "All Correct!"
        }
    }

    private func checkLevelUp() {
        let lastLevel = UserDefault.level.getInt()
        _ = Level.shared.calculateLevel()
        let newLevel = UserDefault.level.getInt()
        
        if newLevel - lastLevel > 0 {
            DispatchQueue.main.async(){
                let vc = LevelUpController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
}

    //MARK: - UITableViewDataSource

extension ResultController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WordCell
        
        let answer = answerArray[indexPath.row]
        let userAnswer = userAnswerArray[indexPath.row]
        
        updateCellLabelText(cell, indexPath.row)
        cell.configureCornerRadius(index: indexPath.row)
        
        if userAnswer == answer {
            updateCellViewBackgroundForRight(cell)
        } else {
            updateCellViewBackgroundForWrong(cell)
            updateCellLabelTextForWrong(cell, indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let answer = answerArray[indexPath.row]
        let userAnswer = userAnswerArray[indexPath.row]
        let questionText = questionArray[indexPath.row]
        let answerText = userAnswer == answer ? answer : writeAnswerCell(userAnswerArray[indexPath.row].strikeThrough(), answer).string
        let longestText = questionText.count > answerText.count ? questionText : answerText
        let height = size(forText: longestText, minusWidth: 26+32).height
        return height+24
    }
    
    private func updateCellLabelText(_ cell: WordCell, _ index: Int) {
        cell.engLabel.text = questionArray[index]
        cell.meaningLabel.text = answerArray[index]
        cell.numberLabel.text = String(index+1)
    }
    
    private func updateCellViewBackgroundForRight(_ cell: WordCell){
        cell.engView.backgroundColor = Colors.green
        cell.meaningView.backgroundColor = Colors.lightGreen
    }
    
    private func updateCellViewBackgroundForWrong(_ cell: WordCell){
        if exerciseType == ExerciseType.card {
            cell.engView.backgroundColor = Colors.yellow
            cell.meaningView.backgroundColor = Colors.lightYellow
        } else {
            cell.engView.backgroundColor = Colors.red
            cell.meaningView.backgroundColor = Colors.lightRed
        }
    }
    
    private func updateCellLabelTextForWrong(_ cell: WordCell, _ i: Int){
        if exerciseType != ExerciseType.card {
            cell.meaningLabel.attributedText = writeAnswerCell(userAnswerArray[i].strikeThrough(),
                                                          answerArray[i])
        }
    }
    
    private func writeAnswerCell(_ userAnswer: NSAttributedString, _ trueAnswer: String) -> NSMutableAttributedString {
        let boldFontAttributes = [NSAttributedString.Key.font: Fonts.AvenirNextMedium15]
        
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        let partOne = NSMutableAttributedString(string: "Your answer:\n", attributes: normalFontAttributes)
        
        let partTwo = userAnswer
        
        let partThree = NSMutableAttributedString(string: userAnswer.length == 0 ? "Correct answer: \n" : "\nCorrect answer: \n", attributes: normalFontAttributes)
        
        let partFour = NSMutableAttributedString(string: trueAnswer, attributes: boldFontAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()
            
        if userAnswer.length != 0 {
            combination.append(partOne)
            combination.append(partTwo)
        }
            
        combination.append(partThree)
        combination.append(partFour)
        
        return combination
    }
}

//MARK: - UITableViewDelegate

extension ResultController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let isDefaultTest: Bool = (exerciseType == .test &&  UserDefault.selectedTestType.getInt() == 0)
        let isCard: Bool = exerciseType == .card
        var text = (isDefaultTest || isCard) ? questionArray[indexPath.row] : answerArray[indexPath.row]
        let soundSpeed = UserDefault.soundSpeed.getDouble()
      
        Player.shared.playSound(soundSpeed, text)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
