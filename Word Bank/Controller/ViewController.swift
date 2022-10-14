//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class ViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var levelStackView: UIStackView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var levelView: UIView!
    @IBOutlet weak var x2view: UIView!
    @IBOutlet weak var x2button: UIButton!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var exerciseButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var greenButtonLabel: UILabel!
    @IBOutlet weak var blueButtonLabel: UILabel!
    @IBOutlet weak var yellowButtonLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
            
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    
    var goAddPage = 0
    var progressValue:Float = 0.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        fixSoundProblemForRealDevice()
        setupFirstLaunch()
        configureColor()
        getHour()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setupCircularProgress()
        check2xTime()
        setupButtons()
        setupNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        cp.center =  CGPoint(x: super.view.center.x, y:  levelView.center.y)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goSettings" {
            if segue.destination is SettingsViewController {
                (segue.destination as? SettingsViewController)?.onViewWillDisappear = {
                    self.check2xTime()
                }
            }
        }
        
        if segue.identifier == "goWords" {
            let destinationVC = segue.destination as! WordsViewController
            destinationVC.goAddPage = goAddPage
        }
    }
   
    //MARK: - IBAction
    
    @IBAction func x2ButtonPressed(_ sender: Any) {
        let vc = X2HourViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        UserDefault.startPressed.set(1)
        UserDefault.whichButton.set("blue")
        goAddPage = 1
        greenButton.bounce()
        greenButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        viewDidLayoutSubviews()
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        UserDefault.whichButton.set("blue")
        goAddPage = 0
        blueButton.bounce()
        blueButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @IBAction func yellowButtonPressed(_ sender: UIButton) {
        UserDefault.whichButton.set("yellow")
        yellowButton.bounce()
        yellowButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @IBAction func exerciseButtonPressed(_ sender: UIButton) {
        UserDefault.whichButton.set("purple")
        exerciseButton.bounce()
        exerciseButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            let vc = WheelViewController()
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func setNotificationFirstTime(_ sender: UIButton) {
        //works after any button pressed
        if UserDefault.setNotificationFirstTime.getInt() == 0 {
            wordBrain.setNotification()
            UserDefault.setNotificationFirstTime.set(1)
        }
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        performSegue(withIdentifier: "goSettings", sender: self)
    }
    
    //MARK: - Selectors
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        let vc = LevelInfoViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    @objc func appendDefaultWords() {
        let defaultWordsCount = wordBrain.defaultWords.count
        
        for index in 0..<defaultWordsCount {
            _ = index // noneed
            wordBrain.addWord(english: "\(wordBrain.defaultWords[index].eng)", meaning: "\(wordBrain.defaultWords[index].tr)")
        }
        UserDefault.userWordCount.set(defaultWordsCount)
     }
    
    //MARK: - Helpers
    
    func setupFirstLaunch(){
        //version 2.0.1
        if UserDefault.x2Time.getValue() == nil {
            let calendar = Calendar.current
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())!
            UserDefault.x2Time.set(twoDaysAgo)
            UserDefault.userSelectedHour.set(23)
            UserDefault.lastEditLabel.set("empty")
            UserDefault.exercisePoint.set("10")
            UserDefault.textSize.set(15)
            askNotificationPermission()
            showOnboarding()
        }
        
        //version 2.0.2
        if UserDefault.exerciseCount.getValue() == nil {
            UserDefault.allTrueCount.set(UserDefault.blueAllTrue.getInt()+1)
            
            UserDefault.testCount.set(UserDefault.start1count.getInt()+1)
            UserDefault.writingCount.set(UserDefault.start2count.getInt()+1)
            UserDefault.listeningCount.set(UserDefault.start3count.getInt()+1)
            UserDefault.cardCount.set(UserDefault.start4count.getInt()+1)
            
            UserDefault.exerciseCount.set(UserDefault.blueExerciseCount.getInt()+1)
            UserDefault.trueCount.set(UserDefault.blueTrueCount.getInt()+1)
            UserDefault.falseCount.set(UserDefault.blueFalseCount.getInt()+1)
        }
        
        let when = DispatchTime.now() + 5
        DispatchQueue.main.asyncAfter(deadline: when){
            self.wordBrain.loadUser()
            self.wordBrain.loadItemArray()
            self.wordBrain.loadHardItemArray()
            
            UserDefault.hardWordsCount.set(self.wordBrain.hardItemArray.count)
            
            let wordCount = self.wordBrain.itemArray.count
            if wordCount == 0 {
                self.scheduledTimer(timeInterval: 0.5, #selector(self.appendDefaultWords))
            }
            
            if self.wordBrain.user.count < 1 {
                self.wordBrain.createUser()
                UserDefault.level.set(0)
                UserDefault.lastPoint.set(0)
                UserDefault.exerciseCount.set(0)
                UserDefault.allTrueCount.set(0)
                UserDefault.testCount.set(0)
                UserDefault.writingCount.set(0)
                UserDefault.listeningCount.set(0)
                UserDefault.cardCount.set(0)
                UserDefault.trueCount.set(0)
                UserDefault.falseCount.set(0)
            } else {
                UserDefault.level.set(self.wordBrain.user[0].level)
                UserDefault.lastPoint.set(self.wordBrain.user[0].lastPoint)
                UserDefault.exerciseCount.set(self.wordBrain.user[0].exerciseCount)
                UserDefault.allTrueCount.set(self.wordBrain.user[0].allTrueCount)
                UserDefault.testCount.set(self.wordBrain.user[0].testCount)
                UserDefault.writingCount.set(self.wordBrain.user[0].writingCount)
                UserDefault.listeningCount.set(self.wordBrain.user[0].listeningCount)
                UserDefault.cardCount.set(self.wordBrain.user[0].cardCount)
                UserDefault.trueCount.set(self.wordBrain.user[0].trueCount)
                UserDefault.falseCount.set(self.wordBrain.user[0].falseCount)
            }
        }
    }
    
    func askNotificationPermission(){
        wordBrain.notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted){
                print("Permission Denied")
            }
        }
    }
    
    func configureColor() {
        titleLabel.textColor = Colors.f6f6f6
        levelLabel.textColor = Colors.f6f6f6
        greenButtonLabel.textColor = Colors.f6f6f6
        blueButtonLabel.textColor = Colors.f6f6f6
        yellowButtonLabel.textColor = Colors.f6f6f6
        greenButton.setTitleColor(Colors.green, for: .normal)
        blueButton.setTitleColor(Colors.blue, for: .normal)
        yellowButton.setTitleColor(Colors.yellow, for: .normal)
        
    }
    
    func showOnboarding(){
        navigationController?.pushViewController(OnboardingContainerViewController(), animated: true)
    }
    
    func goAfter100Milliseconds(identifier: String){
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
    
    func setupButtons(){
        greenButton.backgroundColor = UIColor.purple
        greenButton.backgroundColor = Colors.green
        blueButton.backgroundColor = Colors.blue
        yellowButton.backgroundColor = Colors.yellow
        
        setupButtonShadow(exerciseButton, shadowColor: .purple)
        setupButtonShadow(greenButton, shadowColor: Colors.greenShadow)
        setupButtonShadow(blueButton, shadowColor: Colors.blueShadow)
        setupButtonShadow(yellowButton, shadowColor: Colors.yellowShadow)

        exerciseButton.setButtonCornerRadius(15)
        greenButton.setButtonCornerRadius(15)
        blueButton.setButtonCornerRadius(15)
        yellowButton.setButtonCornerRadius(15)
        
        exerciseButton.setImage(imageName: "wheelicon", width: 35, height: 35)
        greenButton.setImage(imageName: "new", width: 35, height: 35)
        blueButton.setImage(imageName: "bank", width: 40, height: 40)
        yellowButton.setImage(imageName: "hard", width: 35, height: 35)
        settingsButton.setImage(imageName: "settingsImage", width: 35, height: 35)
    }
    
    func setupButtonShadow(_ button: UIButton, shadowColor: UIColor?){
        button.layer.shadowColor = shadowColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }
    
    func setupNavigationBar(){
        // back button color
        self.navigationController?.navigationBar.tintColor = Colors.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.black!]
    
        //delete navigation bar background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupCircularProgress(){
        progressValue = wordBrain.calculateLevel()
        levelLabel.text = UserDefault.level.getString()
        
        cp.trackColor = UIColor.white
        cp.progressColor = Colors.pink!
        self.view.addSubview(cp)
        cp.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        cp.addGestureRecognizer(gesture)
    }

    func check2xTime(){
        if UserDefault.lastHour.getInt() == UserDefault.userSelectedHour.getInt() {
            x2view.isHidden = false
            x2button.pulstate()
        } else {
            x2view.isHidden = true
        }
    }
    
    func getHour() {
        UserDefault.lastHour.set(Calendar.current.component(.hour, from: Date()))
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }

    func fixSoundProblemForRealDevice(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
    }
}
