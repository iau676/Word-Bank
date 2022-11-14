//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyViewController: UIViewController {
        
    private let secondView = UIView()
    
    //top tabBar
    private let topTapBarStackView = UIStackView()
    private let dailyTaskButton = UIButton()
    private let x2EventButton = UIButton()
    private let lineView = UIView()
    
    //Daily
    private let taskOneButton = UIButton()
    private let taskOneButtonBlueLayer = UIButton()
    private let taskOneButtonRavenLayer = UIButton()
    
    private let taskTwoButton = UIButton()
    private let taskTwoButtonBlueLayer = UIButton()
    private let taskTwoButtonRavenLayer = UIButton()
    
    private let taskThreeButton = UIButton()
    private let taskThreeButtonBlueLayer = UIButton()
    private let taskThreeButtonRavenLayer = UIButton()

    private let prizeButton = UIButton()
    
    //2x
    private let x2Label = UILabel()
    private let wheelButton = UIButton()
    private let whiteCircleButton = UIButton()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    private var todayDate: String { return wordBrain.getTodayDate() }

    //tabBar
    private let fireworkController = ClassicFireworkController()
    private let tabBarStackView = UIStackView()
    private let homeButton = UIButton()
    private let dailyButton = UIButton()
    private let awardButton = UIButton()
    private let statisticButton = UIButton()
    private let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.getHour()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        wordBrain.findExercisesCompletedToday()

        configureNavigationBar()
        style()
        configureTabBar()
        updateButtons()
        
        showDailyTask()
        hide2xEvent()        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let taskButtonWidth = taskOneButton.frame.width
        layout(taskButtonWidth: taskButtonWidth)
    }
    
    //MARK: - Selectors
    
    @objc func taskOneButtonPressed(){
        UserDefault.startPressed.set(1)
        checkWordCount()
    }
    
    @objc func taskTwoButtonPressed(){
        UserDefault.startPressed.set(2)
        checkWordCount()
    }
    
    @objc func taskThreeButtonPressed(){
        UserDefault.startPressed.set(3)
        checkSoundSetting()
    }
    
    @objc func prizeButtonPressed(){
        prizeButton.bounce()
        UserDefault.userGotDailyPrize.set("willGet")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelViewController(), animated: true)
        }
    }
    
    @objc func wheelButtonPressed(){
        wheelButton.bounce()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelViewController(), animated: true)
        }
    }
    
    @objc func x2EventButtonPressed(){
        hideDailyTask()
        show2xEvent()
    }
    
    @objc func dailyTaskButtonPressed(){
        showDailyTask()
        hide2xEvent()
    }
    
    //MARK: - Helpers
    
    func checkWordCount(){
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            pushExerciseViewController()
        }
    }
    
    func checkSoundSetting(){
        //0 is true, 1 is false
        if UserDefault.playSound.getInt() == 0 {
            UserDefault.startPressed.set(3)
            pushExerciseViewController()
        } else {
            let alert = UIAlertController(title: "To start this exercise, you need to activate the \"Word Sound\" feature.", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.pushViewController(SettingsViewController(), animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func updateButtons(){
        let testExerciseCount = wordBrain.getTestExerciseCountToday()
        let writingExerciseCount = wordBrain.getWritingExerciseCountToday()
        let listeningExerciseCount = wordBrain.getListeningExerciseCountToday()
        
        if testExerciseCount >= 10 && writingExerciseCount >= 10 && listeningExerciseCount >= 10 {
            if UserDefault.userGotDailyPrize.getString() != todayDate {
                prizeButton.isEnabled = true
            }
        }
        
        if testExerciseCount >= 10 {
            taskOneButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
        
        if writingExerciseCount >= 10 {
            taskTwoButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
        
        if writingExerciseCount >= 10 {
            taskThreeButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
    }
    
    func pushExerciseViewController(){
        self.navigationController?.pushViewController(ExerciseViewController(), animated: true)
    }
    
    func configureLayerButton(_ button: UIButton, _ color: UIColor?) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setButtonCornerRadius(8)
        button.backgroundColor = color
    }
    
    func configureButton(_ button: UIButton, _ text: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        button.setButtonCornerRadius(8)
       // button.backgroundColor = UIColor(hex: "#d9d9d9")
    }
    
    func configureNavigationBar(){
        let backButton: UIButton = UIButton()
        let image = UIImage();
        backButton.setImage(image, for: .normal)
        backButton.setTitle("", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        title = "Daily"
    }
    
    private func showDailyTask(){
        taskOneButton.isHidden = false
        taskOneButtonBlueLayer.isHidden = false
        taskOneButtonRavenLayer.isHidden = false
        
        taskTwoButton.isHidden = false
        taskTwoButtonBlueLayer.isHidden = false
        taskTwoButtonRavenLayer.isHidden = false
        
        taskThreeButton.isHidden = false
        taskThreeButtonBlueLayer.isHidden = false
        taskThreeButtonRavenLayer.isHidden = false
        
        prizeButton.isHidden = false
    }
    
    private func show2xEvent(){
        secondView.backgroundColor = Colors.pink
        x2Label.isHidden = false
        wheelButton.isHidden = false
        whiteCircleButton.isHidden = false
        
        if UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt() {
            x2Label.text = "You are on 2x points hour!\n\nYou will earn 2x points for each correct answer.\n\nYou can change this hour on settings."
            wheelButton.isEnabled = true
            whiteCircleButton.alpha = 1
        } else {
            x2Label.text = "You will earn 2x points for each correct answer between \(wordBrain.hours[UserDefault.userSelectedHour.getInt()])  hours.\n\nYou can change this hour on settings."
            wheelButton.isEnabled = false
            whiteCircleButton.alpha = 0.7
        }
    }
    
    private func hideDailyTask(){
        taskOneButton.isHidden = true
        taskOneButtonBlueLayer.isHidden = true
        taskOneButtonRavenLayer.isHidden = true
        
        taskTwoButton.isHidden = true
        taskTwoButtonBlueLayer.isHidden = true
        taskTwoButtonRavenLayer.isHidden = true
        
        taskThreeButton.isHidden = true
        taskThreeButtonBlueLayer.isHidden = true
        taskThreeButtonRavenLayer.isHidden = true
        
        prizeButton.isHidden = true
    }
    
    private func hide2xEvent(){
        secondView.backgroundColor = Colors.cellRight
        x2Label.isHidden = true
        wheelButton.isHidden = true
        whiteCircleButton.isHidden = true
    }
}

//MARK: - Layout

extension DailyViewController {
    
    private func style(){
        view.backgroundColor = Colors.cellLeft
        
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.backgroundColor = Colors.cellRight
        secondView.setViewCornerRadius(10)
        
        //top tabBar
        topTapBarStackView.translatesAutoresizingMaskIntoConstraints = false
        topTapBarStackView.axis = .horizontal
        topTapBarStackView.distribution = .fillEqually
        topTapBarStackView.spacing = 0
        
        dailyTaskButton.translatesAutoresizingMaskIntoConstraints = false
        dailyTaskButton.setImage(image: Images.wheel_prize_present, width: 25, height: 25)
        dailyTaskButton.setButtonCornerRadius(8)
        dailyTaskButton.layer.maskedCorners = [.layerMinXMinYCorner]
        dailyTaskButton.backgroundColor = Colors.cellRight
        dailyTaskButton.addTarget(self, action: #selector(dailyTaskButtonPressed), for: .primaryActionTriggered)
        
        x2EventButton.translatesAutoresizingMaskIntoConstraints = false
        x2EventButton.setImage(image: UIImage(named: "x2V"), width: 25, height: 25)
        x2EventButton.setButtonCornerRadius(8)
        x2EventButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        x2EventButton.backgroundColor = Colors.pink
        x2EventButton.addTarget(self, action: #selector(x2EventButtonPressed), for: .primaryActionTriggered)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .systemGray5
        
        //Daily
        configureButton(taskOneButton, "Complete 10 Test Exercise")
        configureButton(taskTwoButton, "Complete 10 Writing Exercise")
        configureButton(taskThreeButton, "Complete 10 Listening Exercise")
        configureButton(prizeButton, "")
        
        taskOneButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        taskTwoButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        taskThreeButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        
        taskOneButton.moveImageTitleLeft()
        taskTwoButton.moveImageTitleLeft()
        taskThreeButton.moveImageTitleLeft()
        
        taskOneButton.addTarget(self, action: #selector(taskOneButtonPressed), for: .primaryActionTriggered)
        taskTwoButton.addTarget(self, action: #selector(taskTwoButtonPressed), for: .primaryActionTriggered)
        taskThreeButton.addTarget(self, action: #selector(taskThreeButtonPressed), for: .primaryActionTriggered)
        
        configureLayerButton(taskOneButtonBlueLayer, Colors.blue)
        configureLayerButton(taskOneButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskTwoButtonBlueLayer, Colors.blue)
        configureLayerButton(taskTwoButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskThreeButtonBlueLayer, Colors.blue)
        configureLayerButton(taskThreeButtonRavenLayer, Colors.raven)
        
        prizeButton.setImage(image: Images.wheel_prize_present, width: 128, height: 128)
        prizeButton.backgroundColor = .clear
        prizeButton.isEnabled = false
        prizeButton.addTarget(self, action: #selector(prizeButtonPressed), for: .primaryActionTriggered)
        
        //2x
        x2Label.translatesAutoresizingMaskIntoConstraints = false
        x2Label.font = UIFont(name: "AvenirNext-Regular", size: 21)
        x2Label.textColor = Colors.f6f6f6
        x2Label.numberOfLines = 0
        x2Label.textAlignment = .center
        
        wheelButton.translatesAutoresizingMaskIntoConstraints = false
        wheelButton.setImage(image: Images.wheelicon, width: 128, height: 128)
        wheelButton.backgroundColor = .clear
        wheelButton.isEnabled = true
        wheelButton.addTarget(self, action: #selector(wheelButtonPressed), for: .primaryActionTriggered)
        
        whiteCircleButton.translatesAutoresizingMaskIntoConstraints = false
        whiteCircleButton.backgroundColor = .white
        whiteCircleButton.setButtonCornerRadius(9)
        whiteCircleButton.layer.borderWidth = 0.6
        whiteCircleButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func layout(taskButtonWidth: CGFloat){
        view.addSubview(secondView)
        
        //top tabBar
        topTapBarStackView.addArrangedSubview(dailyTaskButton)
        topTapBarStackView.addArrangedSubview(x2EventButton)
        secondView.addSubview(topTapBarStackView)
        secondView.addSubview(lineView)
        
        //Daily
        secondView.addSubview(taskOneButtonRavenLayer)
        secondView.addSubview(taskOneButtonBlueLayer)
        secondView.addSubview(taskOneButton)
        
        secondView.addSubview(taskTwoButtonRavenLayer)
        secondView.addSubview(taskTwoButtonBlueLayer)
        secondView.addSubview(taskTwoButton)
        
        secondView.addSubview(taskThreeButtonRavenLayer)
        secondView.addSubview(taskThreeButtonBlueLayer)
        secondView.addSubview(taskThreeButton)
        
        secondView.addSubview(prizeButton)
        
        //2x
        secondView.addSubview(x2Label)
        secondView.addSubview(wheelButton)
        secondView.addSubview(whiteCircleButton)
        
        let taskOneBlueLayerWidth = taskButtonWidth-(taskButtonWidth/10)*CGFloat(wordBrain.getTestExerciseCountToday())
        let taskTwoBlueLayerWidth = taskButtonWidth-(taskButtonWidth/10)*CGFloat(wordBrain.getWritingExerciseCountToday())
        let taskThreeBlueLayerWidth = taskButtonWidth-(taskButtonWidth/10)*CGFloat(wordBrain.getListeningExerciseCountToday())
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: view.topAnchor, constant: wordBrain.getTopBarHeight() + 8),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -82)
        ])
        
        //top tabBar
        NSLayoutConstraint.activate([
            topTapBarStackView.topAnchor.constraint(equalTo: secondView.topAnchor),
            topTapBarStackView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            topTapBarStackView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            topTapBarStackView.heightAnchor.constraint(equalToConstant: 66),
        ])
        
        NSLayoutConstraint.activate([
            lineView.topAnchor.constraint(equalTo: topTapBarStackView.bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        //Daily
        NSLayoutConstraint.activate([
            taskOneButtonRavenLayer.topAnchor.constraint(equalTo: topTapBarStackView.bottomAnchor, constant: 32),
            taskOneButtonRavenLayer.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            taskOneButtonRavenLayer.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            taskOneButtonRavenLayer.heightAnchor.constraint(equalToConstant: 66),
            
            taskOneButtonBlueLayer.topAnchor.constraint(equalTo: taskOneButtonRavenLayer.topAnchor),
            taskOneButtonBlueLayer.leadingAnchor.constraint(equalTo: taskOneButtonRavenLayer.leadingAnchor),
            taskOneButtonBlueLayer.trailingAnchor.constraint(equalTo: taskOneButtonRavenLayer.trailingAnchor, constant: -taskOneBlueLayerWidth),
            taskOneButtonBlueLayer.heightAnchor.constraint(equalTo: taskOneButtonRavenLayer.heightAnchor),
            
            taskOneButton.topAnchor.constraint(equalTo: taskOneButtonRavenLayer.topAnchor),
            taskOneButton.leadingAnchor.constraint(equalTo: taskOneButtonRavenLayer.leadingAnchor),
            taskOneButton.trailingAnchor.constraint(equalTo: taskOneButtonRavenLayer.trailingAnchor),
            taskOneButton.heightAnchor.constraint(equalTo: taskOneButtonRavenLayer.heightAnchor)
        ])
       
        NSLayoutConstraint.activate([
            taskTwoButtonRavenLayer.topAnchor.constraint(equalTo: taskOneButtonRavenLayer.bottomAnchor, constant: 16),
            taskTwoButtonRavenLayer.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            taskTwoButtonRavenLayer.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            taskTwoButtonRavenLayer.heightAnchor.constraint(equalToConstant: 66),
            
            taskTwoButtonBlueLayer.topAnchor.constraint(equalTo: taskTwoButtonRavenLayer.topAnchor),
            taskTwoButtonBlueLayer.leadingAnchor.constraint(equalTo: taskTwoButtonRavenLayer.leadingAnchor),
            taskTwoButtonBlueLayer.trailingAnchor.constraint(equalTo: taskTwoButtonRavenLayer.trailingAnchor, constant: -taskTwoBlueLayerWidth),
            taskTwoButtonBlueLayer.heightAnchor.constraint(equalTo: taskTwoButtonRavenLayer.heightAnchor),
            
            taskTwoButton.topAnchor.constraint(equalTo: taskTwoButtonRavenLayer.topAnchor),
            taskTwoButton.leadingAnchor.constraint(equalTo: taskTwoButtonRavenLayer.leadingAnchor),
            taskTwoButton.trailingAnchor.constraint(equalTo: taskTwoButtonRavenLayer.trailingAnchor),
            taskTwoButton.heightAnchor.constraint(equalTo: taskTwoButtonRavenLayer.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            taskThreeButtonRavenLayer.topAnchor.constraint(equalTo: taskTwoButtonRavenLayer.bottomAnchor, constant:16),
            taskThreeButtonRavenLayer.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            taskThreeButtonRavenLayer.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            taskThreeButtonRavenLayer.heightAnchor.constraint(equalToConstant: 66),
            
            taskThreeButtonBlueLayer.topAnchor.constraint(equalTo: taskThreeButtonRavenLayer.topAnchor),
            taskThreeButtonBlueLayer.leadingAnchor.constraint(equalTo: taskThreeButtonRavenLayer.leadingAnchor),
            taskThreeButtonBlueLayer.trailingAnchor.constraint(equalTo: taskThreeButtonRavenLayer.trailingAnchor, constant: -taskThreeBlueLayerWidth),
            taskThreeButtonBlueLayer.heightAnchor.constraint(equalTo: taskThreeButtonRavenLayer.heightAnchor),
            
            taskThreeButton.topAnchor.constraint(equalTo: taskThreeButtonRavenLayer.topAnchor),
            taskThreeButton.leadingAnchor.constraint(equalTo: taskThreeButtonRavenLayer.leadingAnchor),
            taskThreeButton.trailingAnchor.constraint(equalTo: taskThreeButtonRavenLayer.trailingAnchor),
            taskThreeButton.heightAnchor.constraint(equalTo: taskThreeButtonRavenLayer.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            prizeButton.topAnchor.constraint(equalTo: taskThreeButtonRavenLayer.bottomAnchor, constant: 32),
            prizeButton.centerXAnchor.constraint(equalTo: secondView.centerXAnchor),
            prizeButton.widthAnchor.constraint(equalToConstant: 128),
            prizeButton.heightAnchor.constraint(equalToConstant: 128),
        ])
        
        //2x
        NSLayoutConstraint.activate([
            x2Label.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 128),
            x2Label.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            x2Label.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            wheelButton.topAnchor.constraint(equalTo: taskThreeButtonRavenLayer.bottomAnchor, constant: 32),
            wheelButton.centerXAnchor.constraint(equalTo: secondView.centerXAnchor),
            wheelButton.widthAnchor.constraint(equalToConstant: 128),
            wheelButton.heightAnchor.constraint(equalToConstant: 128),
            
            whiteCircleButton.centerXAnchor.constraint(equalTo: wheelButton.centerXAnchor),
            whiteCircleButton.centerYAnchor.constraint(equalTo: wheelButton.centerYAnchor),
            whiteCircleButton.widthAnchor.constraint(equalToConstant: 18),
            whiteCircleButton.heightAnchor.constraint(equalToConstant: 18),
        ])
    }
}


//MARK: - Tab Bar

extension DailyViewController {
    
    func configureTabBar() {
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()], title: "Daily", titleColor: Colors.blue ?? .blue, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(image: Images.award, title: "Awards", titleColor: .darkGray, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        awardButton.addTarget(self, action: #selector(awardsButtonPressed), for: .primaryActionTriggered)
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
    
    @objc func homeButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: UIViewController(), button: homeButton)
    }

    @objc func awardsButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: AwardsViewController(), button: awardButton)
    }
  
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: StatisticViewController(), button: statisticButton)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: SettingsViewController(), button: settingsButton)
    }
    
    func pushVC(vc: UIViewController, button: UIButton){
        self.fireworkController.addFireworks(count: 5, sparks: 5, around: button)
        UserDefault.whichButton.set(ExerciseType.normal)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15){
            if button == self.homeButton {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
