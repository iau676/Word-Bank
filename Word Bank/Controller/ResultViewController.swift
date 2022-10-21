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
    var isWordAddedToHardWords = 0
    var numberOfTrue = 0
    var lastLevel:Int = 0
    var newLevel:Int = 0
    var userWordCount = ""
    var scoreLabelText = ""
    
    var arrayOfIndex: [Int] { return UserDefault.rightOnce.getValue() as? [Int] ?? [Int]() }
    var userAnswer: [Bool] { return UserDefault.rightOnceBool.getValue() as? [Bool] ?? [Bool]() }
    var arrayForResultViewENG: [String] { return UserDefault.arrayForResultViewENG.getValue() as? [String] ?? [String]() }
    var arrayForResultViewTR: [String] { return UserDefault.arrayForResultViewTR.getValue() as? [String] ?? [String]() }
    var arrayForResultViewUserAnswer: [String] { UserDefault.userAnswers.getValue() as? [String] ?? [String]() }
    var selectedSegmentIndex: Int { return UserDefault.selectedSegmentIndex.getInt() }
    var whichStartPressed: Int { return UserDefault.startPressed.getInt() }
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    var soundSpeed: Double { return UserDefault.soundSpeed.getDouble() }
    
    //MARK: - Life Cycle
    
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
        updateUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        updateRefreshButtonVisibility()
        checkWhichExercise()
        checkAllTrue()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    @objc func showWordsButtonPressed(_ sender: UIButton) {
        self.tableView.reloadData()
    }
    
    @objc func homeButtonPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func refreshButtonPressed(_ sender: Any) {
        if whichStartPressed == 4 {
            performSegue(withIdentifier: "goCard", sender: self)
        } else {
            performSegue(withIdentifier: "goQuiz", sender: self)
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
        if UserDefault.whichButton.getString() == "yellow" && UserDefault.hardWordsCount.getInt() < 2 {
            refreshButton.isHidden = true
        } else {
            refreshButton.isHidden = false
        }
    }
    
    func updateHardWordText(){
        //print how many words added to hard words
        if isWordAddedToHardWords > 0 {
            addedHardWordsButton.isHidden = false
            let WordOrWords = (isWordAddedToHardWords == 1) ? "Word" : "Words"
            addedHardWordsButton.setTitle("\(isWordAddedToHardWords) \(WordOrWords) Added to Hard Words", for: .normal)
        } else {
            addedHardWordsButton.isHidden = true
            addedHardWordsButton.setTitle("", for: .normal)
        }
    }
    
    func checkWhichExercise() {
        if whichStartPressed == 4 {
            scoreLabelText = "By studying 20 words\nYou've earned 20 points!"
            numberOfTrue = userAnswer.count
        } else {
            updateHardWordText()
            scoreLabel.text = "\(numberOfTrue)/\(userAnswer.count)"
            scoreLabelText = "All Correct!"
        }
    }
    
    func updateStatistic() {
        if UserDefault.whichButton.getString() == "blue" {
            UserDefault.exerciseCount.set(UserDefault.exerciseCount.getInt()+1)
            UserDefault.trueCount.set(UserDefault.trueCount.getInt()+numberOfTrue)
            UserDefault.falseCount.set(UserDefault.falseCount.getInt()+(userAnswer.count-numberOfTrue))
            if numberOfTrue == userAnswer.count {
                UserDefault.allTrueCount.set(UserDefault.allTrueCount.getInt()+1)
            }
            updateExerciseCount()
        }
    }
    
    func updateUser(){
        wordBrain.user[0].level             = Int16(UserDefault.level.getInt())
        wordBrain.user[0].lastPoint         = Int32(UserDefault.lastPoint.getInt())
        wordBrain.user[0].exerciseCount     = Int16(UserDefault.exerciseCount.getInt())
        wordBrain.user[0].allTrueCount      = Int16(UserDefault.allTrueCount.getInt())
        wordBrain.user[0].testCount         = Int16(UserDefault.testCount.getInt())
        wordBrain.user[0].writingCount      = Int16(UserDefault.writingCount.getInt())
        wordBrain.user[0].listeningCount    = Int16(UserDefault.listeningCount.getInt())
        wordBrain.user[0].cardCount         = Int16(UserDefault.cardCount.getInt())
        wordBrain.user[0].trueCount         = Int16(UserDefault.trueCount.getInt())
        wordBrain.user[0].falseCount        = Int16(UserDefault.falseCount.getInt())
    }
    
    func updateExerciseCount() {
        switch whichStartPressed {
        case 1:
            UserDefault.testCount.set(UserDefault.testCount.getInt()+1)
            break
        case 2:
            UserDefault.writingCount.set(UserDefault.writingCount.getInt()+1)
            break
        case 3:
            UserDefault.listeningCount.set(UserDefault.listeningCount.getInt()+1)
            break
        case 4:
            UserDefault.cardCount.set(UserDefault.cardCount.getInt()+1)
            break
        default: break
        }
    }
    
    func calculateNumberOfTrue() {
        for i in 0..<userAnswer.count {
            if userAnswer[i] == true {
                numberOfTrue += 1
            }
        }
    }
    
    func checkAllTrue(){
        if numberOfTrue == userAnswer.count {
            //showWordsButton.isHidden = whichStartPressed == 4 ?  true : false
            tableView.backgroundColor = .clear
            player.observeAppEvents()
            player.setupPlayerIfNeeded(view: view, videoName: "newpoint")
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

    //MARK: - Show Cell

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userAnswer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        updateCellLabelText(cell, indexPath.row)
        updateCellCornerRadius(cell, indexPath.row)
        updateCellForListeningExercise(cell)
        updateCellLabelTextSize(cell)
        updateCellLabelTextColor(cell)
       
        if userAnswer[indexPath.row] == false {
            updateCellViewBackgroundForWrong(cell)
            updateCellLabelTextForWrong(cell, indexPath.row)
        } else {
            updateCellViewBackgroundForRight(cell)
        }
        return cell
    }
    
    func updateCellLabelText(_ cell: WordCell, _ index: Int){
        let i = arrayOfIndex[index]
        if UserDefault.whichButton.getString() == "blue" {
            if selectedSegmentIndex == 0 {
                cell.engLabel.text = itemArray[i].eng
                cell.trLabel.text = itemArray[i].tr
            } else {
                cell.engLabel.text = itemArray[i].tr
                cell.trLabel.text = itemArray[i].eng
            }
        } else {
            if selectedSegmentIndex == 0 {
                cell.engLabel.text = arrayForResultViewENG[index]
                cell.trLabel.text = arrayForResultViewTR[index]
            } else {
                cell.engLabel.text = arrayForResultViewTR[index]
                cell.trLabel.text = arrayForResultViewENG[index]
                
            }
        }
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
        cell.engView.backgroundColor = Colors.red
        cell.trView.backgroundColor = Colors.lightRed
    }
    
    func updateCellLabelTextForWrong(_ cell: WordCell, _ i: Int){
        if UserDefault.whichButton.getString() == "blue" {
            cell.trLabel.attributedText = writeAnswerCell(arrayForResultViewUserAnswer[i].strikeThrough(),
                                                          (selectedSegmentIndex == 0) ? itemArray[arrayOfIndex[i]].tr ?? "empty" : itemArray[arrayOfIndex[i]].eng ?? "empty")
        } else {
            cell.trLabel.attributedText = writeAnswerCell(arrayForResultViewUserAnswer[i].strikeThrough(),
                                                          (selectedSegmentIndex == 0) ? arrayForResultViewTR[i] : arrayForResultViewENG[i])
        }
    }
    
    func writeAnswerCell(_ userAnswer: NSAttributedString, _ trueAnswer: String) -> NSMutableAttributedString {        
        let boldFontAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: textSize+2)]
        
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

        if index == userAnswer.count - 1 {
            cell.updateBottomCornerRadius(16)
        }
    }
}

//MARK: - Tap Cell

extension ResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if whichStartPressed == 3 {
            var word = ""
            
            switch UserDefault.whichButton.getString() {
            case "blue":
                word = itemArray[arrayOfIndex[indexPath.row]].eng ?? "empty"
                break
            case "yellow":
                word =  arrayForResultViewENG[indexPath.row]
                break
            default: break
            }
            player.playSound(soundSpeed, word)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ResultViewController {
    
    func style(){
        confettiButton.translatesAutoresizingMaskIntoConstraints = false
        confettiButton.setImage(imageName: "confetti", width: 66, height: 66)
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = UIFont(name: "AvenirNext-Regular", size: 17)
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 1
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        tableView.layer.cornerRadius = 16
        tableView.dataSource = self
        tableView.delegate = self
        
        addedHardWordsButton.translatesAutoresizingMaskIntoConstraints = false
        addedHardWordsButton.backgroundColor = .clear
        addedHardWordsButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 17)
        addedHardWordsButton.layer.cornerRadius = 10
        addedHardWordsButton.addTarget(self, action: #selector(showWordsButtonPressed(_:)), for: .primaryActionTriggered)
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fill
        buttonStackView.spacing = 130
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setBackgroundImage(UIImage(systemName: "house.fill"), for: .normal)
        homeButton.tintColor = .white
        homeButton.addTarget(self, action: #selector(homeButtonPressed(_:)), for: .primaryActionTriggered)
        
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setBackgroundImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(refreshButtonPressed(_:)), for: .primaryActionTriggered)
    }
    
    func layout(){
        view.addSubview(confettiButton)
        view.addSubview(scoreLabel)
        view.addSubview(tableView)
        view.addSubview(addedHardWordsButton)
        
        buttonStackView.addArrangedSubview(homeButton)
        buttonStackView.addArrangedSubview(refreshButton)
        
        view.addSubview(buttonStackView)
        
        NSLayoutConstraint.activate([
            confettiButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            confettiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: confettiButton.bottomAnchor, constant: 16),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            tableView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            
            
            addedHardWordsButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            addedHardWordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            addedHardWordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            buttonStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            homeButton.widthAnchor.constraint(equalToConstant: 48),
            homeButton.heightAnchor.constraint(equalToConstant: 40),
            refreshButton.widthAnchor.constraint(equalToConstant: 35),
            refreshButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        if isWordAddedToHardWords > 0 {
            NSLayoutConstraint.activate([
                tableView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -48)
            ])
        }
    }
}
