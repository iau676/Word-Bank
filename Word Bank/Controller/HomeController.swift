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
    
    //MARK: - Properties
    
    private let leftLineView = makeLineView()
    private let centerLineView = makeLineView()
    private let rightLineView = makeLineView()
    
    private let levelCP = CircularProgressView(progressColor: Colors.pink, trackColor: UIColor.white, bgColor: Colors.pinkLight)
    
    private let newWordCP: CircularProgressView = {
       let view = CircularProgressView(progressColor: Colors.green, trackColor: Colors.green, bgColor: Colors.greenLight)
        view.button.setImage(image: Images.onlyHand, width: 35, height: 35)
        return view
    }()
    
    private let dropButton: UIButton = {
        let button = UIButton()
        button.setImage(image: Images.drop, width: 7, height: 7)
        return button
    }()
    
    private let wordsCP: CircularProgressView = {
       let view = CircularProgressView(progressColor: Colors.blue, trackColor: Colors.blue, bgColor: Colors.blueLight)
        view.button.setImage(image: Images.bank, width: 40, height: 40)
        return view
    }()
    
    private let hardCP: CircularProgressView = {
       let view = CircularProgressView(progressColor: Colors.yellow, trackColor: Colors.yellow, bgColor: Colors.yellowLight)
        view.button.setImage(image: Images.hard, width: 35, height: 35)
        return view
    }()
    
    private let menuCP: CircularProgressView = {
       let view = CircularProgressView(progressColor: Colors.purple, trackColor: Colors.purple, bgColor: Colors.purpleLight)
        view.button.setImage(image: Images.menu, width: 32, height: 32)
        return view
    }()
    
    private let menuView = MenuView()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var goAddPage = 0
    private var progressValue:Float = 0.0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        configureUI()
        setupNavigationBar()
        setupFirstLaunch()
        addGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        wordBrain.loadItemArray()
        configureLevelProgress()
    }
    
    //MARK: - Selectors
    
    @objc private func levelButtonPressed() {
        levelCP.bounce()
        levelCP.button.flip()
        
        let vc = LevelInfoController()
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        self.updateLevelButtonTitleAfterPressed(isInt: false)
        self.present(vc, animated: false)
    }
    
    @objc private func newWordsButtonPressed() {
        newWordCP.bounce()
        dropButton.animateDropDown()
        
        goAddPage = 1
        viewDidLayoutSubviews()
        let controller = WordsController(exerciseType: ExerciseType.normal)
        controller.goAddPage = 1
        pushViewControllerWithDeadline(controller: controller, deadline: 0.25)
    }
    
    @objc private func wordsButtonPressed() {
        wordsCP.bounce()
        goAddPage = 0
        let controller = WordsController(exerciseType: ExerciseType.normal)
        pushViewControllerWithDeadline(controller: controller)
    }
    
    @objc private func hardWordsButtonPressed() {
        hardCP.bounce()
        let controller = WordsController(exerciseType: ExerciseType.hard)
        pushViewControllerWithDeadline(controller: controller)
    }
    
    @objc private func menuButtonPressed() {
        menuCP.bounce()
        configureMenuView()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "Word Bank"
        view.backgroundColor = Colors.cellRight
        
        view.addSubview(leftLineView)
        view.addSubview(centerLineView)
        view.addSubview(rightLineView)
        
        view.addSubview(levelCP)
        view.addSubview(menuCP)
        view.addSubview(newWordCP)
        view.addSubview(wordsCP)
        view.addSubview(hardCP)
        
        levelCP.center = CGPoint(x: view.center.x, y: view.center.y-121)
        newWordCP.center = CGPoint(x: view.center.x, y: view.center.y)
        wordsCP.center = CGPoint(x: view.center.x, y: view.center.y+121)
        menuCP.center = CGPoint(x: view.center.x+121, y: view.center.y)
        hardCP.center = CGPoint(x: view.center.x-121, y: view.center.y)
        
        leftLineView.anchor(top: view.topAnchor, left: hardCP.centerXAnchor, bottom: hardCP.topAnchor)
        centerLineView.anchor(top: view.topAnchor, left: levelCP.centerXAnchor, bottom: wordsCP.topAnchor)
        rightLineView.anchor(top: view.topAnchor, left: menuCP.centerXAnchor, bottom: menuCP.topAnchor)
        
        view.addSubview(dropButton)
        dropButton.anchor(left: newWordCP.leftAnchor, paddingLeft: 48)
        dropButton.centerY(inView: newWordCP, constant: 16)
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = Colors.black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Colors.black]
    
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func addGestures() {
        levelCP.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(levelButtonPressed)))
        levelCP.button.addTarget(self, action: #selector(levelButtonPressed), for: .touchUpInside)
        
        newWordCP.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(newWordsButtonPressed)))
        newWordCP.button.addTarget(self, action: #selector(newWordsButtonPressed), for: .touchUpInside)
        
        wordsCP.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(wordsButtonPressed)))
        wordsCP.button.addTarget(self, action: #selector(wordsButtonPressed), for: .touchUpInside)
        
        hardCP.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(hardWordsButtonPressed)))
        hardCP.button.addTarget(self, action: #selector(hardWordsButtonPressed), for: .touchUpInside)
        
        menuCP.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(menuButtonPressed)))
        menuCP.button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
    }
    
    private func configureMenuView() {
        menuView.delegate = self
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [Colors.purple.cgColor, Colors.purpleLight.cgColor]
        menuView.layer.insertSublayer(gradient, at: 0)
        
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
    
    private func configureLevelProgress(){
        progressValue = Level.shared.calculateLevel()
        levelCP.button.setTitle(UserDefault.level.getString(), for: .normal)
        levelCP.setProgressWithAnimation(duration: 1.0, value: progressValue)
    }
}

//MARK: - LevelInfoControllerDelegate

extension HomeController: LevelInfoControllerDelegate {
    func updateLevelButtonTitleAfterPressed(isInt: Bool) {
        if isInt {
            UIView.transition(with: self.levelCP.button, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelCP.button.setTitle(UserDefault.level.getString(), for: .normal)
                self.levelCP.button.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 30)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
                self.levelCP.button.setTitle("\(String(format: "%.2f", self.progressValue*100))%", for: .normal)
                self.levelCP.button.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 20)
            }
        }
    }
}

//MARK: - MenuViewDelegate

extension HomeController: MenuViewDelegate {
    func close() {
        dismissMenuView()
    }
    
    func daily() {
        pushViewControllerWithDeadline(controller: DailyController())
    }
    
    func awards() {
        pushViewControllerWithDeadline(controller: AwardsController())
    }
    
    func stats() {
        pushViewControllerWithDeadline(controller: StatsController())
    }
    
    func settings() {
        pushViewControllerWithDeadline(controller: SettingsController())
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
