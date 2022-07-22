//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData


class MyQuizViewController: UIViewController, UITextFieldDelegate {
    
    //This didn't crash my app but caused a memory leak every time AVSpeechSynthesizer was declared. I solved this by declaring the AVSpeechSynthesizer as a global variable
    static let synth = AVSpeechSynthesizer()
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Button: UIButton!
    @IBOutlet weak var answer2Button: UIButton!
    @IBOutlet weak var progressBar2: UIProgressView!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var pointButton: UIButton!
    @IBOutlet weak var hourButton: UIButton!
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
    var selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    var questionCount = 0
    var timer = Timer()
    var questionNumber = 0
    var changedQuestionNumber = 0
    var onlyHereNumber = 0
    var answer = 0    
    var questionText = ""
    var answerForStart23 = ""
    var whichStartPressed = 1
    var soundSpeed = Float()
    var rightOnce = [Int]()
    var rightOnceBool = [Bool]()
    var arrayForResultViewUserAnswer = [String]()
    var player: AVAudioPlayer!
    var isWordAddedToHardWords = 0
    var wordBrain = WordBrain()
    let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
    let lastHour = UserDefaults.standard.integer(forKey: "lastHour")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        getHour()
        
        textField.delegate = self
        whichStartPressed = UserDefaults.standard.integer(forKey: "startPressed")
        
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
            arrowButtonAtOptionView.setImage(imageRenderer(imageName: "arrowRight", imageSize: 30), for: .normal)
        } else {
            showOptions = 0
            arrowButtonAtAnswerView.isHidden = false
            arrowButtonAtOptionView.isHidden = true
            updateViewAppearance(optionView, isHidden: true)
            arrowButtonAtOptionView.setImage(imageRenderer(imageName: "arrowLeft", imageSize: 30), for: .normal)
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
            checkAnswerQ(nil,sender.text!)
            textField.text = ""
            hourButton.setImage(imageRenderer(imageName: "empty", imageSize: 0), for: .normal)
            wordBrain.answerTrue()
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
        soundButton.flash()
        
        if whichStartPressed == 1 {
            if selectedSegmentIndex == 0 {
                playSound(questionText, "en-US")
            }
        } else {
            getLetter()
        }
    }
    
    @IBAction func hourButtonPressed(_ sender: UIButton) {
        hourButton.flash()
        playSound(answerForStart23, "en-US")
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
        
    //MARK: - Objc Function
    
    @objc func updateUI() {
        
        letterCounter = 0
        hint = ""
        hintLabel.text = ""

        if questionCount < 25 {

            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && questionCount > 0 {
                updateViewAppearance(optionView, isHidden: true)
                self.arrowButtonAtAnswerView.isHidden = true
            }
            hourButton.setTitle("", for: UIControl.State.normal)
            
            if whichStartPressed == 3 {
                hourButton.setImage(imageRenderer(imageName: "sound", imageSize: 66), for: .normal)
            } else {
                hourButton.isHidden=true
            }
                 
            failNumber =  UserDefaults.standard.array(forKey: "failNumber") as? [Int] ?? [Int]()
            failIndex =  UserDefaults.standard.array(forKey: "failIndex") as? [Int] ?? [Int]()
                
            questionText = wordBrain.getQuestionText(selectedSegmentIndex,questionCount, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = questionText

            questionNumbersCopy = questionNumbers
            questionNumbersCopy.remove(at: questionNumber)
                
            //0 is true, 1 is false
            switch whichStartPressed {
            case 1:
                if UserDefaults.standard.integer(forKey: "playSound") == 0 {
                    if selectedSegmentIndex == 0 {
                        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
                            playSound(questionText, "en-GB")
                        } else {
                            playSound(questionText, "en-US")
                        }
                    }
                }
                break
            case 2:
                textField.becomeFirstResponder()
                break
            case 3:
                playSound(answerForStart23, "en-US")
                textField.becomeFirstResponder()
                break
            default: break
            }
            
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
            hourButton.setBackgroundImage(nil, for: UIControl.State.normal)
            
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
            hourButton.setTitle("", for: UIControl.State.normal)
            hourButton.setImage(imageRenderer(imageName: "sound", imageSize: 66), for: .normal)
        } else {
            hourButton.isHidden = true
        }
        
        if whichStartPressed == 2 {
            questionLabel.isHidden = false
        }
    }
    
    @objc func changeLabelColor() {
        hintLabel.textColor = UIColor(named: "d6d6d6")
    }
    
    @objc func updateImg(_ timer: Timer){
        let imgName = timer.userInfo!
        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
        hourButton.setBackgroundImage(image, for: UIControl.State.normal)
    }

    //MARK: - Other Functions
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        return true
    }
    
    func setupView(){
        
        hourButton.isHidden = true
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progressBar2.isHidden = true
            soundButton.setImage(imageRenderer(imageName: "soundLeft", imageSize: 40), for: .normal)
        } else {
            answerStackView.isHidden = true
            soundButton.setImage(imageRenderer(imageName: "question", imageSize: 35), for: .normal)
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
        progressBar2.progress = 0
        questionLabel.numberOfLines = 6
        questionLabel.adjustsFontSizeToFitWidth = true
        
        setupAnswerButton(answer1Button)
        setupAnswerButton(answer2Button)
        
        arrowButtonAtAnswerView.setImage(imageRenderer(imageName: "arrowLeft", imageSize: 30), for: .normal)
        optionView.isHidden = true
        showOptions = 0
    }//setupView
    
    func setupAnswerButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)

        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor(red: 0.28, green: 0.40, blue: 0.56, alpha: 1.00).cgColor
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
            hintLabel.textColor = UIColor(named: "greenColorSingle")
            hintLabel.flash()
            Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(changeLabelColor), userInfo: nil, repeats: false)
        }
    }
    
    func getHour() {
        UserDefaults.standard.set(Calendar.current.component(.hour, from: Date()), forKey: "lastHour")
        UserDefaults.standard.synchronize()
    }
    
    func playSound(_ soundName: String, _ language: String) {
        let u = AVSpeechUtterance(string: soundName)
            u.voice = AVSpeechSynthesisVoice(language: language)
            //        u.voice = AVSpeechSynthesisVoice(language: "en-GB")
        u.rate = soundSpeed
        MyQuizViewController.synth.speak(u)
    }
    
    func playMP3(_ soundName: String) {
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
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefaults.standard.set(arrayForResultViewUserAnswer, forKey: "arrayForResultViewUserAnswer")
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        hourButton.isHidden = false
        questionLabel.text = ""
        
        userPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        
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
        
        if UserDefaults.standard.integer(forKey: "lastHour") == UserDefaults.standard.integer(forKey: "userSelectedHour") {
            userPoint *= 2
        }
        
        //MARK: - userGotItRight
            if userGotItRight {
                playMP3("true")
                wordBrain.updateTrueCountMyWords()
                
                sender?.backgroundColor = UIColor(red: 0.17, green: 0.74, blue: 0.52, alpha: 1.00)
                hourButton.setTitleColor(UIColor(red: 0.17, green: 0.74, blue: 0.52, alpha: 1.00), for: .normal)
                pointButton.setTitle(String((lastPoint+userPoint).withCommas()), for: UIControl.State.normal)
                hourButton.setTitle(String("+\(userPoint)"), for: UIControl.State.normal)
                
                timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "greenBubble")
                timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "greenBubble2")
                timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "greenBubble3")
                timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "greenBubble4")
                
                UserDefaults.standard.set((lastPoint+userPoint), forKey: "lastPoint")

            } else {
                playMP3("false")
                wordBrain.userGotItWrong()
               
                sender?.backgroundColor = UIColor(red: 1.00, green: 0.39, blue: 0.44, alpha: 1.00)
                hourButton.setTitleColor(UIColor(red: 1.00, green: 0.39, blue: 0.44, alpha: 1.00), for: .normal)
                pointButton.setTitle(String((lastPoint-userPoint).withCommas()), for: UIControl.State.normal)
                hourButton.setTitle(String(-userPoint), for: UIControl.State.normal)
                
                timer = rotateBubbleButton(timeInterval: 0.01, userInfo: "redBubble")
                timer = rotateBubbleButton(timeInterval: 0.1, userInfo: "redBubble2")
                timer = rotateBubbleButton(timeInterval: 0.2, userInfo: "redBubble3")
                timer = rotateBubbleButton(timeInterval: 0.3, userInfo: "redBubble4")
                
                UserDefaults.standard.set((lastPoint-userPoint), forKey: "lastPoint")
            }
            UserDefaults.standard.synchronize()
      
        wordBrain.nextQuestion()
            
        Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    func rotateBubbleButton(timeInterval: Double, userInfo: String) -> Timer {
        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateImg(_:)), userInfo: userInfo, repeats: false)
    }
    
    func decreaseOnePoint(){
        
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        
        questionLabel.isHidden = true
        hourButton.isHidden = false
        
        hourButton.setTitleColor(UIColor(red: 1.00, green: 0.56, blue: 0.62, alpha: 1.00), for: .normal)
        hourButton.setImage(imageRenderer(imageName: "empty", imageSize: 0), for: .normal)
        pointButton.setTitle(String((lastPoint-1).withCommas()), for: UIControl.State.normal)
        hourButton.setTitle(String(-1), for: UIControl.State.normal)
    
        Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(hideBubbleButton), userInfo: nil, repeats: false)
        
        UserDefaults.standard.set((lastPoint-1), forKey: "lastPoint")
    }
    
    func imageRenderer(imageName: String, imageSize: Int) -> UIImage{
        return UIGraphicsImageRenderer(size: CGSize(width: imageSize, height: imageSize)).image { _ in
            UIImage(named: imageName)?.draw(in: CGRect(x: 0, y: 0, width: imageSize, height: imageSize)) }
    }
    
    func fillQuestionNumbers() {
        for i in 0...itemArray.count-1 {
            questionNumbers.append(i)
        }
    }

    
//    func loadItemsToHardItemArray(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()){
//        do {
//           // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
//            HardItemArray = try context.fetch(request)
//        } catch {
//           print("Error fetching data from context \(error)")
//        }
//    }
  
}
