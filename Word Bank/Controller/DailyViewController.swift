//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyViewController: UIViewController {
        
    private let secondView = UIView()
    
    private let taskOneButton = UIButton()
    private let taskOneButtonBlueLayer = UIButton()
    private let taskOneButtonRavenLayer = UIButton()
    
    private let taskTwoButton = UIButton()
    private let taskTwoButtonBlueLayer = UIButton()
    private let taskTwoButtonRavenLayer = UIButton()
    
    private let taskThreeButton = UIButton()
    private let taskThreeButtonBlueLayer = UIButton()
    private let taskThreeButtonRavenLayer = UIButton()
    
    private var taskButtonWidth:CGFloat = 0
    
    private let prizeButton = UIButton()

    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        style()
        layout()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        taskButtonWidth = taskThreeButton.frame.width
    }
    
    private func style(){
        view.backgroundColor = Colors.cellLeft
        
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.backgroundColor = Colors.cellRight
        secondView.setViewCornerRadius(10)
        
        configureButton(taskOneButton, "Complete 10 Test Exercise")
        configureButton(taskTwoButton, "Complete 10 Writing Exercise")
        configureButton(taskThreeButton, "Complete 10 Listening Exercise")
        configureButton(prizeButton, "")
        
        taskOneButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        taskTwoButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        taskThreeButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        
        taskOneButton.moveImageTitleLeft()
        taskTwoButton.moveImageTitleLeft()
        taskThreeButton.moveImageTitleLeft()
        
        taskOneButton.addTarget(self, action: #selector(taskOneButtonPressed), for: .primaryActionTriggered)
        taskTwoButton.addTarget(self, action: #selector(taskTwoButtonPressed), for: .primaryActionTriggered)
        taskThreeButton.addTarget(self, action: #selector(taskThreeButtonPressed), for: .primaryActionTriggered)
        
        prizeButton.setImage(imageName: "wheel_prize_present", width: 128, height: 128)
        prizeButton.backgroundColor = .clear
        prizeButton.alpha = 0.5
        
        configureLayerButton(taskOneButtonBlueLayer, Colors.blue)
        configureLayerButton(taskOneButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskTwoButtonBlueLayer, Colors.blue)
        configureLayerButton(taskTwoButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskThreeButtonBlueLayer, Colors.blue)
        configureLayerButton(taskThreeButtonRavenLayer, Colors.raven)
    }
    
    private func layout(){
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
        
        view.addSubview(secondView)
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -82)
        ])
        
        NSLayoutConstraint.activate([
            taskOneButtonRavenLayer.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 32),
            taskOneButtonRavenLayer.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            taskOneButtonRavenLayer.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            taskOneButtonRavenLayer.heightAnchor.constraint(equalToConstant: 66),
            
            taskOneButtonBlueLayer.topAnchor.constraint(equalTo: taskOneButtonRavenLayer.topAnchor),
            taskOneButtonBlueLayer.leadingAnchor.constraint(equalTo: taskOneButtonRavenLayer.leadingAnchor),
            taskOneButtonBlueLayer.trailingAnchor.constraint(equalTo: taskOneButtonRavenLayer.trailingAnchor, constant: -279),
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
            taskTwoButtonBlueLayer.trailingAnchor.constraint(equalTo: taskTwoButtonRavenLayer.trailingAnchor, constant: -139),
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
            taskThreeButtonBlueLayer.trailingAnchor.constraint(equalTo: taskThreeButtonRavenLayer.trailingAnchor, constant: -27),
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
    }
    
    @objc func taskOneButtonPressed(){
        UserDefault.startPressed.set(1)
        pushExerciseViewController()
    }
    
    @objc func taskTwoButtonPressed(){
        UserDefault.startPressed.set(2)
        pushExerciseViewController()
    }
    
    @objc func taskThreeButtonPressed(){
        UserDefault.startPressed.set(3)
        pushExerciseViewController()
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
}


//MARK: - Tab Bar

extension DailyViewController {
    
    func configureTabBar() {
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(imageName: "home", title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(imageName: "dailyQuest", title: "Daily", titleColor: Colors.blue ?? .blue, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(imageName: "award", title: "Awards", titleColor: .darkGray, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(imageName: "statistic", title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(imageName: "settingsImage", title: "Settings", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        
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
        self.navigationController?.popToRootViewController(animated: true)
    }

    @objc func awardsButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = AwardsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
  
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = StatisticViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
