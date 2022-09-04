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
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
            
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    var itemArray = [Item]()
    let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    
    var goAddPage = 0
    var progressValue:Float = 0.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        fixSoundProblemForRealDevice()
        setupFirstLaunch()
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
        viewDidLayoutSubviews()
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        UserDefault.whichButton.set("blue")
        goAddPage = 0
        blueButton.bounce()
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @IBAction func yellowButtonPressed(_ sender: UIButton) {
        UserDefault.whichButton.set("yellow")
        yellowButton.bounce()
        goAfter100Milliseconds(identifier: "goWords")
    }

    @IBAction func setNotificationFirstTime(_ sender: UIButton) {
        //works after any button pressed
        if UserDefault.setNotificationFirstTime.getInt() == 0 {
            wordBrain.setNotification()
            UserDefault.setNotificationFirstTime.set(1)
            print("SET NOTİFİCATİON<<")
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
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(appendDefaultWords), userInfo: nil, repeats: false)
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
        greenButton.backgroundColor = Colors.green
        blueButton.backgroundColor = Colors.blue
        yellowButton.backgroundColor = Colors.yellow
        
        setupButtonShadow(greenButton, shadowColor: Colors.greenShadow)
        setupButtonShadow(blueButton, shadowColor: Colors.blueShadow)
        setupButtonShadow(yellowButton, shadowColor: Colors.yellowShadow)

        greenButton.setButtonCornerRadius(15)
        blueButton.setButtonCornerRadius(15)
        yellowButton.setButtonCornerRadius(15)
        
        greenButton.setImage(imageName: "new", width: 35, height: 35)
        blueButton.setImage(imageName: "bank", width: 40, height: 40)
        yellowButton.setImage(imageName: "hard", width: 35, height: 35)
        settingsButton.setImage(imageName: "settingsImage", width: 23, height: 23)
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

    func fixSoundProblemForRealDevice(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
    }
}
