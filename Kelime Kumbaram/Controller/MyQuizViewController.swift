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
    var hint = ""
    var letterCounter = 0
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var answerStackView: UIStackView!
    
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
    
    var failNumber: [Int] = []
    var failIndex: [Int] = []

    var itemArray = [Item]()
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    
    var selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    var twenty_three = 0
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
    
    

    let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
    let lastHour = UserDefaults.standard.integer(forKey: "lastHour")
    var player: AVAudioPlayer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var HardItemArray = [HardItem]()
    var isWordAddedToHardWords = 0
    
    var wordBrain = WordBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        getHour()
        
        textField.delegate = self
        whichStartPressed = UserDefaults.standard.integer(forKey: "startPressed")
        
        setupView()
       
        loadItemsToHardItemArray()
        
        for i in 0...itemArray.count-1 {
            questionNumbers.append(i)
        }
        
        updateUI()
        
        wordBrain.sortFails()
        
        
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }

    

    override func viewWillAppear(_ animated: Bool) { 
        isWordAddedToHardWords = 0
    }
    


  
    //MARK: - user did something
    @IBAction func answerPressed(_ sender: UIButton) {
        checkAnswerQ(sender,sender.currentTitle!)
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
    
    
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        print("rightOnceBool.count-\(rightOnceBool.count)")
        print("rightOnce.count-\(rightOnce.count)")
            return true
        }
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        print(answerForStart23)
        if answerForStart23.lowercased() == sender.text!.lowercased() {
            checkAnswerQ(nil,sender.text!)
            textField.text = ""
            hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
                UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
            wordBrain.answerTrue()
        }
    }
    
    @IBAction func soundButtonPressed(_ sender: UIButton) {
        
        soundButton.flash()
        
        if whichStartPressed == 1 {
            if selectedSegmentIndex == 0 {
                playSound(questionText, "en-US")
            } else {
               // playSound(questionText, "tr-TR")
            }
        } else {
            //playSound(answerForStart23, "en-US")
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
    
    //MARK: - setup
    
    func setupView(){
        
        hourButton.isHidden = true
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            progressBar2.isHidden = true
 
            soundButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { _ in
                UIImage(named: "soundLeft")?.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40)) }, for: .normal)
        } else {
            answerStackView.isHidden = true
            
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
    }//setupView
    
    @objc func updateUI() {
        
        letterCounter = 0
        hint = ""
        hintLabel.text = ""

        if twenty_three < 25 {

            //it can change textField size if use in the other option
            if  whichStartPressed == 1 && twenty_three > 0{
                UIView.transition(with: optionStackView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.optionView.isHidden = true
                                    self.firstArrowButton.isHidden = true
                              })
            }
            hourButton.setTitle("", for: UIControl.State.normal)
            
            if whichStartPressed == 3 {
                            hourButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 66, height: 66)).image { _ in
                                UIImage(named: "sound")?.draw(in: CGRect(x: 0, y: 0, width: 66, height: 66)) }, for: .normal)
            } else {
                            hourButton.isHidden=true

            }
            
             
        failNumber =  UserDefaults.standard.array(forKey: "failNumber") as? [Int] ?? [Int]()
        failIndex =  UserDefaults.standard.array(forKey: "failIndex") as? [Int] ?? [Int]()
            
            
            questionText = wordBrain.getQuestionText(selectedSegmentIndex,twenty_three, whichStartPressed)
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
                        } else {
                           // playSound(questionText, "tr-TR")
                        }
                    }
                    break
                case 2:

                    textField.becomeFirstResponder()
                    //soundButton.isHidden = true
                    break
                case 3:
                    playSound(answerForStart23, "en-US")
                    textField.becomeFirstResponder()
                    //soundButton.isHidden = true
                    break
                default:
                    print("nothing")
                }
              

        
        answer1Button.isEnabled = true
        answer2Button.isEnabled = true

            answer1Button.setTitle(wordBrain.getAnswer(0), for: .normal)
            answer2Button.setTitle(wordBrain.getAnswer(1), for: .normal)
                   
        answer1Button.backgroundColor = UIColor.clear
        answer2Button.backgroundColor = UIColor.clear
        
        hourButton.setBackgroundImage(nil, for: UIControl.State.normal)
        }
        else
        {
            twenty_three = 0
            performSegue(withIdentifier: "goToResult", sender: self)
        }
    }//updateUI
    
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
    
    @objc func changeLabelColor() {
        hintLabel.textColor = UIColor(named: "d6d6d6")

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
        MyQuizViewController.synth.speak(u)
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




    

    
    
    func checkAnswerQ(_ sender: UIButton? = nil, _ userAnswer: String){
        getHour()
        twenty_three += 1
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
        
        print("USERPOINT--\(userPoint)")
        
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
                    print("success0")
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
                
                
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble2", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble3", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImg(_:)), userInfo: "greenBubble4", repeats: false)
                
                UserDefaults.standard.set((lastPoint+userPoint), forKey: "lastPoint")
                

            } else {
                
                playMP3("false")
                
                wordBrain.userGotItWrong()
                
               
                sender?.backgroundColor = UIColor(red: 1.00, green: 0.39, blue: 0.44, alpha: 1.00)
                hourButton.setTitleColor(UIColor(red: 1.00, green: 0.39, blue: 0.44, alpha: 1.00), for: .normal)
                
                
                pointButton.setTitle(String((lastPoint-userPoint).withCommas()), for: UIControl.State.normal)
                hourButton.setTitle(String(-userPoint), for: UIControl.State.normal)
                
                
                timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble2", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble3", repeats: false)
                
                timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updateImg(_:)), userInfo: "redBubble4", repeats: false)
                
                UserDefaults.standard.set((lastPoint-userPoint), forKey: "lastPoint")
            }
            UserDefaults.standard.synchronize()
      
        wordBrain.nextQuestion()
            
            Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
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
    
    //MARK: - loadItems
    func loadItemsToHardItemArray(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()){
        do {
           // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
            HardItemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.itemArray = itemArray
            destinationVC.option = "my"
            destinationVC.isWordAddedToHardWords = isWordAddedToHardWords
        }
    }
  
}


