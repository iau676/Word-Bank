//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class QuizViewController: UIViewController, UITextFieldDelegate {
    
    //This didn't crash my app but caused a memory leak every time AVSpeechSynthesizer was declared. I solved this by declaring the AVSpeechSynthesizer as a global variable
    static let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!

    @IBOutlet weak var progrssBar2: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var hourButton: UIButton!
    
    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var answerView: UIView!
    
    @IBOutlet weak var answerStackView: UIStackView!
    
    @IBOutlet weak var textFieldStackView: UIStackView!
    
    
    @IBOutlet weak var hintLabel: UILabel!
    var hint = ""
    var letterCounter = 0
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
    var showOptions = 0
  
    var text = ""
    var answerForStart23 = ""
    var whichStartPressed = 1
    var questionNumber = 0
    var answer = ""
    var selectedSegmentIndex = 0
    var totalQuestionNumber = 0
    var soundSpeed = Float()
    
    var player: AVAudioPlayer!
    
    var wordBrain = WordBrain()
    var twenty_three = 0
    
    var timer = Timer()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var quizCoreDataArray = [AddedList]()
    var arrayForResultView = [HardItem]()
    
    var arrayForResultViewUserAnswer = [String]()
    
    var failsDictionary =  [Int:Int]()
    var sortedFailsDictionary = Array<(key: Int, value: Int)>()
    var sortedFailsDictionaryKey = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        
        getHour()
        hourButton.isHidden = true
        
        textField.delegate = self
        
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            optionView.isHidden = true
            firstArrowButton.isHidden = true
            totalQuestionNumber = 30
            whichStartPressed = 1
        } else {
            whichStartPressed = UserDefaults.standard.integer(forKey: "startPressed")
            totalQuestionNumber = 25
        }
        
        updateByWhichStartPressed()
        
        // 1 is false, 0 is true
        if UserDefaults.standard.integer(forKey: "playSound") == 1 {
            switchPlaySound.isOn = false
        } else {
            switchPlaySound.isOn = true
        }
        soundSpeed = UserDefaults.standard.float(forKey: "soundSpeed")
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
        
        let textSize = CGFloat(UserDefaults.standard.integer(forKey: "textSize"))
        questionLabel.font = questionLabel.font.withSize(textSize)
        answer1Button.titleLabel?.font =  answer1Button.titleLabel?.font.withSize(textSize)
        answer2Button.titleLabel?.font =  answer2Button.titleLabel?.font.withSize(textSize)
        pointButton.titleLabel?.font =  pointButton.titleLabel?.font.withSize(textSize)

        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        
        pointButton.layer.cornerRadius = 12
    
        pointButton.setTitle(String(UserDefaults.standard.integer(forKey: "lastPoint").withCommas()), for: UIControl.State.normal)
  
        progressBar.progress = 0
        progrssBar2.progress = 0
        
        questionLabel.numberOfLines = 6
        questionLabel.adjustsFontSizeToFitWidth = true
        
        answer1Button.titleLabel?.numberOfLines = 3
        answer2Button.titleLabel?.numberOfLines = 3
        answer1Button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)
        answer2Button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)
        
        answer1Button.backgroundColor = .clear
        answer1Button.layer.cornerRadius = 18
        answer1Button.layer.borderWidth = 5
        answer1Button.layer.borderColor = UIColor(red: 0.28, green: 0.40, blue: 0.56, alpha: 1.00).cgColor
        
        answer2Button.backgroundColor = .clear
        answer2Button.layer.cornerRadius = 18
        answer2Button.layer.borderWidth = 5
        answer2Button.layer.borderColor = UIColor(red: 0.28, green: 0.40, blue: 0.56, alpha: 1.00).cgColor

        firstArrowButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: "arrowLeft")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30)) }, for: .normal)
        
        optionView.isHidden = true
        
                
        showOptions = 0
        updateUI()
        loadsQuizCoreDataArray()
        
        selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
        
        
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        
    } //viewdidload
    
    func loadsQuizCoreDataArray(with request: NSFetchRequest<AddedList> = AddedList.fetchRequest()){
        do {
            quizCoreDataArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            getLetter()
        } else {
            if wordBrain.rightOnceBool.count == wordBrain.rightOnce.count-1 { // prevent out of range
                self.checkAnswer(nil,self.textField.text!)
                self.textField.text = ""
                self.hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
                    UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
                self.wordBrain.answerFalse()
                print("self.wordBrain.answerFalse()")
            }
        }
        
            return true
        }

    

    @IBAction func soundButtonPressed(_ sender: UIButton) {
      
        soundButton.flash()

        if whichStartPressed == 1 || whichStartPressed == 0 {
            if selectedSegmentIndex == 0 {
                playSound(text, "en-US")
            } else {
                //playSound(text, "tr-TR")
            }
        } else {
            //playSound(text, "en-US")
            getLetter()
        }
    }
    
    //MARK: - getLetter
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
            Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(changeLabelColor), userInfo: nil, repeats: false)
        }
        
    }
    
    @objc func changeLabelColor() {
        hintLabel.textColor = UIColor(named: "d6d6d6")
    }
    
    
    @IBAction func firstArrowButtonPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    

    @IBAction func arrowButtonPressed(_ sender: UIButton) {
        arrowButtonsPressed()
    }
    
    func arrowButtonsPressed() {
        if showOptions == 0 {
            showOptions = 1
            firstArrowButton.isHidden = true
            arrowButton.isHidden = false
            UIView.transition(with: optionStackView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.optionView.isHidden = false
                          })
            arrowButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                UIImage(named: "arrowRight")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30)) }, for: .normal)
        } else {
            showOptions = 0
            firstArrowButton.isHidden = false
            arrowButton.isHidden = true
            UIView.transition(with: optionStackView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.optionView.isHidden = true
                          })
            
            arrowButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
                UIImage(named: "arrowLeft")?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30)) }, for: .normal)
        }
    }
    
    
    @IBAction func switchPressed(_ sender: UISwitch) {

        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "playSound")
            //soundButton.isHidden = false
        } else {
            UserDefaults.standard.set(1, forKey: "playSound")
            //soundButton.isHidden = true
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
            hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
                UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
            wordBrain.answerTrue()
            if whichStartPressed == 2 {
                playSound(answerForStart23, "en-US")
            }
        }
    }
    
    
    @IBAction func hourButtonPressed(_ sender: UIButton) {
        hourButton.flash()
        playSound(text, "en-US")
    }
    
    
    @IBAction func answerPressed(_ sender: UIButton) {
        checkAnswer(sender, sender.currentTitle!)
    }
    
    
    func updateByWhichStartPressed() {
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progrssBar2.isHidden = true
            answerStackView.isHidden = false
            questionLabel.isHidden = false
            
            
            let newConstraint = wordViewConstrait.constraintWithMultiplier(2)
            wordViewConstrait.isActive = false
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            wordViewConstrait = newConstraint
            
            
            soundButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { _ in
                UIImage(named: "soundLeft")?.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40)) }, for: .normal)
            
        } else {
            answerStackView.isHidden = true
            //soundButton.isHidden = true
            //soundButton.isHidden = true
            textFieldStackView.isHidden = false
            progrssBar2.isHidden = false
            
            soundButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 35)).image { _ in
                UIImage(named: "question")?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 35)) }, for: .normal)
            
            textField.attributedPlaceholder = NSAttributedString(string: whichStartPressed == 2 ? "İngilizcesi..." : "Yazılışı...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)])
            
            let newConstraint = wordViewConstrait.constraintWithMultiplier(4)
            wordViewConstrait.isActive = false
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            wordViewConstrait = newConstraint
        }
        
        if whichStartPressed == 3 {
            questionLabel.isHidden = true
            hourButton.isHidden = false
        }
        
        if whichStartPressed == 0 {
            answerStackView.isHidden = false
            //soundButton.isHidden = false
            textFieldStackView.isHidden = true
            progrssBar2.isHidden = true
            soundButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { _ in
                UIImage(named: "soundLeft")?.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40)) }, for: .normal)
        }
    }
    
    //MARK: - updateUI
    @objc func updateUI() {
        
        letterCounter = 0
        hint = ""
        hintLabel.text = ""
        
        if twenty_three < totalQuestionNumber {
            
            if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                switch twenty_three {
                case 0...4:
                            //whichStartPressed = 0
                    whichStartPressed = 0
                            break
                case 5...9:
                            whichStartPressed = 1
                            break
                case 10...14:
                            whichStartPressed = 2
                            break
                case 15...19:
                            whichStartPressed = 3
                            break
                case 20...24:
                            view.endEditing(true)
                            selectedSegmentIndex = 1
                            whichStartPressed = 1
                case 25...29:
                            selectedSegmentIndex = 0
                            whichStartPressed = 1
                            break
                        default:
                            print("errror")
                }
            }
            
           updateByWhichStartPressed()
            
            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && twenty_three > 0{
                UIView.transition(with: optionStackView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.optionView.isHidden = true
                                    self.firstArrowButton.isHidden = true
                              })
            }
            

            if whichStartPressed == 3 {
                            hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 66, height: 66)).image { _ in
                                UIImage(named: "sound")?.draw(in: CGRect(x: 0, y: 0, width: 66, height: 66)) }, for: .normal)
            } else {
                            hourButton.isHidden=true
            }
 
            
            text = wordBrain.getQuestionText(selectedSegmentIndex,twenty_three, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = text
            
            
            
                switch whichStartPressed {
                case 0,1:
                    // 0 is true
                    if  UserDefaults.standard.integer(forKey: "playSound") == 0 {
                        if selectedSegmentIndex == 0 {
                            playSound(text, "en-US")
                        } else {
                            //playSound(text, "tr-TR")
                        }
                    }
                    break
                case 2:
                    //playSound(text, "tr-TR")

                    textField.becomeFirstResponder()
                    break
                case 3:
                    playSound(text, "en-US")
                    textField.becomeFirstResponder()
                    break
                default:
                    print("nothing")
                }

            
 
            answer1Button.isEnabled = true
            answer2Button.isEnabled = true
            
            if whichStartPressed == 0 {
                answer1Button.setTitle(wordBrain.getAnswerTR(), for: .normal)
                answer2Button.isHidden = true
            } else {
                answer2Button.isHidden = false
                answer1Button.setTitle(wordBrain.getAnswer(0), for: .normal)
                answer2Button.setTitle(wordBrain.getAnswer(1), for: .normal)
            }
            
            answer1Button.backgroundColor = UIColor.clear
            answer2Button.backgroundColor = UIColor.clear
            hourButton.setTitle(" ", for: UIControl.State.normal)
            hourButton.setBackgroundImage(nil, for: UIControl.State.normal)
        }
        else {
            twenty_three = 0
            performSegue(withIdentifier: "goToResult", sender: self)
        }
    }
    
    @objc func updateImg(_ timer: Timer){
        let imgName = timer.userInfo!
        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
        hourButton.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    func getHour() {
        UserDefaults.standard.set(Calendar.current.component(.hour, from: Date()), forKey: "lastHour")
        UserDefaults.standard.synchronize()
    }
    
    func playSound(_ soundName: String, _ language: String)
    {

        let u = AVSpeechUtterance(string: soundName)
            u.voice = AVSpeechSynthesisVoice(language: language)
            //        u.voice = AVSpeechSynthesisVoice(language: "en-GB")
        u.rate = soundSpeed
        QuizViewController.synth.speak(u)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.isWordAddedToHardWords = wordBrain.getIsWordAddedToHardWords()
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func checkAnswer(_ sender: UIButton? = nil, _ userAnswer: String){
        
        getHour()
        selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")

        var userPoint = 0
        var userGotItRight = true

        userPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        
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
                default:
                    print("errror")
        }
        
        if UserDefaults.standard.integer(forKey: "lastHour") == UserDefaults.standard.integer(forKey: "userSelectedHour") {
            userPoint = userPoint * 2
        }
        
        
        twenty_three += 1
        
        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
            let progrs = wordBrain.getProgress() // should work one time
            progressBar.progress = progrs
            progrssBar2.progress = progrs
        }
        
        
        if whichStartPressed == 1 {
            userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased() ? true : false
            if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
                wordBrain.arrayForResultView()
            }
        }

        if whichStartPressed == 0 { userGotItRight = true }

        
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefaults.standard.set(arrayForResultViewUserAnswer, forKey: "arrayForResultViewUserAnswer")
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        hourButton.isHidden = false
            
            questionLabel.text = ""
            
            if userGotItRight {
                
                playMP3("true")
                
                if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
                    if wordBrain.userGotItRight() {
                        twenty_three = totalQuestionNumber
                    }
                } else {
                    wordBrain.updateTrueCountWords()
                }
                
                
                sender?.backgroundColor = UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00)
                hourButton.setTitleColor(UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00), for: .normal)
                       
                pointButton.setTitle(String((lastPoint+userPoint).withCommas()), for: UIControl.State.normal)
                hourButton.setTitle(String("+\(userPoint)"), for: UIControl.State.normal)
                
                
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble2", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble3", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble4", repeats: false)
                
                UserDefaults.standard.set(lastPoint+userPoint, forKey: "lastPoint")
                
                if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                    wordBrain.nextQuestion()
                    Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
                    let progrs = wordBrain.getProgress() // should work one time
                    progressBar.progress = progrs
                    progrssBar2.progress = progrs
                }

            } else {
                
                playMP3("false")
                
                // add word to hard words
                if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                    //wordBrain.userGotItWrong()
                    twenty_three -= 1

                } else {
                    wordBrain.updateFalseCountHardWords()
                }
                
                sender?.backgroundColor = UIColor(red: 0.92, green: 0.36, blue: 0.44, alpha: 1.00)
                hourButton.setTitleColor(UIColor(red: 0.92, green: 0.36, blue: 0.44, alpha: 1.00), for: .normal)
                
                pointButton.setTitle(String((lastPoint-userPoint).withCommas()), for: UIControl.State.normal)
                hourButton.setTitle(String(-userPoint), for: UIControl.State.normal)
                
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble2", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble3", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble4", repeats: false)
                
                UserDefaults.standard.set((lastPoint-userPoint), forKey: "lastPoint")
            }
            UserDefaults.standard.synchronize()
        
        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
            wordBrain.nextQuestion()
            Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
        } else {
            Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateCheckColors), userInfo: nil, repeats: false)
        }
      
            
    }
    
   @objc func updateCheckColors(){
        answer1Button.isEnabled = true
        answer2Button.isEnabled = true
        answer1Button.backgroundColor = UIColor.clear
        answer2Button.backgroundColor = UIColor.clear
       questionLabel.text = text
        hourButton.isHidden = false
        hourButton.setTitle(" ", for: UIControl.State.normal)
        hourButton.setBackgroundImage(nil, for: UIControl.State.normal)
    }
    
    func decreaseOnePoint(){
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        
        hourButton.isHidden = false
        questionLabel.isHidden = true
        
        hourButton.setTitleColor(UIColor(red: 1.00, green: 0.56, blue: 0.62, alpha: 1.00), for: .normal)
        hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
            UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
        
        pointButton.setTitle(String((lastPoint-1).withCommas()), for: UIControl.State.normal)
        hourButton.setTitle(String(-1), for: UIControl.State.normal)
    
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideBubbleButton), userInfo: nil, repeats: false)
        
        UserDefaults.standard.set((lastPoint-1), forKey: "lastPoint")
    }
    
    @objc func hideBubbleButton(){
        if whichStartPressed == 3 {
            hourButton.setTitle("", for: UIControl.State.normal)
            hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 66, height: 66)).image { _ in
                UIImage(named: "sound")?.draw(in: CGRect(x: 0, y: 0, width: 66, height: 66)) }, for: .normal)
        } else {
            hourButton.isHidden = true
        }
        
        if whichStartPressed == 2 {
            questionLabel.isHidden = false
        }
    }
}
