//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyViewController: UIViewController {
        
    private let secondView = UIView()
    
    private let questOneButton = UIButton()
    private let questTwoButton = UIButton()
    private let questThreeButton = UIButton()
    
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
    
    private func style(){
        view.backgroundColor = Colors.cellLeft
        
        secondView.translatesAutoresizingMaskIntoConstraints = false
        secondView.backgroundColor = Colors.cellRight
        secondView.setViewCornerRadius(10)
        
        configureButton(questOneButton, "Complete 10 Test Exercise")
        configureButton(questTwoButton, "Complete 10 Writing Exercise")
        configureButton(questThreeButton, "Complete 10 Listening Exercise")
        configureButton(prizeButton, "")
        
        questOneButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        questTwoButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        questThreeButton.setImageWithRenderingMode(imageName: "checkGreen", width: 25, height: 25, color: .white)
        
        questOneButton.moveImageTitleLeft()
        questTwoButton.moveImageTitleLeft()
        questThreeButton.moveImageTitleLeft()
        
        prizeButton.setImage(imageName: "wheel_prize_present", width: 128, height: 128)
        prizeButton.backgroundColor = .clear
        prizeButton.alpha = 0.5
    }
    
    private func layout(){

        secondView.addSubview(questOneButton)
        secondView.addSubview(questTwoButton)
        secondView.addSubview(questThreeButton)
        
        secondView.addSubview(prizeButton)
        
        view.addSubview(secondView)
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            secondView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            secondView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            secondView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -82)
        ])
        
        NSLayoutConstraint.activate([
            questOneButton.topAnchor.constraint(equalTo: secondView.topAnchor, constant: 32),
            questOneButton.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            questOneButton.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            questOneButton.heightAnchor.constraint(equalToConstant: 66),
        ])
       
        NSLayoutConstraint.activate([
            questTwoButton.topAnchor.constraint(equalTo: questOneButton.bottomAnchor, constant: 16),
            questTwoButton.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            questTwoButton.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            questTwoButton.heightAnchor.constraint(equalToConstant: 66),
        ])
        
        NSLayoutConstraint.activate([
            questThreeButton.topAnchor.constraint(equalTo: questTwoButton.bottomAnchor, constant: 16),
            questThreeButton.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: 16),
            questThreeButton.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: -16),
            questThreeButton.heightAnchor.constraint(equalToConstant: 66),
        ])
        
        NSLayoutConstraint.activate([
            prizeButton.topAnchor.constraint(equalTo: questThreeButton.bottomAnchor, constant: 32),
            prizeButton.centerXAnchor.constraint(equalTo: secondView.centerXAnchor),
            prizeButton.widthAnchor.constraint(equalToConstant: 128),
            prizeButton.heightAnchor.constraint(equalToConstant: 128),
        ])
    }
    
    func configureButton(_ button: UIButton, _ text: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        button.setButtonCornerRadius(8)
        button.backgroundColor = Colors.blue
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
