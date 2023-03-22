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

class ResultViewController: UIViewController {

    private let exerciseType: String
    private let exerciseFormat: String
    
    let confettiButton = UIButton()
    let scoreLabel = UILabel()
    let tableView = UITableView()
    let addedHardWordsButton =  UIButton()
    let buttonStackView = UIStackView()
    let homeButton = UIButton()
    let refreshButton = UIButton()
    
    var wordBrain = WordBrain()
    let player = Player()
    var itemArray: [Item] { return wordBrain.itemArray }
    var numberOfTrue = 0
    var lastLevel:Int = 0
    var newLevel:Int = 0
    var userWordCount = ""
    var scoreLabelText = ""
    
    var questionArray = [String]()
    var answerArray = [String]()
    var userAnswerArray = [String]()
    var userAnswerArrayBool = [Bool]()

    var addedHardWordsCount: Int {return UserDefault.addedHardWordsCount.getInt() }
    var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    var whichStartPressed: Int { return UserDefault.startPressed.getInt() }
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    var soundSpeed: Double { return UserDefault.soundSpeed.getDouble() }
    
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
        wordBrain.loadItemArray()
        wordBrain.loadUser()
        
        style()
        layout()
        
        configureColor()
        calculateNumberOfTrue()
        checkLevelUp()
        updateStatistic()
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
        
    //MARK: - Selectors
    
    @objc func addedHardWordsButtonPressed(_ sender: UIButton) {
    }
    
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func refreshButtonPressed(_ sender: Any) {
        if whichStartPressed == 4 {
            let controller = CardViewController(exerciseType: ExerciseType.normal,
                                                exerciseFormat: ExerciseFormat.card)
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
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
                controller = CardViewController(exerciseType: exerciseType,
                                                exerciseFormat: exerciseFormat)
            default: break
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    //MARK: - Helpers    
    
    func configureColor() {
        view.backgroundColor = Colors.raven
        tableView.backgroundColor = Colors.raven
        scoreLabel.textColor = Colors.cellRight
        addedHardWordsButton.setTitleColor(Colors.yellow, for: .normal)
    }
    
    func updateRefreshButtonVisibility(){
        if UserDefault.whichButton.getString() == ExerciseType.hard && UserDefault.hardWordsCount.getInt() < 2 {
            refreshButton.isHidden = true
        } else {
            refreshButton.isHidden = false
        }
    }
    
    func updateHardWordText(){
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
    
    func checkWhichExercise() {
        if whichStartPressed == 4 {
            numberOfTrue = userAnswerArray.count
        } else {
            scoreLabel.text = "\(numberOfTrue)/\(userAnswerArray.count)"
            scoreLabelText = "All Correct!"
        }
    }
    
    func updateStatistic() {
        if UserDefault.whichButton.getString() == ExerciseType.normal {
            updateExerciseCount(exerciseType: ExerciseType.normal)
        } else {
            updateExerciseCount(exerciseType: ExerciseType.hard)
        }
        updateUser()
    }
    
    func updateUser(){
        wordBrain.user[0].level             = Int16(UserDefault.level.getInt())
        wordBrain.user[0].lastPoint         = Int32(UserDefault.lastPoint.getInt())
    }
    
    func updateExerciseCount(exerciseType: String) {
        
        let trueCount = Int16(numberOfTrue)
        let falseCount = Int16(userAnswerArray.count-numberOfTrue)
        let hintCount = Int16(UserDefault.hintCount.getInt())
        
        switch whichStartPressed {
        case 1:
            wordBrain.addExercise(name: ExerciseFormat.test, type: exerciseType, trueCount: trueCount, falseCount: falseCount, hintCount: hintCount)
            break
        case 2:
            wordBrain.addExercise(name: ExerciseFormat.writing, type: exerciseType, trueCount: trueCount, falseCount: falseCount, hintCount: hintCount)
            break
        case 3:
            wordBrain.addExercise(name: ExerciseFormat.listening, type: exerciseType, trueCount: trueCount, falseCount: falseCount, hintCount: hintCount)
            break
        case 4:
            wordBrain.addExercise(name: ExerciseFormat.card, type: exerciseType, trueCount: trueCount, falseCount: falseCount, hintCount: hintCount)
            break
        default: break
        }
    }
    
    func calculateNumberOfTrue() {
        for i in 0..<userAnswerArray.count {
            if userAnswerArrayBool[i] == true {
                numberOfTrue += 1
            }
        }
    }
    
    func checkAllTrue(){
        if numberOfTrue == userAnswerArray.count {
            //showWordsButton.isHidden = whichStartPressed == 4 ?  true : false
            tableView.backgroundColor = .clear
            player.observeAppEvents()
            player.setupPlayerIfNeeded(view: view, videoName: Videos.alltrue)
            player.restartVideo()
            confettiButton.isHidden = true
            scoreLabel.text = scoreLabelText
            updateScoreLabelConstraint()
        }
    }
    
    func updateScoreLabelConstraint(){
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 45)
        ])
    }

    func checkLevelUp(){
        lastLevel = UserDefault.level.getInt()
         _ = wordBrain.calculateLevel()
        newLevel = UserDefault.level.getInt()
        
        UserDefault.goLevelUp.set(0)
        
        if newLevel - lastLevel > 0 {
            DispatchQueue.main.async(){
                let vc = LevelUpViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
}

    //MARK: - UITableViewDataSource

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswerArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        updateCellLabelText(cell, indexPath.row)
        updateCellCornerRadius(cell, indexPath.row)
        updateCellForListeningExercise(cell)
        updateCellLabelTextSize(cell)
        updateCellLabelTextColor(cell)
       
        if userAnswerArrayBool[indexPath.row] == false {
            updateCellViewBackgroundForWrong(cell)
            updateCellLabelTextForWrong(cell, indexPath.row)
        } else {
            updateCellViewBackgroundForRight(cell)
        }
        return cell
    }
    
    func updateCellLabelText(_ cell: WordCell, _ index: Int) {
        cell.engLabel.text = questionArray[index]
        cell.trLabel.text = answerArray[index]
        cell.numberLabel.text = String(index+1)
    }
    
    func updateCellForListeningExercise(_ cell: WordCell){
        if whichStartPressed == 3 {
            cell.trView.isHidden = true
            cell.engLabel.textAlignment = .center
        }
    }
    
    func updateCellLabelTextSize(_ cell: WordCell) {
        cell.updateLabelTextSize(cell.engLabel, textSize)
        cell.updateLabelTextSize(cell.trLabel, textSize)
        cell.updateLabelTextSize(cell.numberLabel, textSize-4)
    }
    
    func updateCellLabelTextColor(_ cell: WordCell) {
        cell.engLabel.textColor = Colors.black
        cell.trLabel.textColor = Colors.black
    }
    
    func updateCellViewBackgroundForRight(_ cell: WordCell){
        cell.engView.backgroundColor = Colors.green
        cell.trView.backgroundColor = Colors.lightGreen
    }
    
    func updateCellViewBackgroundForWrong(_ cell: WordCell){
        if whichStartPressed == 4 {
            cell.engView.backgroundColor = Colors.yellow
            cell.trView.backgroundColor = Colors.lightYellow
        } else {
            cell.engView.backgroundColor = Colors.red
            cell.trView.backgroundColor = Colors.lightRed
        }
    }
    
    func updateCellLabelTextForWrong(_ cell: WordCell, _ i: Int){
        if whichStartPressed != 4 {
            cell.trLabel.attributedText = writeAnswerCell(userAnswerArray[i].strikeThrough(),
                                                          answerArray[i])
        }
    }
    
    func writeAnswerCell(_ userAnswer: NSAttributedString, _ trueAnswer: String) -> NSMutableAttributedString {        
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
    
    func updateCellCornerRadius(_ cell: WordCell, _ index: Int){
        if index == 0 {
            cell.updateTopCornerRadius(16)
        }

        if index == userAnswerArray.count - 1 {
            cell.updateBottomCornerRadius(16)
        }
    }
}

//MARK: - UITableViewDelegate

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if whichStartPressed == 3 {
            player.playSound(soundSpeed, questionArray[indexPath.row])
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - Layout

extension ResultViewController {
    
    func style(){
        navigationItem.leftBarButtonItem = UIBarButtonItem()
        
        confettiButton.setImage(image: Images.confetti, width: 66, height: 66)
        
        scoreLabel.font = UIFont(name: Fonts.AvenirNextMedium, size: textSize+5)
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1
        
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
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
        
        homeButton.setBackgroundImage(UIImage(systemName: "house.fill"), for: .normal)
        homeButton.tintColor = .white
        homeButton.addTarget(self, action: #selector(homeButtonPressed(_:)),
                             for: .primaryActionTriggered)
        
        refreshButton.setBackgroundImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed(_:)),
                                for: .primaryActionTriggered)
    }
    
    func layout(){
        view.addSubview(confettiButton)
        view.addSubview(scoreLabel)
        view.addSubview(tableView)
        view.addSubview(addedHardWordsButton)
        
        buttonStackView.addArrangedSubview(homeButton)
        buttonStackView.addArrangedSubview(refreshButton)
        
        view.addSubview(buttonStackView)
        
        confettiButton.centerX(inView: view)
        confettiButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        scoreLabel.centerX(inView: view)
        scoreLabel.anchor(top: confettiButton.bottomAnchor, paddingTop: 16)
        
        tableView.anchor(top: scoreLabel.bottomAnchor, left: view.leftAnchor,
                         bottom: buttonStackView.topAnchor, right: view.rightAnchor,
                         paddingTop: 16, paddingLeft: 32,
                         paddingBottom: 32, paddingRight: 16)
        
        addedHardWordsButton.anchor(left: view.leftAnchor, bottom: buttonStackView.topAnchor,
                                    right: view.rightAnchor, paddingLeft: 32,
                                    paddingBottom: 8, paddingRight: 32)
        
        buttonStackView.centerX(inView: view)
        buttonStackView.anchor(bottom: view.bottomAnchor, paddingBottom: 32)
        
        homeButton.setDimensions(height: 40, width: 48)
        refreshButton.setDimensions(height: 40, width: 35)
        
        if addedHardWordsCount > 0 {
            tableView.anchor(bottom: buttonStackView.topAnchor, paddingBottom: 48)
        }
    }
}
