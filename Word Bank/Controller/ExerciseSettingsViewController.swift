//
//  ExerciseSettingsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 9.12.2022.
//

import UIKit

class ExerciseSettingsViewController: UIViewController {
    
    let testTypeView = UIView()
    let testTypeStackView = UIStackView()
    let testTypeLabel = UILabel()
    let testTypeSegmentedControl = UISegmentedControl()
    
    var wordBrain = WordBrain()
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    //tabBar
    private let fireworkController = ClassicFireworkController()
    private var timerDaily = Timer()
    private let tabBarStackView = UIStackView()
    private let homeButton = UIButton()
    private let dailyButton = UIButton()
    private let awardButton = UIButton()
    private let statisticButton = UIButton()
    private let settingsButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        title = "Exercise Settings"
        configureTabBar()
        style()
        layout()
    }
    
    //MARK: - Helpers
    
    private func setColors(){
        view.backgroundColor = Colors.cellLeft
        testTypeView.backgroundColor = Colors.cellRight
        testTypeLabel.textColor = Colors.black
        testTypeSegmentedControl.tintColor = .black
    }
    
    //MARK: - Layout
    
    private func style(){
        setColors()
        
        testTypeView.translatesAutoresizingMaskIntoConstraints = false
        testTypeView.setViewCornerRadius(8)
        
        testTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        testTypeStackView.axis = .vertical
        testTypeStackView.spacing = 8
        testTypeStackView.distribution = .fill
        
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.text = "Test Type"
        testTypeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        testTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        testTypeSegmentedControl.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        testTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black ?? .black, .font: UIFont.systemFont(ofSize: textSize-3),], for: .normal)
        testTypeSegmentedControl.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        testTypeSegmentedControl.addTarget(self, action: #selector(testTypeChanged(_:)), for: UIControl.Event.valueChanged)
    }
    
    private func layout(){
        view.addSubview(testTypeView)
        testTypeView.addSubview(testTypeStackView)
        testTypeStackView.addArrangedSubview(testTypeLabel)
        testTypeStackView.addArrangedSubview(testTypeSegmentedControl)
        
        NSLayoutConstraint.activate([
            testTypeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            testTypeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            testTypeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            testTypeStackView.topAnchor.constraint(equalTo: testTypeView.topAnchor, constant: 16),
            testTypeStackView.leadingAnchor.constraint(equalTo: testTypeView.leadingAnchor, constant: 16),
            testTypeStackView.trailingAnchor.constraint(equalTo: testTypeView.trailingAnchor, constant: -16),
            testTypeStackView.bottomAnchor.constraint(equalTo: testTypeView.bottomAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            testTypeView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    //MARK: - Selectors
    
    @objc func testTypeChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedTestType.set(sender.selectedSegmentIndex)
    }
}

//MARK: - Tab Bar

extension ExerciseSettingsViewController {
    
    func configureTabBar() {
        
        var whichImage: Int = 0
        self.timerDaily = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if self.wordBrain.getCurrentHour() == UserDefault.userSelectedHour.getInt() {
                whichImage += 1
                self.updateDailyButtonImage(whichImage)
            }
        })
        
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()], title: "Daily", titleColor: .darkGray, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(image: Images.award, title: "Awards", titleColor: .darkGray, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: Colors.blue ?? .blue, imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
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
    
    @objc func homeButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: UIViewController(), button: homeButton)
    }
    
    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: DailyViewController(), button: dailyButton)
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: AwardsViewController(), button: awardButton)
    }
    
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: StatisticViewController(), button: statisticButton)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushVC(vc: UIViewController, button: UIButton){
        timerDaily.invalidate()
        self.fireworkController.addFireworks(count: 5, sparks: 5, around: button)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15){
            if button == self.homeButton {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func updateDailyButtonImage(_ whichImage: Int){
        UIView.transition(with: dailyButton.imageView ?? dailyButton, duration: 0.8,
                          options: .transitionFlipFromBottom,
                          animations: {
            if whichImage % 2 == 0 {
                self.dailyButton.setImageWithRenderingMode(image: self.wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()], width: 26, height: 26, color: .darkGray)
            } else {
                self.dailyButton.setImage(image: Images.x2Tab, width: 26, height: 26)
            }
        })
    }
}
