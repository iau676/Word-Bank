//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class WordsQuizViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var progressBar2: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var userPointButton: UIButton!
    @IBOutlet weak var pointButton: UIButton!
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
    var failNumber: [Int] = []
    var failIndex: [Int] = []
    var itemArray: [Item] { return wordBrain.itemArray }
    var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    var questionCount = 0
    var timer = Timer()
    var questionNumber = 0
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
    var whichStartPressed : Int { return wordBrain.startPressed.getInt() }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        getHour()
        
        textField.delegate = self
        
        setupView()
        
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        fillQuestionNumbers()
        
        updateUI()
        wordBrain.sortFails()
        
        preventInterrupt()
    }

    override func viewWillAppear(_ animated: Bool) { 
        isWordAddedToHardWords = 0
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.option = "my"
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
            wordBrain.playSound.set(0)
        } else {
            wordBrain.playSound.set(1)
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        wordBrain.selectedSegmentIndex.set(sender.selectedSegmentIndex)
        updateUI()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        print(answerForStart23)
        if answerForStart23.lowercased() == sender.text!.lowercased() {
            checkAnswerQ(nil,sender.text!)
            textField.text = ""
            pointButton.setImage(imageName: "empty", width: 0, height: 0)
            wordBrain.answerTrue()
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        soundButton.flash()
        if whichStartPressed == 1 {
            if wordBrain.selectedSegmentIndex.getInt() == 0 {
                player.playSound(soundSpeed, questionText)
            }
        } else {
            getLetter()
        }
    }
    
    @IBAction func hourButtonPressed(_ sender: UIButton) {
        pointButton.flash()
        player.playSound(soundSpeed, answerForStart23)
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: - Objc Function
    
    @objc func updateUI() {
        letterCounter = 0
        hint = ""
        hintLabel.text = ""

        if questionCount < 3 {

            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && questionCount > 0 {
                updateViewAppearance(optionView, isHidden: true)
                self.arrowButtonAtAnswerView.isHidden = true
            }
            pointButton.setTitle("", for: UIControl.State.normal)
            
            if whichStartPressed == 3 {
                pointButton.setImage(imageName: "sound", width: 66, height: 66)
            } else {
                pointButton.isHidden=true
            }
         
            failNumber = wordBrain.failNumber.getValue() as? [Int] ?? [Int]()
            failIndex = wordBrain.failIndex.getValue() as? [Int] ?? [Int]()
                
            questionText = wordBrain.getQuestionText(wordBrain.selectedSegmentIndex.getInt(),questionCount, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = questionText

            questionNumbersCopy = questionNumbers
            questionNumbersCopy.remove(at: questionNumber)
                
            //0 is true, 1 is false
            switch whichStartPressed {
            case 1:
                if wordBrain.playSound.getInt() == 0 {
                    if wordBrain.selectedSegmentIndex.getInt() == 0 {
                        if wordBrain.whichButton.getString() == "yellow" {
                            player.playSound(soundSpeed, questionText)
                        } else {
                            player.playSound(soundSpeed, questionText)
                        }
                    }
                }
                break
            case 2:
                textField.becomeFirstResponder()
                break
            case 3:
                player.playSound(soundSpeed, answerForStart23)
                textField.becomeFirstResponder()
                break
            default: break
            }
            
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
            pointButton.setBackgroundImage(nil, for: UIControl.State.normal)
            
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
            pointButton.setTitle("", for: UIControl.State.normal)
            pointButton.setImage(imageName: "sound", width: 66, height: 66)
        } else {
            pointButton.isHidden = true
        }
        
        if whichStartPressed == 2 {
            questionLabel.isHidden = false
        }
    }
    
    @objc func updateHintLabelColor() {
        hintLabel.textColor = UIColor(hex: "#d6d6d6")
    }
    
    @objc func updateImg(_ timer: Timer){
        let imgName = timer.userInfo!
        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
        pointButton.setBackgroundImage(image, for: UIControl.State.normal)
    }

    //MARK: - Other Functions
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        return true
    }
    
    func setupView(){
        
        pointButton.isHidden = true
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progressBar2.isHidden = true
            soundButton.setImage(imageName: "soundLeft", width: 40, height: 40)
        } else {
            answerStackView.isHidden = true
            soundButton.setImage(imageName: "question", width: 35, height: 35)
//            textField.attributedPlaceholder = NSAttributedString(string: whichStartPressed == 2 ? "..." : "...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)])
            
            let newConstraint = wordViewConstrait.constraintWithMultiplier(4)
            wordViewConstrait.isActive = false
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            wordViewConstrait = newConstraint
        }
        
        if whichStartPressed == 3 {
            questionLabel.isHidden = true
            pointButton.isHidden = false
        }
        
        // 1 is false, 0 is true
        if wordBrain.playSound.getInt() == 1 {
            switchPlaySound.isOn = false
        } else {
            switchPlaySound.isOn = true
        }
        
        soundSpeed = wordBrain.soundSpeed.getDouble()
        segmentedControl.selectedSegmentIndex = wordBrain.selectedSegmentIndex.getInt()
        
        let textSize = wordBrain.textSize.getCGFloat()
        questionLabel.font = questionLabel.font.withSize(textSize)
        answer1Button.titleLabel?.font =  answer1Button.titleLabel?.font.withSize(textSize)
        answer2Button.titleLabel?.font =  answer2Button.titleLabel?.font.withSize(textSize)
        userPointButton.titleLabel?.font =  userPointButton.titleLabel?.font.withSize(textSize)
        
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        
        userPointButton.layer.cornerRadius = 12
        userPointButton.setTitle(String(wordBrain.lastPoint.getInt().withCommas()), for: UIControl.State.normal)
        
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
        button.layer.borderColor = UIColor(hex: "#47668f")?.cgColor
    }
    
    func getLetter(){
        let str = wordBrain.getAnswer()
        
        if letterCounter < str.count {
            hint = "\(hint+str[letterCounter])"
            
            letterCounter += 1
            
            let number = str.count-letterCounter
            var hintSpace = ""
            
            for _ in 0..<number {
                hintSpace = "\(hintSpace) _"
            }
            hintLabel.text = "\(hint+hintSpace)"
            decreaseOnePoint()
            player.playMP3("beep")
        } else {
            hintLabel.textColor = UIColor(hex: "#2bbd85")
            hintLabel.flash()
            Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(updateHintLabelColor), userInfo: nil, repeats: false)
        }
    }
    
    func getHour() {
        wordBrain.lastHour.set(Calendar.current.component(.hour, from: Date()))
    }

    func checkAnswerQ(_ sender: UIButton? = nil, _ userAnswer: String){
        getHour()
        questionCount += 1
        let progrs = wordBrain.getProgress()
        progressBar.progress = progrs
        progressBar2.progress = progrs
        
        var userPoint = 0
        var userGotItRight = true
        
        if whichStartPressed == 1 {
            userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased() ? true : false
        }
        
        let lastPoint = wordBrain.lastPoint.getInt()
        arrayForResultViewUserAnswer.append(userAnswer)
        wordBrain.userAnswers.set(arrayForResultViewUserAnswer)
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        pointButton.isHidden = false
        questionLabel.text = ""
        
        userPoint = wordBrain.pointForMyWords.getInt()
        
        print("userPoint> \(userPoint)")
        
        switch whichStartPressed {
        case 0:
            userPoint = 1
            break
        case 2:
            userPoint += 10
            break
        case 3:
            userPoint += 20
            break
        default: break
        }
        
        if wordBrain.lastHour.getInt() == wordBrain.userSelectedHour.getInt() {
            userPoint *= 2
        }
        
        if userGotItRight {
            player.playMP3("true")
            wordBrain.userGotItCorrect()
            
            sender?.backgroundColor = UIColor(hex: "#2bbd85")
            pointButton.setTitleColor(UIColor(hex: "#2bbd85"), for: .normal)
            userPointButton.setTitle(String((lastPoint+userPoint).withCommas()), for: UIControl.State.normal)
            pointButton.setTitle(String("+\(userPoint)"), for: UIControl.State.normal)
            
            timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "greenBubble")
            timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "greenBubble2")
            timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "greenBubble3")
            timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "greenBubble4")
            
            wordBrain.lastPoint.set(lastPoint+userPoint)
        } else {
            player.playMP3("false")
            wordBrain.userGotItWrong()
           
            sender?.backgroundColor = UIColor(hex: "#ff6370")
            pointButton.setTitleColor(UIColor(hex: "#ff6370"), for: .normal)
            userPointButton.setTitle(String((lastPoint-userPoint).withCommas()), for: UIControl.State.normal)
            pointButton.setTitle(String(-userPoint), for: UIControl.State.normal)
            
            timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "redBubble")
            timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "redBubble2")
            timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "redBubble3")
            timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "redBubble4")
            
            wordBrain.lastPoint.set(lastPoint-userPoint)
        }
      
        wordBrain.nextQuestion()
            
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    func rotateBubbleButton(timeInterval: Double, userInfo: String) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateImg(_:)), userInfo: userInfo, repeats: false)
    }
    
    func decreaseOnePoint(){
        let lastPoint = wordBrain.lastPoint.getInt()
        
        questionLabel.isHidden = true
        pointButton.isHidden = false
        
        pointButton.setTitleColor(UIColor(hex: "#ff6370"), for: .normal)
        pointButton.setImage(imageName: "empty", width: 0, height: 0)
        pointButton.setTitle(String(-1), for: UIControl.State.normal)
        userPointButton.setTitle(String((lastPoint-1).withCommas()), for: UIControl.State.normal)
    
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideBubbleButton), userInfo: nil, repeats: false)
        
        wordBrain.lastPoint.set(lastPoint-1)
    }
    
    func fillQuestionNumbers() {
        for i in 0...itemArray.count-1 {
            questionNumbers.append(i)
        }
    }

}
