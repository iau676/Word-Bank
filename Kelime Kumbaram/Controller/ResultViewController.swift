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

    //MARK: - IBOutlet
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addedHardWordsLabel: UILabel!
    @IBOutlet weak var confettiButton: UIButton!
    @IBOutlet weak var showWordsButton: UIButton!
    
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    var isWordAddedToHardWords = 0
    var numberOfTrue = 0
    var lastLevel:Int = 0
    var newLevel:Int = 0
    var cardCounter = 0
    var showTable = 1
    var textForLabel = ""
    var userWordCount = ""
    var scoreLabelText = ""
    
    let player = Player()
    
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
        setupTableView()
        setupLabel()
        setupButton()
        calculateNumberOfTrue()
        checkLevelUp()
        updateStatistic()
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
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goNewPoint" {
            let destinationVC = segue.destination as! NewPointViewController
            destinationVC.textForLabel = textForLabel
            destinationVC.userWordCount = userWordCount
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func showWordsButtonPressed(_ sender: UIButton) {
        showTable = (showTable==0) ? 1 : 0
        let title = (showTable==0) ? "Show Words" : "Hide Words"
        showWordsButton.setTitle(title, for: UIControl.State.normal)
        self.tableView.reloadData()
    }
    
    @IBAction func goHomePressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        if whichStartPressed == 4 {
            performSegue(withIdentifier: "goCard", sender: self)
        } else {
            performSegue(withIdentifier: "goToMyQuiz", sender: self)
        }
    }
    
    //MARK: - Helpers
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Colors.raven
        tableView.layer.cornerRadius = 10
    }
    
    func updateRefreshButtonVisibility(){
        if UserDefault.whichButton.getString() == "yellow" && UserDefault.hardWordsCount.getInt() < 2 {
            refreshButton.isHidden = true
        } else {
            refreshButton.isHidden = false
        }
    }
    
    func checkWhichExercise() {
        if whichStartPressed == 4 {
            scoreLabelText = "By studying 25 words\nYou've earned 25 points!"
            numberOfTrue = userAnswer.count
            addedHardWordsLabel.isHidden = true
            showWordsButton.isHidden = true
        } else {
            updateHardWordText()
            scoreLabel.text = "\(numberOfTrue)/\(userAnswer.count)"
            scoreLabelText = "All Correct!"
        }
    }
    
    func setupLabel(){
        scoreLabel.font = scoreLabel.font.withSize(23)
        addedHardWordsLabel.font = addedHardWordsLabel.font.withSize(textSize)
    }
    
    func setupButton(){
        showWordsButton.titleLabel?.font =  showWordsButton.titleLabel?.font.withSize(textSize)
        showWordsButton.isHidden = true
    }
    
    func updateHardWordText(){
        //print how many words added to hard words
        if isWordAddedToHardWords > 0 {
            let WordOrWords = (isWordAddedToHardWords == 1) ? "Word" : "Words"
            addedHardWordsLabel.text = "\(isWordAddedToHardWords) \(WordOrWords) Added to Hard Words"
        } else {
            addedHardWordsLabel.text = ""
        }
    }
    
    func updateStatistic() {
        if UserDefault.whichButton.getString() == "blue" {
            UserDefault.blueExerciseCount.set(UserDefault.blueExerciseCount.getInt()+1)
            UserDefault.blueTrueCount.set(UserDefault.blueTrueCount.getInt()+numberOfTrue)
            UserDefault.blueFalseCount.set(UserDefault.blueFalseCount.getInt()+(userAnswer.count-numberOfTrue))
            if numberOfTrue == userAnswer.count {
                UserDefault.blueAllTrue.set(UserDefault.blueAllTrue.getInt()+1)
            }
            updateExerciseCount()
        }
    }
    
    func updateExerciseCount() {
        switch whichStartPressed {
        case 1:
            UserDefault.start1count.set(UserDefault.start1count.getInt()+1)
            break
        case 2:
            UserDefault.start2count.set(UserDefault.start2count.getInt()+1)
            break
        case 3:
            UserDefault.start3count.set(UserDefault.start3count.getInt()+1)
            break
        case 4:
            UserDefault.start4count.set(UserDefault.start4count.getInt()+1)
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
            showWordsButton.isHidden = whichStartPressed == 4 ?  true : false
            tableView.backgroundColor = .clear
            showTable = 0
            player.observeAppEvents()
            player.setupPlayerIfNeeded(view: view, videoName: "newpoint")
            player.restartVideo()
            confettiButton.isHidden = true
            scoreLabel.text = scoreLabelText
        }
    }
    
    func checkLevelUp(){
        lastLevel = UserDefault.level.getInt()
         _ = wordBrain.calculateLevel()
        newLevel = UserDefault.level.getInt()
        
        UserDefault.goLevelUp.set(0)
        
        if newLevel - lastLevel > 0 {
            performSegue(withIdentifier: "goLevelUp", sender: self)
        }
    }
}

    //MARK: - Show Cell

extension ResultViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (showTable==1) ? userAnswer.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        updateCellLabelText(cell, indexPath.row)
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
