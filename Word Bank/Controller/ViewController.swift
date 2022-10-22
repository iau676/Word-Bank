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
    let newWordsButton = UIButton()
    let wordsButton = UIButton()
    let hardWordsButton = UIButton()
    
    let exerciseButtonLabel = UILabel()
    let newWordButtonLabel = UILabel()
    let wordsButtonLabel = UILabel()
    let hardWordsButtonLabel = UILabel()
    
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
    
    //MARK: - Selectors
    
    @objc func exerciseButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("normal")
        UserDefault.spinWheelCount.set(UserDefault.spinWheelCount.getInt()+1)
        exerciseButton.bounce()
        exerciseButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goExercise")
    }
    
    @objc func newWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.startPressed.set(1)
        UserDefault.whichButton.set("normal")
        goAddPage = 1
        newWordsButton.bounce()
        newWordsButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        viewDidLayoutSubviews()
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @objc func wordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("normal")
        goAddPage = 0
        wordsButton.bounce()
        wordsButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
        goAfter100Milliseconds(identifier: "goWords")
    }
    
    @objc func hardWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set("hard")
        hardWordsButton.bounce()
        hardWordsButton.updateShadowHeight(withDuration: 0.11, height: 0.3)
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
        newWordButtonLabel.textColor = Colors.f6f6f6
        wordsButtonLabel.textColor = Colors.f6f6f6
        hardWordsButtonLabel.textColor = Colors.f6f6f6
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
        dailyButton.setImageWithRenderingMode(imageName: "dailyQuest", width: 26, height: 26, color: .darkGray)
        awardButton.setImageWithRenderingMode(imageName: "award", width: 27, height: 27, color: .darkGray)
        statisticButton.setImageWithRenderingMode(imageName: "statistic", width: 25, height: 25, color: .darkGray)
        settingsButton.setImageWithRenderingMode(imageName: "settingsImage", width: 25, height: 25, color: .darkGray)
        
        homeButton.setTitle("Home", for: .normal)
        homeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        homeButton.setTitleColor(Colors.blue ?? .blue, for: .normal)
        homeButton.alignTextBelow()
        
        dailyButton.setTitle("Daily", for: .normal)
        dailyButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        dailyButton.setTitleColor(.darkGray, for: .normal)
        dailyButton.alignTextBelow()
        
        awardButton.setTitle("Awards", for: .normal)
        awardButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        awardButton.setTitleColor(.darkGray, for: .normal)
        awardButton.alignTextBelow()
        
        statisticButton.setTitle("Statistics", for: .normal)
        statisticButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        statisticButton.setTitleColor(.darkGray, for: .normal)
        statisticButton.alignTextBelow()
        
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        settingsButton.setTitleColor(.darkGray, for: .normal)
        settingsButton.alignTextBelow()
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
        newWordsButton.backgroundColor = Colors.green
        wordsButton.backgroundColor = Colors.blue
        hardWordsButton.backgroundColor = Colors.yellow
        
        setupButtonShadow(exerciseButton, shadowColor: Colors.purpleShadow)
        setupButtonShadow(newWordsButton, shadowColor: Colors.greenShadow)
        setupButtonShadow(wordsButton, shadowColor: Colors.blueShadow)
        setupButtonShadow(hardWordsButton, shadowColor: Colors.yellowShadow)

        exerciseButton.setButtonCornerRadius(15)
        newWordsButton.setButtonCornerRadius(15)
        wordsButton.setButtonCornerRadius(15)
        hardWordsButton.setButtonCornerRadius(15)
        
        exerciseButton.setImage(imageName: "wheelicon", width: 35, height: 35)
        newWordsButton.setImage(imageName: "new", width: 35, height: 35)
        wordsButton.setImage(imageName: "bank", width: 40, height: 40)
        hardWordsButton.setImage(imageName: "hard", width: 35, height: 35)
        
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
        
        newWordsButton.translatesAutoresizingMaskIntoConstraints = false
        newWordsButton.addTarget(self, action: #selector(newWordsButtonPressed), for: .primaryActionTriggered)
        
        wordsButton.translatesAutoresizingMaskIntoConstraints = false
        wordsButton.addTarget(self, action: #selector(wordsButtonPressed), for: .primaryActionTriggered)
        
        hardWordsButton.translatesAutoresizingMaskIntoConstraints = false
        hardWordsButton.addTarget(self, action: #selector(hardWordsButtonPressed), for: .primaryActionTriggered)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
        
        exerciseButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseButtonLabel.text = "Exercise"
        exerciseButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
        newWordButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        newWordButtonLabel.text = "New Word"
        newWordButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
        wordsButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsButtonLabel.text = "Words"
        wordsButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
        hardWordsButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        hardWordsButtonLabel.text = "Hard Words"
        hardWordsButtonLabel.font = UIFont(name: "AvenirNext-Regular", size: 15)
        
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
        view.addSubview(newWordsButton)
        view.addSubview(newWordButtonLabel)
        view.addSubview(wordsButton)
        view.addSubview(wordsButtonLabel)
        view.addSubview(hardWordsButton)
        view.addSubview(hardWordsButtonLabel)
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
            
            exerciseButton.bottomAnchor.constraint(equalTo: newWordsButton.topAnchor, constant: -40),
            exerciseButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            exerciseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            exerciseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            exerciseButtonLabel.centerYAnchor.constraint(equalTo: exerciseButton.bottomAnchor, constant: 20),
            exerciseButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newWordsButton.bottomAnchor.constraint(equalTo: wordsButton.topAnchor, constant: -40),
            newWordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            newWordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            newWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            newWordButtonLabel.centerYAnchor.constraint(equalTo: newWordsButton.bottomAnchor, constant: 20),
            newWordButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            wordsButton.bottomAnchor.constraint(equalTo: hardWordsButton.topAnchor, constant: -40),
            wordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            wordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            wordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            wordsButtonLabel.centerYAnchor.constraint(equalTo: wordsButton.bottomAnchor, constant: 20),
            wordsButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            hardWordsButton.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor, constant: -40),
            hardWordsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            hardWordsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            hardWordsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hardWordsButtonLabel.centerYAnchor.constraint(equalTo: hardWordsButton.bottomAnchor, constant: 20),
            hardWordsButtonLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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
            newWordsButton.heightAnchor.constraint(equalToConstant: 45),
            wordsButton.heightAnchor.constraint(equalToConstant: 45),
            hardWordsButton.heightAnchor.constraint(equalToConstant: 45),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
}
