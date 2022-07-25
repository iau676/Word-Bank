//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class HardWordsQuizViewController: UIViewController, UITextFieldDelegate {
    
    //This didn't crash my app but caused a memory leak every time AVSpeechSynthesizer was declared. I solved this by declaring the AVSpeechSynthesizer as a global variable
    static let synth = AVSpeechSynthesizer()
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var progrssBar2: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var userPointButton: UIButton!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerStackView: UIStackView!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var wordViewConstrait: NSLayoutConstraint!
    //only first question
    @IBOutlet weak var firstArrowButton: UIButton!
    @IBOutlet weak var arrowButton: UIButton!
    @IBOutlet weak var labelPlaySound: UILabel!
    @IBOutlet weak var switchPlaySound: UISwitch!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var optionView: UIView!
    @IBOutlet weak var optionStackView: UIStackView!
    
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    var player: AVAudioPlayer!
    var timer = Timer()
    var totalQuestionNumber = 3
    var showOptions = 0
    var questionNumber = 0
    var letterCounter = 0
    var text = ""
    var answerForStart23 = ""
    var hint = ""
    var answer = ""
    var selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    var whichStartPressed = UserDefaults.standard.integer(forKey: "startPressed")
    var soundSpeed = UserDefaults.standard.float(forKey: "soundSpeed")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var arrayForResultView = [HardItem]()
    var arrayForResultViewUserAnswer = [String]()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        getHour()
        pointButton.isHidden = true
        
        textField.delegate = self
        setupView()
        updateByWhichStartPressed()
        updateUI()
        
        preventInterrupt()
    }
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.isWordAddedToHardWords = wordBrain.getIsWordAddedToHardWords()
        }
    }
    
    //MARK: - IBAction

    @IBAction func soundButtonPressed(_ sender: UIButton) {
        soundButton.flash()
        if whichStartPressed == 1 && selectedSegmentIndex == 0 {
            playSound(text, "en-US")
        } else {
            getLetter()
        }
    }
    
    @IBAction func firstArrowButtonPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    
    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    
    @IBAction func switchPressed(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "playSound")
        } else {
            UserDefaults.standard.set(1, forKey: "playSound")
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        UserDefaults.standard.set(sender.selectedSegmentIndex, forKey: "selectedSegmentIndex")
        selectedSegmentIndex = sender.selectedSegmentIndex
        updateUI()
    }
    
    @IBAction func textChanged(_ sender: UITextField) {
        print(answerForStart23)
        if answerForStart23.lowercased() == sender.text!.lowercased() {
            checkAnswer(nil,sender.text!)
            textField.text = ""
            pointButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
                UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
            wordBrain.answerTrue()
            if whichStartPressed == 2 {
                playSound(answerForStart23, "en-US")
            }
        }
    }
    
    @IBAction func hourButtonPressed(_ sender: UIButton) {
        pointButton.flash()
        playSound(text, "en-US")
    }
    
    @IBAction func answerPressed(_ sender: UIButton) {
        checkAnswer(sender, sender.currentTitle!)
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Objc Functions
    
    @objc func updateUI() {
        
        letterCounter = 0
        hint = ""
        hintLabel.text = ""
        
        if questionNumber < totalQuestionNumber {
    
           updateByWhichStartPressed()
            
            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && questionNumber > 0{
                UIView.transition(with: optionStackView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.optionView.isHidden = true
                                    self.firstArrowButton.isHidden = true
                              })
            }

            if whichStartPressed == 3 {
                pointButton.setImage(imageRenderer(imageName: "sound", width: 66, height: 66), for: .normal)
            } else {
                pointButton.isHidden=true
            }
 
            text = wordBrain.getQuestionText(selectedSegmentIndex, questionNumber, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = text
            
            switch whichStartPressed {
            case 1:
                // 0 is true
                if  UserDefaults.standard.integer(forKey: "playSound") == 0 && selectedSegmentIndex == 0 {
                    playSound(text, "en-US")
                }
                break
            case 2:
                textField.becomeFirstResponder()
                break
            case 3:
                playSound(text, "en-US")
                textField.becomeFirstResponder()
                break
            default: break
            }

            answer1Button.isEnabled = true
            answer2Button.isEnabled = true
            
            answer2Button.isHidden = false
            answer1Button.setTitle(wordBrain.getAnswer(0), for: .normal)
            answer2Button.setTitle(wordBrain.getAnswer(1), for: .normal)
            
            answer1Button.backgroundColor = UIColor.clear
            answer2Button.backgroundColor = UIColor.clear
            pointButton.setTitle(" ", for: UIControl.State.normal)
            pointButton.setBackgroundImage(nil, for: UIControl.State.normal)
        } else {
            questionNumber = 0
            performSegue(withIdentifier: "goToResult", sender: self)
        }
    }//updateUI
    
    @objc func updateImg(_ timer: Timer){
        let imgName = timer.userInfo!
        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
        pointButton.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    @objc func updateHintLabelColor() {
        hintLabel.textColor = UIColor(named: "d6d6d6")
    }
    
    @objc func updateCheckColors(){
         answer1Button.isEnabled = true
         answer2Button.isEnabled = true
         answer1Button.backgroundColor = UIColor.clear
         answer2Button.backgroundColor = UIColor.clear
         questionLabel.text = text
         pointButton.isHidden = false
         pointButton.setTitle(" ", for: UIControl.State.normal)
         pointButton.setBackgroundImage(nil, for: UIControl.State.normal)
     }
     
     @objc func hideBubbleButton(){
         if whichStartPressed == 3 {
             pointButton.setTitle("", for: UIControl.State.normal)
             pointButton.setImage(imageRenderer(imageName: "sound", width: 66, height: 66), for: .normal)
         } else {
             pointButton.isHidden = true
         }
         
         if whichStartPressed == 2 {
             questionLabel.isHidden = false
         }
     }
    
    //MARK: - Other Functions
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
            getLetter()
            return true
    }
    
    func arrowButtonsPressed() {
        if showOptions == 0 {
            showOptions = 1
            firstArrowButton.isHidden = true
            arrowButton.isHidden = false
            optionView.updateViewVisibility(false)
            arrowButton.setImage(imageRenderer(imageName: "arrowRight", width: 30, height: 30), for: .normal)
        } else {
            showOptions = 0
            firstArrowButton.isHidden = false
            arrowButton.isHidden = true
            optionView.updateViewVisibility(true)
            arrowButton.setImage(imageRenderer(imageName: "arrowLeft", width: 30, height: 30), for: .normal)
        }
    }
    
    func setupView(){
        // 1 is false, 0 is true
        if UserDefaults.standard.integer(forKey: "playSound") == 1 {
            switchPlaySound.isOn = false
        } else {
            switchPlaySound.isOn = true
        }
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
        
        let textSize = CGFloat(UserDefaults.standard.integer(forKey: "textSize"))
        questionLabel.font = questionLabel.font.withSize(textSize)
        answer1Button.titleLabel?.font =  answer1Button.titleLabel?.font.withSize(textSize)
        answer2Button.titleLabel?.font =  answer2Button.titleLabel?.font.withSize(textSize)
        userPointButton.titleLabel?.font =  userPointButton.titleLabel?.font.withSize(textSize)

        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        
        userPointButton.layer.cornerRadius = 12
    
        userPointButton.setTitle(String(UserDefaults.standard.integer(forKey: "lastPoint").withCommas()), for: UIControl.State.normal)
  
        progressBar.progress = 0
        progrssBar2.progress = 0
        
        questionLabel.numberOfLines = 6
        questionLabel.adjustsFontSizeToFitWidth = true
        
        setupAnswerButton(answer1Button)
        setupAnswerButton(answer2Button)
        
        firstArrowButton.setImage(imageRenderer(imageName: "arrowLeft", width: 30, height: 30), for: .normal)
        
        optionView.isHidden = true
            
        showOptions = 0
    }//setupView
    
    func setupAnswerButton(_ button: UIButton){
        button.titleLabel?.numberOfLines = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)
        
        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor(red: 0.28, green: 0.40, blue: 0.56, alpha: 1.00).cgColor
    }

    func updateByWhichStartPressed() {
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progrssBar2.isHidden = true
            answerStackView.isHidden = false
            questionLabel.isHidden = false
            updateViewConstraints(2)
            soundButton.setImage(imageRenderer(imageName: "soundLeft", width: 40, height: 40), for: .normal)
        } else {
            answerStackView.isHidden = true
            textFieldStackView.isHidden = false
            progrssBar2.isHidden = false
            soundButton.setImage(imageRenderer(imageName: "question", width: 35, height: 35), for: .normal)
            
            textField.attributedPlaceholder = NSAttributedString(string: whichStartPressed == 2 ? "İngilizcesi..." : "Yazılışı...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)])
            
            updateViewConstraints(4)
        }
        
        if whichStartPressed == 3 {
            questionLabel.isHidden = true
            pointButton.isHidden = false
        }
        
        if whichStartPressed == 0 {
            answerStackView.isHidden = false
            textFieldStackView.isHidden = true
            progrssBar2.isHidden = true
            soundButton.setImage(imageRenderer(imageName: "soundLeft", width: 40, height: 40), for: .normal)
        }
    }
    
    func updateViewConstraints(_ double: Double) {
        let newConstraint = wordViewConstrait.constraintWithMultiplier(double)
        wordViewConstrait.isActive = false
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        wordViewConstrait = newConstraint
    }
    
    func getHour() {
        UserDefaults.standard.set(Calendar.current.component(.hour, from: Date()), forKey: "lastHour")
        UserDefaults.standard.synchronize()
    }
    
    func playSound(_ soundName: String, _ language: String)
    {
        let u = AVSpeechUtterance(string: soundName)
        u.voice = AVSpeechSynthesisVoice(language: language)
        u.rate = soundSpeed
        HardWordsQuizViewController.synth.speak(u)
    }
    
    func playMP3(_ soundName: String)
    {
        if UserDefaults.standard.integer(forKey: "playAppSound") == 0 {
            let url = Bundle.main.url(forResource: "/sounds/\(soundName)", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                 try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                 print(error)
               }
            player.play()
        }
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
            playMP3("beep")
        } else {
            hintLabel.textColor =  UIColor(named: "greenColorSingle")
            hintLabel.flash()
            Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(updateHintLabelColor), userInfo: nil, repeats: false)
        }
        
    }
    
    func checkAnswer(_ sender: UIButton? = nil, _ userAnswer: String){
        
        getHour()
        selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
        questionNumber += 1
        
        var userPoint = 0
        var userGotItRight = true

        userPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        
        switch whichStartPressed {
            case 2:
                    userPoint += 10
                    break
            case 3:
                    userPoint += 20
                    break
            default: break
        }
        
        if UserDefaults.standard.integer(forKey: "lastHour") == UserDefaults.standard.integer(forKey: "userSelectedHour") {
            userPoint = userPoint * 2
        }
        
        let progrs = wordBrain.getProgress() // should work one time
        progressBar.progress = progrs
        progrssBar2.progress = progrs
        
        if whichStartPressed == 1 {
            userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased()
            wordBrain.arrayForResultView()
        }
        
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefaults.standard.set(arrayForResultViewUserAnswer, forKey: "arrayForResultViewUserAnswer")
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        pointButton.isHidden = false
        questionLabel.text = ""
            
            if userGotItRight {
                playMP3("true")
                
                if wordBrain.updateRightCountHardWords() { questionNumber = totalQuestionNumber }
                
                sender?.backgroundColor = UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00)
                pointButton.setTitleColor(UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00), for: .normal)
                       
                userPointButton.setTitle(String((lastPoint+userPoint).withCommas()), for: UIControl.State.normal)
                pointButton.setTitle(String("+\(userPoint)"), for: UIControl.State.normal)
                
                timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "greenBubble")
                timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "greenBubble2")
                timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "greenBubble3")
                timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "greenBubble4")
                
                UserDefaults.standard.set(lastPoint+userPoint, forKey: "lastPoint")
  
            } else {
                playMP3("false")
                
                wordBrain.updateWrongCountHardWords()
                
                sender?.backgroundColor = UIColor(red: 0.92, green: 0.36, blue: 0.44, alpha: 1.00)
                pointButton.setTitleColor(UIColor(red: 0.92, green: 0.36, blue: 0.44, alpha: 1.00), for: .normal)
                
                userPointButton.setTitle(String((lastPoint-userPoint).withCommas()), for: UIControl.State.normal)
                pointButton.setTitle(String(-userPoint), for: UIControl.State.normal)
                
                timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "redBubble")
                timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "redBubble2")
                timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "redBubble3")
                timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "redBubble4")
                
                UserDefaults.standard.set((lastPoint-userPoint), forKey: "lastPoint")
            }
            UserDefaults.standard.synchronize()
        
            wordBrain.nextQuestion()
            Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        
    }//checkAnswer
    
    func rotateBubbleButton(timeInterval: Double, userInfo: String) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateImg(_:)), userInfo: userInfo, repeats: false)
    }
    
    func decreaseOnePoint(){
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        
        pointButton.isHidden = false
        questionLabel.isHidden = true
        
        pointButton.setTitleColor(UIColor(red: 1.00, green: 0.56, blue: 0.62, alpha: 1.00), for: .normal)
        pointButton.setImage(imageRenderer(imageName: "empty", width: 0, height: 0), for: .normal)
        
        userPointButton.setTitle(String((lastPoint-1).withCommas()), for: UIControl.State.normal)
        pointButton.setTitle(String(-1), for: UIControl.State.normal)
    
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideBubbleButton), userInfo: nil, repeats: false)
        
        UserDefaults.standard.set((lastPoint-1), forKey: "lastPoint")
    }
    
    func imageRenderer(imageName: String, width: CGFloat, height: CGFloat) -> UIImage{
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            UIImage(named: imageName)?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }
    }
    
    func preventInterrupt(){
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }
    
}
