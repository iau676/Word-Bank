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

    private let exerciseType: String
    private let exerciseFormat: String
    
    private var wordBrain = WordBrain()
    private let player = Player()
    
    private var numberOfTrue = 0
    private var lastLevel:Int = 0
    private var newLevel:Int = 0
    private var scoreLabelText = ""
    
    private let confettiButton = UIButton()
    private let scoreLabel = UILabel()
    private let tableView = UITableView()
    private let addedHardWordsButton =  UIButton()
    private let buttonStackView = UIStackView()
    private let homeButton = UIButton()
    private let refreshButton = UIButton()
    
    private var addedHardWordsCount: Int {return UserDefault.addedHardWordsCount.getInt() }
    private var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    private var soundSpeed: Double { return UserDefault.soundSpeed.getDouble() }
    
    var questionArray = [String]()
    var answerArray = [String]()
    var userAnswerArray = [String]()
    var userAnswerArrayBool = [Bool]()
    
    //MARK: - Life Cycle
    
    init(exerciseType: String, exerciseFormat: String) {
        self.exerciseType = exerciseType
        self.exerciseFormat = exerciseFormat
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
        
        style()
        layout()
        
        configureColor()
        calculateNumberOfTrue()
        checkLevelUp()
        updateStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateRefreshButtonVisibility()
        checkWhichExercise()
        updateHardWordText()
        checkAllTrue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.removeAppEventsSubscribers()
        player.removePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.playerLayer?.frame = view.bounds
    }
    
    //MARK: - Selectors
    
    @objc private func addedHardWordsButtonPressed(_ sender: UIButton) {
        let controller = WordsController(exerciseType: ExerciseType.hard)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc private func homeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func refreshButtonPressed(_ sender: Any) {
        var controller = UIViewController()
        switch exerciseFormat {
        case ExerciseFormat.test:
            controller = TestController(exerciseType: exerciseType,
                                        exerciseFormat: exerciseFormat)
        case ExerciseFormat.writing:
            controller = WritingController(exerciseType: exerciseType,
                                           exerciseFormat: exerciseFormat)
        case ExerciseFormat.listening:
            controller = ListeningController(exerciseType: exerciseType,
                                             exerciseFormat: exerciseFormat)
        case ExerciseFormat.card:
            controller = CardController(exerciseType: exerciseType,
                                        exerciseFormat: exerciseFormat)
        default: break
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - Helpers    
    
    private func configureColor() {
        view.backgroundColor = Colors.raven
        tableView.backgroundColor = Colors.raven
        scoreLabel.textColor = Colors.cellRight
        addedHardWordsButton.setTitleColor(Colors.yellow, for: .normal)
    }
    
    private func updateRefreshButtonVisibility() {
        refreshButton.isHidden = exerciseType == ExerciseType.hard && wordBrain.hardItemArray.count < 2
    }
    
    private func updateHardWordText() {
        //print how many words added to hard words
        if addedHardWordsCount > 0 {
            addedHardWordsButton.isHidden = false
            let WordOrWords = (addedHardWordsCount == 1) ? "Word" : "Words"
            addedHardWordsButton.setTitle("\(addedHardWordsCount) \(WordOrWords) Added to Hard Words", for: .normal)
        } else {
            addedHardWordsButton.isHidden = true
            addedHardWordsButton.setTitle("", for: .normal)
        }
    }
    
    private func checkWhichExercise() {
        if exerciseFormat == ExerciseFormat.card {
            numberOfTrue = userAnswerArray.count
        } else {
            scoreLabel.text = "\(numberOfTrue)/\(userAnswerArray.count)"
            scoreLabelText = "All Correct!"
        }
    }
    
    private func updateStats() {
        if exerciseType == ExerciseType.normal {
            updateExerciseCount(exerciseType: ExerciseType.normal)
        } else {
            updateExerciseCount(exerciseType: ExerciseType.hard)
        }
        wordBrain.user[0].level      = Int16(UserDefault.level.getInt())
        wordBrain.user[0].lastPoint  = Int32(UserDefault.lastPoint.getInt())
    }
    
    private func updateExerciseCount(exerciseType: String) {
        
        let trueCount = Int16(numberOfTrue)
        let falseCount = Int16(userAnswerArray.count-numberOfTrue)
        let hintCount = Int16(UserDefault.hintCount.getInt())
        
        wordBrain.addExercise(name: exerciseFormat, type: exerciseType,
                              trueCount: trueCount, falseCount: falseCount,
                              hintCount: hintCount)
    }
    
    private func calculateNumberOfTrue() {
        for i in 0..<userAnswerArray.count {
            if userAnswerArrayBool[i] == true {
                numberOfTrue += 1
            }
        }
    }
    
    private func checkAllTrue(){
        if numberOfTrue == userAnswerArray.count {
            tableView.backgroundColor = .clear
            player.observeAppEvents()
            player.setupPlayerIfNeeded(view: view, videoName: Videos.alltrue)
            player.restartVideo()
            confettiButton.isHidden = true
            scoreLabel.text = scoreLabelText
            updateScoreLabelConstraint()
        }
    }
    
    private func updateScoreLabelConstraint(){
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45)
        ])
    }

    private func checkLevelUp(){
        lastLevel = UserDefault.level.getInt()
        _ = Level.shared.calculateLevel()
        newLevel = UserDefault.level.getInt()
        
        UserDefault.goLevelUp.set(0)
        
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
        
        updateCellLabelText(cell, indexPath.row)
        updateCellCornerRadius(cell, indexPath.row)
       
        if userAnswerArrayBool[indexPath.row] == false {
            updateCellViewBackgroundForWrong(cell)
            updateCellLabelTextForWrong(cell, indexPath.row)
        } else {
            updateCellViewBackgroundForRight(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let answer = answerArray[indexPath.row]
        let text = userAnswerArrayBool[indexPath.row] ? answer : writeAnswerCell(userAnswerArray[indexPath.row].strikeThrough(), answer).string
        let height = size(forText: text, minusWidth: 26+32).height
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
        if exerciseFormat == ExerciseFormat.card {
            cell.engView.backgroundColor = Colors.yellow
            cell.meaningView.backgroundColor = Colors.lightYellow
        } else {
            cell.engView.backgroundColor = Colors.red
            cell.meaningView.backgroundColor = Colors.lightRed
        }
    }
    
    private func updateCellLabelTextForWrong(_ cell: WordCell, _ i: Int){
        if exerciseFormat != ExerciseFormat.card {
            cell.meaningLabel.attributedText = writeAnswerCell(userAnswerArray[i].strikeThrough(),
                                                          answerArray[i])
        }
    }
    
    private func writeAnswerCell(_ userAnswer: NSAttributedString, _ trueAnswer: String) -> NSMutableAttributedString {
        let boldFontAttributes = [NSAttributedString.Key.font: UIFont(name: Fonts.AvenirNextMedium, size: textSize+2)]
        
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize)]
        
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
    
    private func updateCellCornerRadius(_ cell: WordCell, _ index: Int){
        if index == 0 {
            cell.updateTopCornerRadius(16)
        }

        if index == userAnswerArray.count - 1 {
            cell.updateBottomCornerRadius(16)
        }
    }
}

//MARK: - UITableViewDelegate

extension ResultController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if exerciseFormat == ExerciseFormat.listening {
            player.playSound(soundSpeed, answerArray[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - Layout

extension ResultController {
    
    private func style(){
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        confettiButton.setImage(image: Images.confetti, width: 66, height: 66)
        
        scoreLabel.font = UIFont(name: Fonts.AvenirNextMedium, size: textSize+5)
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1
        
        tableView.register(WordCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.delegate = self
        
        addedHardWordsButton.backgroundColor = .clear
        addedHardWordsButton.titleLabel?.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        addedHardWordsButton.layer.cornerRadius = 10
        addedHardWordsButton.addTarget(self, action: #selector(addedHardWordsButtonPressed(_:)),
                                       for: .primaryActionTriggered)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.spacing = 130
        
        homeButton.setBackgroundImage(Images.house, for: .normal)
        homeButton.tintColor = .white
        homeButton.addTarget(self, action: #selector(homeButtonPressed(_:)),
                             for: .primaryActionTriggered)
        
        refreshButton.setBackgroundImage(Images.refresh, for: .normal)
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed(_:)),
                                for: .primaryActionTriggered)
    }
    
    private func layout(){
        view.addSubview(confettiButton)
        view.addSubview(scoreLabel)
        view.addSubview(tableView)
        view.addSubview(addedHardWordsButton)
        
        buttonStackView.addArrangedSubview(homeButton)
        buttonStackView.addArrangedSubview(refreshButton)
        
        view.addSubview(buttonStackView)
        
        confettiButton.centerX(inView: view)
        confettiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        scoreLabel.centerX(inView: view)
        scoreLabel.anchor(top: confettiButton.bottomAnchor, paddingTop: 16)
        
        tableView.anchor(top: scoreLabel.bottomAnchor, left: view.leftAnchor,
                         bottom: buttonStackView.topAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 16,
                         paddingBottom: 32, paddingRight: 16)
        
        addedHardWordsButton.anchor(left: view.leftAnchor, bottom: buttonStackView.topAnchor,
                                    right: view.rightAnchor, paddingLeft: 32,
                                    paddingBottom: 8, paddingRight: 32)
        
        buttonStackView.centerX(inView: view)
        buttonStackView.anchor(bottom: view.bottomAnchor, paddingBottom: 32)
        
        homeButton.setDimensions(width: 48, height: 40)
        refreshButton.setDimensions(width: 35, height: 40)
        
        if addedHardWordsCount > 0 {
            tableView.anchor(bottom: buttonStackView.topAnchor, paddingBottom: 48)
        }
    }
}
