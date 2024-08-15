//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

final class HomeController: UIViewController {
    
    private let leftLineView = UIView()
    private let centerLineView = UIView()
    private let rightLineView = UIView()
    
    private let levelButton = UIButton()
    private let menuButton = UIButton()
    private let newWordsButton = UIButton()
    private let wordsButton = UIButton()
    private let hardWordsButton = UIButton()
    private let dropButton = UIButton()
            
    private let levelCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let newWordCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let wordsCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let menuCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    private let hardCP = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    
    private let menuView = MenuView()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var goAddPage = 0
    private var progressValue:Float = 0.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        style()
        layout()
        setupFirstLaunch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBrain.loadItemArray()
        setupCircularProgress()
        setupButtonImages()
        setupNavigationBar()
    }
    
    //MARK: - Selectors
    
    @objc private func levelButtonPressed() {
        levelCP.bounce()
        levelButton.flip()
        
        let vc = LevelInfoController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.updateLevelButtonTitleAfterPressed(isInt: false)
        self.present(vc, animated: false)
    }
    
    @objc private func menuButtonPressed() {
        menuCP.bounce()
        configureMenuView()
    }
    
    @objc private func newWordsButtonPressed() {
        newWordCP.bounce()
        
        newWordsButton.setImage(image: Images.onlyHand, width: 35, height: 35)
        dropButton.setImage(image: Images.drop, width: 7, height: 7)
        dropButton.animateDropDown()
        
        goAddPage = 1
        viewDidLayoutSubviews()
        let controller = WordsController(exerciseType: ExerciseType.normal)
        controller.goAddPage = 1
        pushViewController(controller: controller)
    }
    
    @objc private func wordsButtonPressed() {
        wordsCP.bounce()
        goAddPage = 0
        let controller = WordsController(exerciseType: ExerciseType.normal)
        pushViewController(controller: controller)
    }
    
    @objc private func hardWordsButtonPressed(gesture: UISwipeGestureRecognizer) {
        hardCP.bounce()
        let controller = WordsController(exerciseType: ExerciseType.hard)
        pushViewController(controller: controller)
    }
    
    //MARK: - Helpers
    
    private func configureMenuView() {
        menuView.delegate = self
        view.addSubview(menuView)
        menuView.anchor(top: view.topAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, height: view.frame.height)
        menuView.alpha = 0

        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.alpha = 1
        })
    }
    
    private func dismissMenuView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuView.alpha = 0
            self.menuView.removeFromSuperview()
        }, completion: completion)
    }
    
    private func pushViewController(controller: UIViewController) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
 
    private func setupButtonImages(){
        menuButton.setImage(image: Images.menu, width: 35, height: 35)
        newWordsButton.setImage(image: Images.new, width: 35, height: 35)
        wordsButton.setImage(image: Images.bank, width: 40, height: 40)
        hardWordsButton.setImage(image: Images.hard, width: 35, height: 35)
        dropButton.setImage(image: UIImage(), width: 7, height: 7)
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = Colors.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.black!]
    
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupCircularProgress(){
        progressValue = wordBrain.calculateLevel()
        levelButton.setTitle(UserDefault.level.getString(), for: .normal)
        
        levelCP.trackColor = UIColor.white
        levelCP.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        levelCP.backgroundColor = Colors.pinkLight
        newWordCP.backgroundColor = Colors.greenLight
        wordsCP.backgroundColor = Colors.blueLight
        hardCP.backgroundColor =  Colors.yellowLight
        menuCP.backgroundColor = Colors.purpleLight
        
        levelCP.progressColor = Colors.pink ?? .systemPink
        newWordCP.trackColor = Colors.green ?? .green
        wordsCP.trackColor = Colors.blue ?? .blue
        hardCP.trackColor = Colors.yellow ?? .yellow
        menuCP.trackColor = Colors.purple ?? .purple
        
        let goLevelInfo = UITapGestureRecognizer(target: self, action:  #selector(levelButtonPressed))
        levelCP.addGestureRecognizer(goLevelInfo)
        
        let goNewWord = UITapGestureRecognizer(target: self, action:  #selector(newWordsButtonPressed))
        newWordCP.addGestureRecognizer(goNewWord)
        
        let goWordsCP = UITapGestureRecognizer(target: self, action:  #selector(wordsButtonPressed))
        wordsCP.addGestureRecognizer(goWordsCP)
        
        let goMenuCP = UITapGestureRecognizer(target: self, action:  #selector(menuButtonPressed))
        menuCP.addGestureRecognizer(goMenuCP)
        
        let goHardCP = UITapGestureRecognizer(target: self, action:  #selector(hardWordsButtonPressed))
        hardCP.addGestureRecognizer(goHardCP)
    }

    func checkWordCount(){
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words required", message: "") { _ in
                let controller = WordsController(exerciseType: ExerciseType.normal)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.navigationController?.pushViewController(WheelController(), animated: true)
            }
        }
    }
}

//MARK: - Layout

extension HomeController {
    
    func style() {
        title = "Word Bank"
        view.backgroundColor = Colors.cellLeft
        
        leftLineView.backgroundColor = .darkGray
        centerLineView.backgroundColor = .darkGray
        rightLineView.backgroundColor = .darkGray
        
        levelButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 30)
        levelButton.addTarget(self, action: #selector(levelButtonPressed), for: .primaryActionTriggered)
        menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .primaryActionTriggered)
        newWordsButton.addTarget(self, action: #selector(newWordsButtonPressed), for: .primaryActionTriggered)
        wordsButton.addTarget(self, action: #selector(wordsButtonPressed), for: .primaryActionTriggered)
        hardWordsButton.addTarget(self, action: #selector(hardWordsButtonPressed), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(leftLineView)
        view.addSubview(centerLineView)
        view.addSubview(rightLineView)
        
        view.addSubview(levelCP)
        view.addSubview(menuCP)
        view.addSubview(newWordCP)
        view.addSubview(wordsCP)
        view.addSubview(hardCP)
        
        view.addSubview(levelButton)
        view.addSubview(menuButton)
        view.addSubview(newWordsButton)
        view.addSubview(wordsButton)
        view.addSubview(hardWordsButton)
        view.addSubview(dropButton)
        
        levelCP.center = CGPoint(x: view.center.x, y: view.center.y-121)
        newWordCP.center = CGPoint(x: view.center.x, y: view.center.y)
        wordsCP.center = CGPoint(x: view.center.x, y: view.center.y+121)
        menuCP.center = CGPoint(x: view.center.x+121, y: view.center.y)
        hardCP.center = CGPoint(x: view.center.x-121, y: view.center.y)
        
        leftLineView.anchor(top: view.topAnchor, left: hardCP.centerXAnchor)
        centerLineView.anchor(top: view.topAnchor, left: levelCP.centerXAnchor)
        rightLineView.anchor(top: view.topAnchor, left: menuCP.centerXAnchor)
        
        leftLineView.setDimensions(width: 1, height: hardCP.center.y-40)
        centerLineView.setDimensions(width: 1, height: wordsCP.center.y-40)
        rightLineView.setDimensions(width: 1, height: menuCP.center.y-40)
        
        levelButton.centerX(inView: levelCP)
        levelButton.centerY(inView: levelCP)
        
        menuButton.centerX(inView: menuCP)
        menuButton.centerY(inView: menuCP)
        
        newWordsButton.centerX(inView: newWordCP)
        newWordsButton.centerY(inView: newWordCP)
        
        wordsButton.centerX(inView: wordsCP)
        wordsButton.centerY(inView: wordsCP)
        
        hardWordsButton.centerX(inView: hardCP)
        hardWordsButton.centerY(inView: hardCP)
        
        dropButton.centerX(inView: newWordCP)
        dropButton.centerY(inView: newWordCP, constant: 16)
    }
}

//MARK: - LevelInfoControllerDelegate

extension HomeController: LevelInfoControllerDelegate {
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
}

//MARK: - Keyboard Height

extension HomeController {
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

//MARK: - First Launch

extension HomeController {
    
    func setupFirstLaunch() {
        //version 2.0.1
        if UserDefault.textSize.getValue() == nil {
            UserDefault.textSize.set(15)
            showOnboarding()
            getKeyboardHeight()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5){
                self.wordBrain.loadUser()
                self.wordBrain.loadItemArray()
                self.wordBrain.loadHardItemArray()
                
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
    }

    func showOnboarding(){
        navigationController?.pushViewController(OnboardingContainerViewController(), animated: true)
    }
}

//MARK: - MenuViewDelegate

extension HomeController: MenuViewDelegate {
    func cancel() {
        dismissMenuView()
    }
    
    func daily() {
        navigationController?.pushViewController(DailyController(), animated: true)
    }
    
    func awards() {
        navigationController?.pushViewController(AwardsController(), animated: true)
    }
    
    func stats() {
        navigationController?.pushViewController(StatsController(), animated: true)
    }
    
    func settings() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
