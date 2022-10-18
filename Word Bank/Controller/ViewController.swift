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
    
    let titleLabel = UILabel()
    let levelLabel = UILabel()
    
    let exerciseButton = UIButton()
    let greenButton = UIButton()
    let blueButton = UIButton()
    let yellowButton = UIButton()
    
    let exerciseButtonLabel = UILabel()
    let greenButtonLabel = UILabel()
    let blueButtonLabel = UILabel()
    let yellowButtonLabel = UILabel()
    
    let xButton = UIButton()
    let xLabel = UILabel()
    
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
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
        configureTabBar()
        getHour()
        style()
        layout()
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
        super.viewDidLayoutSubviews()
        
        let x = super.view.bounds.height
        let y = exerciseButton.frame.origin.y
        let z = (x - (x - y))/2 + 32
        
        cp.center = CGPoint(x: super.view.center.x, y: z)
        levelLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: cp.center.y).isActive = true
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
    
    func setNotificationFirstTime() {
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
    
    @objc func exerciseButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("blue")
        UserDefault.spinWheelCount.set(UserDefault.spinWheelCount.getInt()+1)
        exerciseButton.bounce()
        exerciseButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goExercise")
    }
    
    @objc func greenButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.startPressed.set(1)
        UserDefault.whichButton.set("blue")
        goAddPage = 1
        greenButton.bounce()
        greenButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        viewDidLayoutSubviews()
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @objc func blueButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("blue")
        goAddPage = 0
        blueButton.bounce()
        blueButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @objc func yellowButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("yellow")
        yellowButton.bounce()
        yellowButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        goAfter100Milliseconds(identifier: "goSettings")
    }
    
    @objc func xButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = X2HourViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
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
        exerciseButtonLabel.textColor = Colors.f6f6f6
        greenButtonLabel.textColor = Colors.f6f6f6
        blueButtonLabel.textColor = Colors.f6f6f6
        yellowButtonLabel.textColor = Colors.f6f6f6
    }
    
    func configureTabBar() {
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.backgroundColor = .white
        dailyButton.backgroundColor = .white
        awardButton.backgroundColor = .white
        statisticButton.backgroundColor = .white
        settingsButton.backgroundColor = .white
        
        homeButton.setImageWithRenderingMode(imageName: "home", width: 25, height: 25, color: Colors.blue ?? .blue)
        dailyButton.setImageWithRenderingMode(imageName: "dailyQuest", width: 25, height: 25, color: .darkGray)
        awardButton.setImageWithRenderingMode(imageName: "award", width: 27, height: 27, color: .darkGray)
        statisticButton.setImageWithRenderingMode(imageName: "statistic", width: 25, height: 25, color: .darkGray)
        settingsButton.setImageWithRenderingMode(imageName: "settingsImage", width: 25, height: 25, color: .darkGray)
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
        exerciseButton.backgroundColor = .systemPurple
        greenButton.backgroundColor = Colors.green
        blueButton.backgroundColor = Colors.blue
        yellowButton.backgroundColor = Colors.yellow
        
        setupButtonShadow(exerciseButton, shadowColor: Colors.purpleShadow)
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
        
        xButton.setImage(imageName: "x2", width: 45, height: 45)
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
        cp.progressColor = Colors.pink ?? .systemPink
        cp.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        cp.addGestureRecognizer(gesture)
    }

    func check2xTime(){
        if UserDefault.lastHour.getInt() == UserDefault.userSelectedHour.getInt() {
            xButton.isHidden = false
            xLabel.isHidden = false
            xButton.pulstate()
        } else {
            xButton.isHidden = true
            xLabel.isHidden = true
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

extension ViewController {
    
    func style() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.text = "Word Bank"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23)
        titleLabel.numberOfLines = 1
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont(name: "ArialRoundedMTBold", size: 39)
        levelLabel.numberOfLines = 1
        
        exerciseButton.translatesAutoresizingMaskIntoConstraints = false
        exerciseButton.addTarget(self, action: #selector(exerciseButtonPressed), for: .primaryActionTriggered)
        
        greenButton.translatesAutoresizingMaskIntoConstraints = false
        greenButton.addTarget(self, action: #selector(greenButtonPressed), for: .primaryActionTriggered)
        
        blueButton.translatesAutoresizingMaskIntoConstraints = false
        blueButton.addTarget(self, action: #selector(blueButtonPressed), for: .primaryActionTriggered)
        
        yellowButton.translatesAutoresizingMaskIntoConstraints = false
        yellowButton.addTarget(self, action: #selector(yellowButtonPressed), for: .primaryActionTriggered)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
        
        exerciseButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseButtonLabel.text = "Exercise"
        exerciseButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        exerciseButtonLabel.numberOfLines = 1
        
        greenButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        greenButtonLabel.text = "New Word"
        greenButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        greenButtonLabel.numberOfLines = 1
        
        blueButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        blueButtonLabel.text = "Words"
        blueButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        blueButtonLabel.numberOfLines = 1
        
        yellowButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        yellowButtonLabel.text = "Hard Words"
        yellowButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        yellowButtonLabel.numberOfLines = 1
        
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.addTarget(self, action: #selector(xButtonPressed), for: .primaryActionTriggered)
        
        xLabel.translatesAutoresizingMaskIntoConstraints = false
        xLabel.textColor = Colors.f6f6f6
        xLabel.text = "2x"
        xLabel.font = UIFont(name: "ArialRoundedMTBold", size: 25)
    }
    
    func layout() {
        view.addSubview(titleLabel)
        view.addSubview(cp)
        view.addSubview(levelLabel)
        view.addSubview(exerciseButton)
        view.addSubview(exerciseButtonLabel)
        view.addSubview(greenButton)
        view.addSubview(greenButtonLabel)
        view.addSubview(blueButton)
        view.addSubview(blueButtonLabel)
        view.addSubview(yellowButton)
        view.addSubview(yellowButtonLabel)
        view.addSubview(xButton)
        view.addSubview(xLabel)
        
        tabBarStackView.addArrangedSubview(homeButton)
        tabBarStackView.addArrangedSubview(dailyButton)
        tabBarStackView.addArrangedSubview(awardButton)
        tabBarStackView.addArrangedSubview(statisticButton)
        tabBarStackView.addArrangedSubview(settingsButton)
        
        view.addSubview(tabBarStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            exerciseButton.bottomAnchor.constraint(equalTo: greenButton.topAnchor, constant: -40),
            exerciseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            exerciseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            exerciseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            exerciseButtonLabel.centerYAnchor.constraint(equalTo: exerciseButton.bottomAnchor, constant: 20),
            exerciseButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            greenButton.bottomAnchor.constraint(equalTo: blueButton.topAnchor, constant: -40),
            greenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            greenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            greenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            greenButtonLabel.centerYAnchor.constraint(equalTo: greenButton.bottomAnchor, constant: 20),
            greenButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            blueButton.bottomAnchor.constraint(equalTo: yellowButton.topAnchor, constant: -40),
            blueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            blueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            blueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            blueButtonLabel.centerYAnchor.constraint(equalTo: blueButton.bottomAnchor, constant: 20),
            blueButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            yellowButton.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: -40),
            yellowButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            yellowButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            yellowButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            yellowButtonLabel.centerYAnchor.constraint(equalTo: yellowButton.bottomAnchor, constant: 20),
            yellowButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            xButton.centerYAnchor.constraint(equalTo: cp.centerYAnchor),
            xButton.centerXAnchor.constraint(equalTo: cp.centerXAnchor, constant: -100),
            
            xLabel.centerXAnchor.constraint(equalTo: xButton.centerXAnchor),
            xLabel.centerYAnchor.constraint(equalTo: xButton.centerYAnchor),
            
            tabBarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tabBarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            exerciseButton.heightAnchor.constraint(equalToConstant: 45),
            greenButton.heightAnchor.constraint(equalToConstant: 45),
            blueButton.heightAnchor.constraint(equalToConstant: 45),
            yellowButton.heightAnchor.constraint(equalToConstant: 45),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
}
