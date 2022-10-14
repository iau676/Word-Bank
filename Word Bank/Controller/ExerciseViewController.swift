//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class ExerciseViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var progressBar2: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var userPointButton: UIButton!
    @IBOutlet weak var bubbleButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var answerStackView: UIStackView!
    @IBOutlet weak var wordViewConstrait: NSLayoutConstraint!
    //only first question
    @IBOutlet weak var arrowButtonAtAnswerView: UIButton!
    @IBOutlet weak var arrowButtonAtOptionView: UIButton!
    @IBOutlet weak var labelPlaySound: UILabel!
    @IBOutlet weak var switchPlaySound: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionStackView: UIStackView!
    
    //MARK: - Variables
    
    var hint = ""
    var letterCounter = 0
    var showOptions = 0
    var totalQuestionNumber = 20
    var failNumber: [Int] = []
    var failIndex: [Int] = []
    var itemArray: [Item] { return wordBrain.itemArray }
    var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    var questionCount = 0
    var timer = Timer()
    var changedQuestionNumber = 0
    var onlyHereNumber = 0
    var answer = 0    
    var questionText = ""
    var answerForStart23 = ""
    var soundSpeed = Double()
    var rightOnce = [Int]()
    var rightOnceBool = [Bool]()
    var arrayForResultViewUserAnswer = [String]()
    var isWordAddedToHardWords = 0
    var player = Player()
    var wordBrain = WordBrain()
    var whichButton: String { return UserDefault.whichButton.getString() }
    var whichStartPressed : Int { return UserDefault.startPressed.getInt() }
    var wheelPressed = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        getHour()
        
        setupView()
        configureColor()
        configureTextField()
        
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        
        updateUI()
        wordBrain.sortFails()
        
        configureBackBarButton()
        preventInterrupt()
    }

    override func viewWillAppear(_ animated: Bool) { 
        isWordAddedToHardWords = 0
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.isWordAddedToHardWords = wordBrain.getIsWordAddedToHardWords()
        }
    }
    
    func preventInterrupt(){
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }
  
    //MARK: - IBAction
    
    @IBAction func answerPressed(_ sender: UIButton) {
        checkAnswerQ(sender,sender.currentTitle!)
    }
    
    @IBAction func arrowButtonAtAnswerViewPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    
    @IBAction func arrowButtonAtOptionViewPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    
    func arrowButtonsPressed() {
        if showOptions == 0 {
            showOptions = 1
            arrowButtonAtAnswerView.isHidden = true
            arrowButtonAtOptionView.isHidden = false
            updateViewAppearance(optionView, isHidden: false)
            arrowButtonAtOptionView.setImage(imageName: "arrowRight", width: 30, height: 30)
        } else {
            showOptions = 0
            arrowButtonAtAnswerView.isHidden = false
            arrowButtonAtOptionView.isHidden = true
            updateViewAppearance(optionView, isHidden: true)
            arrowButtonAtOptionView.setImage(imageName: "arrowLeft", width: 30, height: 30)
        }
    }
    
    func updateViewAppearance(_ vieW: UIView, isHidden: Bool){
        UIView.transition(with: vieW, duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: {
                            vieW.isHidden = isHidden
                      })
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playSound.set(0)
        } else {
            UserDefault.playSound.set(1)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedSegmentIndex.set(sender.selectedSegmentIndex)
        updateUI()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        if answerForStart23.lowercased() == sender.text!.lowercased() {
            checkAnswerQ(nil,sender.text!)
            textField.text = ""
            bubbleButton.setImage(imageName: "empty", width: 0, height: 0)
            wordBrain.answerTrue()
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        soundButton.bounce()
        if whichStartPressed == 1 {
            if UserDefault.selectedSegmentIndex.getInt() == 0 {
                player.playSound(soundSpeed, questionText)
            }
        } else {
            getLetter()
        }
    }
    
    @IBAction func hourButtonPressed(_ sender: UIButton) {
        bubbleButton.bounce()
        player.playSound(soundSpeed, answerForStart23)
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
        
    //MARK: - Selectors
    
    @objc func updateUI() {
        letterCounter = 0
        hint = ""
        hintLabel.text = ""

        if questionCount < totalQuestionNumber {

            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && questionCount > 0 {
                updateViewAppearance(optionView, isHidden: true)
                self.arrowButtonAtAnswerView.isHidden = true
            }
            bubbleButton.setTitle("", for: UIControl.State.normal)
            
            if whichStartPressed == 3 {
                bubbleButton.setImage(imageName: "sound", width: 66, height: 66)
            } else {
                bubbleButton.isHidden=true
            }
         
            failNumber = UserDefault.failNumber.getValue() as? [Int] ?? [Int]()
            failIndex = UserDefault.failIndex.getValue() as? [Int] ?? [Int]()
                
            questionText = wordBrain.getQuestionText(UserDefault.selectedSegmentIndex.getInt(),questionCount, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = questionText

            //0 is true, 1 is false
            switch whichStartPressed {
            case 1:
                if UserDefault.playSound.getInt() == 0 {
                    if UserDefault.selectedSegmentIndex.getInt() == 0 {
                        if UserDefault.whichButton.getString() == "yellow" {
                            player.playSound(soundSpeed, questionText)
                        } else {
                            player.playSound(soundSpeed, questionText)
                        }
                    }
                }
                break
            case 2:
                progressBar.isHidden = true
                arrowButtonAtAnswerView.isHidden = true
                break
            case 3:
                player.playSound(soundSpeed, answerForStart23)
                progressBar.isHidden = true
                arrowButtonAtAnswerView.isHidden = true
                break
            default: break
            }
            
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
            bubbleButton.setBackgroundImage(nil, for: UIControl.State.normal)
            
        } else {
            questionCount = 0
            performSegue(withIdentifier: "goToResult", sender: self)
        }
    }//updateUI
    
    func refreshAnswerButton(_ button: UIButton, title: String) {
        button.isEnabled = true
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for: .normal)
    }
    
    @objc func hideBubbleButton(){
        if whichStartPressed == 3 {
            bubbleButton.setTitle("", for: UIControl.State.normal)
            bubbleButton.setImage(imageName: "sound", width: 66, height: 66)
        } else {
            bubbleButton.isHidden = true
        }
        
        if whichStartPressed == 2 {
            questionLabel.isHidden = false
        }
    }
    
    @objc func updateHintLabelColor() {
        hintLabel.textColor = Colors.f6f6f6
    }
    
    @objc func updateImg(_ timer: Timer){
        let imgName = timer.userInfo!
        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
        bubbleButton.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    @objc func backButtonPressed(sender : UIButton) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - Helpers
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        return true
    }
    
    func configureColor(){
        questionLabel.textColor = Colors.f6f6f6
        hintLabel.textColor = Colors.f6f6f6
        answer1Button.setTitleColor(Colors.f6f6f6, for: .normal)
        answer2Button.setTitleColor(Colors.f6f6f6, for: .normal)
        userPointButton.changeBackgroundColor(to: Colors.f6f6f6)
        arrowButtonAtAnswerView.tintColor = Colors.f6f6f6
        arrowButtonAtOptionView.tintColor = Colors.f6f6f6
        soundButton.tintColor = Colors.f6f6f6
        progressBar.tintColor = Colors.f6f6f6
        progressBar.tintColor = Colors.f6f6f6
        textField.backgroundColor = Colors.f6f6f6
        textField.textColor = Colors.black
    }
    
    func configureTextField(){
        switch UserDefault.userInterfaceStyle {
        case "dark":
            textField.keyboardAppearance = .dark
            break
        default:
            textField.keyboardAppearance = .default
        }
        textField.delegate = self
        if whichStartPressed != 1 {
            textField.becomeFirstResponder()
        }
    }
    
    func configureBackBarButton(){
        let backButton: UIButton = UIButton()
        let image = UIImage(named: "arrow_back");
        backButton.setImage(image, for: .normal)
        backButton.setTitle(" Back", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector (backButtonPressed(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func setupView(){
        
        bubbleButton.isHidden = true
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progressBar2.isHidden = true
            soundButton.setImage(imageName: "soundLeft", width: 40, height: 40)
        } else {
            answerStackView.isHidden = true
            soundButton.setImage(imageName: "question", width: 35, height: 35)
            
            let newConstraint = wordViewConstrait.constraintWithMultiplier(4)
            wordViewConstrait.isActive = false
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            wordViewConstrait = newConstraint
        }
        
        if whichStartPressed == 3 {
            questionLabel.isHidden = true
            bubbleButton.isHidden = false
        }
        
        // 1 is false, 0 is true
        if UserDefault.playSound.getInt() == 1 {
            switchPlaySound.isOn = false
        } else {
            switchPlaySound.isOn = true
        }
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        segmentedControl.selectedSegmentIndex = UserDefault.selectedSegmentIndex.getInt()
        
        let textSize = UserDefault.textSize.getCGFloat()
        questionLabel.font = questionLabel.font.withSize(textSize)
        answer1Button.titleLabel?.font =  answer1Button.titleLabel?.font.withSize(textSize)
        answer2Button.titleLabel?.font =  answer2Button.titleLabel?.font.withSize(textSize)
        userPointButton.titleLabel?.font =  userPointButton.titleLabel?.font.withSize(textSize)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        
        userPointButton.layer.cornerRadius = 12
        userPointButton.setTitle(String(UserDefault.lastPoint.getInt().withCommas()), for: UIControl.State.normal)
        
        progressBar.progress = 0
        progressBar2.progress = 0
        questionLabel.numberOfLines = 6
        questionLabel.adjustsFontSizeToFitWidth = true
        
        setupAnswerButton(answer1Button)
        setupAnswerButton(answer2Button)
        
        arrowButtonAtAnswerView.setImage(imageName: "arrowLeft", width: 30, height: 30)
        optionView.isHidden = true
        showOptions = 0
    }//setupView
    
    func setupAnswerButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)

        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 5
        button.layer.borderColor = Colors.testAnswerLayer?.cgColor
    }
    
    func getLetter(){
        let answer = wordBrain.getAnswer()
        let answerWithoutSpace = answer.replace(string: " ", replacement: "")
        var skeleton = ""
        var skeletonArr = [Int]()
        
        for i in 0..<answer.count {
            if answer[i] != " " {
                skeleton.append(" _")
            } else {
                skeleton.append("  ")
            }
        }
        
        for i in 0..<skeleton.count {
            if skeleton[i] == "_" {
                skeletonArr.append(i)
            }
        }
        
        if letterCounter == 0 {
            hint = skeleton
        }
        
        if letterCounter < skeletonArr.count {
            hint = hint.replace(skeletonArr[letterCounter], "\(answerWithoutSpace[letterCounter])")
            letterCounter += 1
            hintLabel.text = hint
            decreaseOnePoint()
            player.playMP3("beep")
        } else {
            hintLabel.textColor = Colors.green
            hintLabel.flash()
            scheduledTimer(timeInterval: 0.8, #selector(updateHintLabelColor))
        }
    }
    
    func getHour() {
        UserDefault.lastHour.set(Calendar.current.component(.hour, from: Date()))
    }

    func checkAnswerQ(_ sender: UIButton? = nil, _ userAnswer: String){
        getHour()
        questionCount += 1
        let progrs = wordBrain.getProgress()
        progressBar.progress = progrs
        progressBar2.progress = progrs
        
        var exercisePoint = 0
        var userGotItRight = true
        
        if whichStartPressed == 1 {
            userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased()
            if whichButton == "yellow" {
                wordBrain.arrayForResultView()
            }
        }
        
        let lastPoint = UserDefault.lastPoint.getInt()
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefault.userAnswers.set(arrayForResultViewUserAnswer)
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        bubbleButton.isHidden = false
        questionLabel.text = ""
        
        exercisePoint = UserDefault.exercisePoint.getInt()
        
        switch whichStartPressed {
        case 0:
            exercisePoint = 1
            break
        case 2:
            exercisePoint += 10
            break
        case 3:
            exercisePoint += 20
            break
        default: break
        }
        
        if UserDefault.lastHour.getInt() == UserDefault.userSelectedHour.getInt() {
            exercisePoint *= 2
        }
        
        if userGotItRight {
            player.playMP3("true")
            
            if whichButton == "blue" {
                wordBrain.userGotItCorrect()
            } else {
                if wordBrain.updateCorrectCountHardWord() { questionCount = totalQuestionNumber }
            }
            
            sender?.backgroundColor = Colors.green
            bubbleButton.setTitleColor(Colors.green, for: .normal)
            userPointButton.setTitle(String((lastPoint+exercisePoint).withCommas()), for: UIControl.State.normal)
            bubbleButton.setTitle(String("+\(exercisePoint)"), for: UIControl.State.normal)
            
            timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "greenBubble")
            timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "greenBubble2")
            timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "greenBubble3")
            timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "greenBubble4")
            
            UserDefault.lastPoint.set(lastPoint+exercisePoint)
        } else {
            player.playMP3("false")
            
            if whichButton == "blue" {
                wordBrain.userGotItWrong()
            } else {
                wordBrain.updateWrongCountHardWords()
            }
           
            sender?.backgroundColor = Colors.red
            bubbleButton.setTitleColor(Colors.red, for: .normal)
            userPointButton.setTitle(String((lastPoint-exercisePoint).withCommas()), for: UIControl.State.normal)
            bubbleButton.setTitle(String(-exercisePoint), for: UIControl.State.normal)
            
            timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "redBubble")
            timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "redBubble2")
            timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "redBubble3")
            timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "redBubble4")
            
            UserDefault.lastPoint.set(lastPoint-exercisePoint)
        }
      
        wordBrain.nextQuestion()
 
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
    }
    
    func rotateBubbleButton(timeInterval: Double, userInfo: String) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateImg(_:)), userInfo: userInfo, repeats: false)
    }
    
    func decreaseOnePoint(){
        let lastPoint = UserDefault.lastPoint.getInt()
        
        questionLabel.isHidden = true
        bubbleButton.isHidden = false
        
        bubbleButton.setTitleColor(Colors.red, for: .normal)
        bubbleButton.setImage(imageName: "empty", width: 0, height: 0)
        bubbleButton.setTitle(String(-1), for: UIControl.State.normal)
        userPointButton.setTitle(String((lastPoint-1).withCommas()), for: UIControl.State.normal)
        
        scheduledTimer(timeInterval: 0.4, #selector(hideBubbleButton))
        
        UserDefault.lastPoint.set(lastPoint-1)
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }

}
