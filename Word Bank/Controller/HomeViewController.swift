//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class HomeViewController: UIViewController, LevelDelegate {
        
    let titleLabel = UILabel()
    
    let leftLineView = UIView()
    let centerLineView = UIView()
    let rightLineView = UIView()
    
    let levelButton = UIButton()
    let exerciseButton = UIButton()
    let newWordsButton = UIButton()
    let wordsButton = UIButton()
    let hardWordsButton = UIButton()
    let dropButton = UIButton()
            
    let levelCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    let newWordCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    let wordsCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    let exerciseCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    let hardCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    
    var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    var goAddPage = 0
    var progressValue:Float = 0.0
    
    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        fixSoundProblemForRealDevice()
        configureTabBar()
        wordBrain.getHour()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        wordBrain.loadItemArray()
        setupCircularProgress()
        check2xTime()
        setupButtons()
        setupNavigationBar()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFirstLaunch()
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
    
    @objc func levelButtonPressed(sender : UITapGestureRecognizer) {
        flipCP(button: levelButton, cp: levelCP)
       
        let vc = LevelInfoViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.updateLevelButtonTitle(isInt: false)
        self.present(vc, animated: false)
    }
    
    @objc func exerciseButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set(ExerciseType.normal)
        UserDefault.spinWheelCount.set(UserDefault.spinWheelCount.getInt()+1)
        flipCP(button: exerciseButton, cp: exerciseCP)
        checkWordCount()
    }
    
    @objc func newWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        
        newWordsButton.setImage(image: Images.onlyHand, width: 35, height: 35)
        dropButton.setImage(image: Images.drop, width: 7, height: 7)
        dropButton.animateDropDown()
        
        UserDefault.startPressed.set(1)
        UserDefault.whichButton.set(ExerciseType.normal)
        goAddPage = 1
        viewDidLayoutSubviews()
        flipCP(button: newWordsButton, cp: newWordCP)
        performSegue(identifier: "goWords", second: 0.4)
    }
    
    @objc func wordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set(ExerciseType.normal)
        goAddPage = 0
        flipCP(button: wordsButton, cp: wordsCP)
        performSegue(identifier: "goWords", second: 0.4)
    }
    
    @objc func hardWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        UserDefault.whichButton.set(ExerciseType.hard)
        flipCP(button: hardWordsButton, cp: hardCP)
        performSegue(identifier: "goWords", second: 0.4)
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
        
        //version 2.0.3
        if UserDefault.keyboardHeight.getCGFloat() == 0 {
            getKeyboardHeight()
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
    
    func flipCP(button: UIButton, cp: CircularProgressView){
        cp.trackLayer.lineWidth = 3
        cp.progressLayer.lineWidth = 3
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            UIView.transition(with: cp, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            UIView.transition(with: button, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            UIView.transition(with: cp, duration: 0.2, options: .transitionCrossDissolve, animations: {
                cp.trackLayer.lineWidth = 10
                cp.progressLayer.lineWidth = 10
            })
        }
    }
    
    func updateLevelButtonTitle(isInt: Bool) {
        if isInt {
            UIView.transition(with: self.levelButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelButton.setTitle(UserDefault.level.getString(), for: .normal)
                self.levelButton.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 30)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelButton.setTitle("\(String(format: "%.2f", self.progressValue*100))%", for: .normal)
                self.levelButton.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 20)
            }
        }
    }
    
    func performSegue(identifier: String, second: Double){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second){
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
 
    func setupButtons(){
        exerciseButton.setImage(image: Images.wheelicon, width: 35, height: 35)
        newWordsButton.setImage(image: Images.new, width: 35, height: 35)
        wordsButton.setImage(image: Images.bank, width: 40, height: 40)
        hardWordsButton.setImage(image: Images.hard, width: 35, height: 35)
        dropButton.setImage(image: UIImage(), width: 7, height: 7)
    }
    
    func setupButtonShadow(_ button: UIButton, shadowColor: UIColor?){
        button.layer.shadowColor = shadowColor?.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }
    
    func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = Colors.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.black!]
    
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setupCircularProgress(){
        progressValue = wordBrain.calculateLevel()
        levelButton.setTitle(UserDefault.level.getString(), for: .normal)
        
        levelCP.trackColor = UIColor.white
        levelCP.progressColor = Colors.pink ?? .systemPink
        levelCP.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        newWordCP.trackColor = Colors.green ?? .green
        wordsCP.trackColor = Colors.blue ?? .blue
        exerciseCP.trackColor = Colors.purple ?? .purple
        hardCP.trackColor = Colors.yellow ?? .yellow
        
        let goLevelInfo = UITapGestureRecognizer(target: self, action:  #selector(levelButtonPressed))
        levelCP.addGestureRecognizer(goLevelInfo)
        
        let goNewWord = UITapGestureRecognizer(target: self, action:  #selector(newWordsButtonPressed))
        newWordCP.addGestureRecognizer(goNewWord)
        
        let goWordsCP = UITapGestureRecognizer(target: self, action:  #selector(wordsButtonPressed))
        wordsCP.addGestureRecognizer(goWordsCP)
        
        let goExerciseCP = UITapGestureRecognizer(target: self, action:  #selector(exerciseButtonPressed))
        exerciseCP.addGestureRecognizer(goExerciseCP)
        
        let goHardCP = UITapGestureRecognizer(target: self, action:  #selector(hardWordsButtonPressed))
        hardCP.addGestureRecognizer(goHardCP)
    }

    func check2xTime(){
        if UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt() {
          
        } else {
            
        }
    }
    
    func checkWordCount(){
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            performSegue(identifier: "goExercise", second: 0.4)
        }
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

extension HomeViewController {
    
    func style() {
        view.backgroundColor = Colors.raven
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.text = "Word Bank"
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 23)
        titleLabel.textColor = Colors.f6f6f6
        
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        leftLineView.backgroundColor = .white
        
        centerLineView.translatesAutoresizingMaskIntoConstraints = false
        centerLineView.backgroundColor = .white
        
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.backgroundColor = .white
        
        levelButton.translatesAutoresizingMaskIntoConstraints = false
        levelButton.addTarget(self, action: #selector(levelButtonPressed), for: .primaryActionTriggered)
        levelButton.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 30)
        
        exerciseButton.translatesAutoresizingMaskIntoConstraints = false
        exerciseButton.addTarget(self, action: #selector(exerciseButtonPressed), for: .primaryActionTriggered)
        
        newWordsButton.translatesAutoresizingMaskIntoConstraints = false
        newWordsButton.addTarget(self, action: #selector(newWordsButtonPressed), for: .primaryActionTriggered)
        
        wordsButton.translatesAutoresizingMaskIntoConstraints = false
        wordsButton.addTarget(self, action: #selector(wordsButtonPressed), for: .primaryActionTriggered)
        
        hardWordsButton.translatesAutoresizingMaskIntoConstraints = false
        hardWordsButton.addTarget(self, action: #selector(hardWordsButtonPressed), for: .primaryActionTriggered)
        
        dropButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() {
        view.addSubview(titleLabel)
        
        view.addSubview(leftLineView)
        view.addSubview(centerLineView)
        view.addSubview(rightLineView)
        
        view.addSubview(levelCP)
        view.addSubview(exerciseCP)
        view.addSubview(newWordCP)
        view.addSubview(wordsCP)
        view.addSubview(hardCP)
        
        view.addSubview(levelButton)
        view.addSubview(exerciseButton)
        view.addSubview(newWordsButton)
        view.addSubview(wordsButton)
        view.addSubview(hardWordsButton)
        view.addSubview(dropButton)
        
        levelCP.center = CGPoint(x: view.center.x, y: view.center.y-121)
        newWordCP.center = CGPoint(x: view.center.x, y: view.center.y)
        wordsCP.center = CGPoint(x: view.center.x, y: view.center.y+121)
        exerciseCP.center = CGPoint(x: view.center.x+121, y: view.center.y)
        hardCP.center = CGPoint(x: view.center.x-121, y: view.center.y)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -2),
                        
            leftLineView.topAnchor.constraint(equalTo: view.topAnchor),
            leftLineView.leadingAnchor.constraint(equalTo: hardCP.centerXAnchor),
            
            centerLineView.topAnchor.constraint(equalTo: view.topAnchor),
            centerLineView.leadingAnchor.constraint(equalTo: wordsCP.centerXAnchor),
            
            rightLineView.topAnchor.constraint(equalTo: view.topAnchor),
            rightLineView.leadingAnchor.constraint(equalTo: exerciseCP.centerXAnchor),
            
            levelButton.centerXAnchor.constraint(equalTo: levelCP.centerXAnchor),
            levelButton.centerYAnchor.constraint(equalTo: levelCP.centerYAnchor),
            
            exerciseButton.centerXAnchor.constraint(equalTo: exerciseCP.centerXAnchor),
            exerciseButton.centerYAnchor.constraint(equalTo: exerciseCP.centerYAnchor),
            
            newWordsButton.centerXAnchor.constraint(equalTo: newWordCP.centerXAnchor),
            newWordsButton.centerYAnchor.constraint(equalTo: newWordCP.centerYAnchor),
            
            wordsButton.centerXAnchor.constraint(equalTo: wordsCP.centerXAnchor),
            wordsButton.centerYAnchor.constraint(equalTo: wordsCP.centerYAnchor),
            
            hardWordsButton.centerXAnchor.constraint(equalTo: hardCP.centerXAnchor),
            hardWordsButton.centerYAnchor.constraint(equalTo: hardCP.centerYAnchor),
            
            dropButton.centerXAnchor.constraint(equalTo: newWordCP.centerXAnchor, constant: 1),
            dropButton.centerYAnchor.constraint(equalTo: newWordCP.centerYAnchor, constant: 16),
        ])
        
        NSLayoutConstraint.activate([
            leftLineView.heightAnchor.constraint(equalToConstant: hardCP.center.y-40),
            leftLineView.widthAnchor.constraint(equalToConstant: 1),
            
            centerLineView.heightAnchor.constraint(equalToConstant: wordsCP.center.y-40),
            centerLineView.widthAnchor.constraint(equalToConstant: 1),
            
            rightLineView.heightAnchor.constraint(equalToConstant: exerciseCP.center.y-40),
            rightLineView.widthAnchor.constraint(equalToConstant: 1),
        ])
    }
}

//MARK: - Tab Bar

extension HomeViewController {
    
    func configureTabBar() {
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: Colors.blue ?? .blue, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: Images.daily, title: "Daily", titleColor: .darkGray, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(image: Images.award, title: "Awards", titleColor: .darkGray, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
        statisticButton.addTarget(self, action: #selector(statisticButtonPressed), for: .primaryActionTriggered)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
        
        //layout
        tabBarStackView.addArrangedSubview(homeButton)
        tabBarStackView.addArrangedSubview(dailyButton)
        tabBarStackView.addArrangedSubview(awardButton)
        tabBarStackView.addArrangedSubview(statisticButton)
        tabBarStackView.addArrangedSubview(settingsButton)
  
        view.addSubview(tabBarStackView)
        
        NSLayoutConstraint.activate([
            tabBarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tabBarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }

    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = DailyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = AwardsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = StatisticViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        performSegue(identifier: "goSettings", second: 0.0)
    }
}

//MARK: - Keyboard Height

extension HomeViewController {
    func getKeyboardHeight(){
        let textField = UITextField()
        view.addSubview(textField)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        textField.becomeFirstResponder()
        textField.resignFirstResponder()
        textField.removeFromSuperview()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if UserDefault.keyboardHeight.getCGFloat() == 0 {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                let keyboardHeight = CGFloat(keyboardSize.height)
                UserDefault.keyboardHeight.set(keyboardHeight)
            }
        }
    }
}
