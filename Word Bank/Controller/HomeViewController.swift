//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

final class HomeViewController: UIViewController, LevelDelegate {
    
    private let leftLineView = UIView()
    private let centerLineView = UIView()
    private let rightLineView = UIView()
    
    private let levelButton = UIButton()
    private let exerciseButton = UIButton()
    private let newWordsButton = UIButton()
    private let wordsButton = UIButton()
    private let hardWordsButton = UIButton()
    private let dropButton = UIButton()
            
    private let levelCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let newWordCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let wordsCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let exerciseCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let hardCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var goAddPage = 0
    private var progressValue:Float = 0.0
    
    private let tabBar = TabBar(color1: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        fixSoundProblemForRealDevice()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBrain.loadItemArray()
        setupCircularProgress()
        setupButtonImages()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupFirstLaunch()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goWords" {
            let destinationVC = segue.destination as! WordsViewController
            destinationVC.goAddPage = goAddPage
        }
    }
    
    //MARK: - Selectors
    
    @objc func levelButtonPressed() {
        levelCP.bounce()
        levelButton.flip()
        
        let vc = LevelInfoViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.updateLevelButtonTitleAfterPressed(isInt: false)
        self.present(vc, animated: false)
    }
    
    @objc func exerciseButtonPressed() {
        exerciseCP.bounce()
        
        UserDefault.whichButton.set(ExerciseType.normal)
        UserDefault.spinWheelCount.set(UserDefault.spinWheelCount.getInt()+1)
        checkWordCount()
    }
    
    @objc func newWordsButtonPressed() {
        newWordCP.bounce()
        
        newWordsButton.setImage(image: Images.onlyHand, width: 35, height: 35)
        dropButton.setImage(image: Images.drop, width: 7, height: 7)
        dropButton.animateDropDown()
        
        UserDefault.startPressed.set(1)
        UserDefault.whichButton.set(ExerciseType.normal)
        goAddPage = 1
        viewDidLayoutSubviews()
        performSegue(identifier: "goWords", second: 0.2)
    }
    
    @objc func wordsButtonPressed() {
        wordsCP.bounce()
        
        UserDefault.whichButton.set(ExerciseType.normal)
        goAddPage = 0
        performSegue(identifier: "goWords", second: 0.1)
    }
    
    @objc func hardWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        hardCP.bounce()
        
        UserDefault.whichButton.set(ExerciseType.hard)
        performSegue(identifier: "goWords", second: 0.1)
    }
    
    //MARK: - Helpers
    
    func updateLevelButtonTitleAfterPressed(isInt: Bool) {
        if isInt {
            UIView.transition(with: self.levelButton, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelButton.setTitle(UserDefault.level.getString(), for: .normal)
                self.levelButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 30)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelButton.setTitle("\(String(format: "%.2f", self.progressValue*100))%", for: .normal)
                self.levelButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 20)
            }
        }
    }
    
    func performSegue(identifier: String, second: Double = 0.0){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + second){
            self.performSegue(withIdentifier: identifier, sender: self)
        }
    }
 
    func setupButtonImages(){
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
        levelCP.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        levelCP.backgroundColor = Colors.pinkLight
        newWordCP.backgroundColor = Colors.greenLight
        wordsCP.backgroundColor = Colors.blueLight
        hardCP.backgroundColor =  Colors.yellowLight
        exerciseCP.backgroundColor = Colors.purpleLight
        
        levelCP.progressColor = Colors.pink ?? .systemPink
        newWordCP.trackColor = Colors.green ?? .green
        wordsCP.trackColor = Colors.blue ?? .blue
        hardCP.trackColor = Colors.yellow ?? .yellow
        exerciseCP.trackColor = Colors.purple ?? .purple
        
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

    func checkWordCount(){
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words are required", message: "")
        } else {
            performSegue(identifier: "goExercise", second: 0.1)
        }
    }
        
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self,
                             selector: selector, userInfo: nil, repeats: false)
    }

    func fixSoundProblemForRealDevice(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
    }
}

//MARK: - Layout

extension HomeViewController {
    
    func style() {
        title = "Word Bank"
        view.backgroundColor = Colors.cellLeft
        
        tabBar.delegate = self
        
        leftLineView.translatesAutoresizingMaskIntoConstraints = false
        leftLineView.backgroundColor = .darkGray
        
        centerLineView.translatesAutoresizingMaskIntoConstraints = false
        centerLineView.backgroundColor = .darkGray
        
        rightLineView.translatesAutoresizingMaskIntoConstraints = false
        rightLineView.backgroundColor = .darkGray
        
        levelButton.translatesAutoresizingMaskIntoConstraints = false
        levelButton.addTarget(self, action: #selector(levelButtonPressed), for: .primaryActionTriggered)
        levelButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 30)
        
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
        
        view.addSubview(tabBar)
        tabBar.setDimensions(height: 66, width: view.bounds.width)
        tabBar.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

//MARK: - TabBarDelegate

extension HomeViewController: TabBarDelegate {
    
    func homePressed() {
        //navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        pushVC(vc: DailyViewController())
    }
    
    func awardPressed() {
        pushVC(vc: AwardsViewController())
    }
    
    func statisticPressed() {
        pushVC(vc: StatisticViewController())
    }
    
    func settingPressed() {
        pushVC(vc: SettingsViewController())
    }
    
    func pushVC(vc: UIViewController){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05){
           self.navigationController?.pushViewController(vc, animated: true)
        }
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

//MARK: - Top Bar Height

extension HomeViewController {
    func getTopBarHeight(){
        UserDefault.topBarHeight.set(self.topbarHeight)
    }
}

//MARK: - First Launch

extension HomeViewController {
    
    func setupFirstLaunch() {
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
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
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
            //getTopBarHeight()
        }
        
        if UserDefault.topBarHeight.getCGFloat() == 0 {
            getTopBarHeight()
        }
        
        if UserDefault.setNotificationFirstTime.getInt() == 0 {
            wordBrain.setNotification()
            UserDefault.setNotificationFirstTime.set(1)
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
    
    @objc func appendDefaultWords() {
        let defaultWordsCount = wordBrain.defaultWords.count
        
        for index in 0..<defaultWordsCount {
            wordBrain.addWord(english: "\(wordBrain.defaultWords[index].eng)",
                              meaning: "\(wordBrain.defaultWords[index].tr)")
        }
        UserDefault.userWordCount.set(defaultWordsCount)
     }
}
