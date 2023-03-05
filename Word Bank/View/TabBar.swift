//
//  TabBar.swift
//  Word Bank
//
//  Created by ibrahim uysal on 5.03.2023.
//

import UIKit

protocol TabBarDelegate: AnyObject {
    func homePressed()
    func dailyPressed()
    func awardPressed()
    func statisticPressed()
    func settingPressed()
}

class TabBar: UIView {
    
    //MARK: - Properties
    
    weak var delegate: TabBarDelegate?
    
    private let fireworkController = ClassicFireworkController()
    private var wordBrain = WordBrain()
    private let homeButton = UIButton()
    private let dailyButton = UIButton()
    private let awardButton = UIButton()
    private let statisticButton = UIButton()
    private let settingsButton = UIButton()
    
    //MARK: - Life Cycle
    
    init(color1: UIColor = .darkGray, color2: UIColor = .darkGray,
         color3: UIColor = .darkGray, color4: UIColor = .darkGray,
         color5: UIColor = .darkGray) {
        super.init(frame: .zero)
        backgroundColor = .white

        configureButtons(color1: color1, color2: color2, color3: color3, color4: color4, color5: color5)

        let buttonStack = UIStackView(arrangedSubviews: [homeButton, dailyButton,
                                                         awardButton, statisticButton, settingsButton])
        buttonStack.spacing = 2
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        buttonStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func homeButtonPressed() {
        fireworkController.addFireworks(count: 5, sparks: 5, around: homeButton)
        delegate?.homePressed()
    }
    
    @objc func dailyButtonPressed() {
        fireworkController.addFireworks(count: 5, sparks: 5, around: dailyButton)
        delegate?.dailyPressed()
    }
    
    @objc func awardButtonPressed() {
        fireworkController.addFireworks(count: 5, sparks: 5, around: awardButton)
        delegate?.awardPressed()
    }
    
    @objc func statisticButtonPressed() {
        fireworkController.addFireworks(count: 5, sparks: 5, around: statisticButton)
        delegate?.statisticPressed()
    }
    
    @objc func settingsButtonPressed() {
        fireworkController.addFireworks(count: 5, sparks: 5, around: settingsButton)
        delegate?.settingPressed()
    }
    
    //MARK: - Helpers
    
    private func configureButtons(color1: UIColor, color2: UIColor,
                                  color3: UIColor, color4: UIColor,
                                  color5: UIColor) {
        
        homeButton.configureForTabBar(image: Images.home,
                                      title: "Home", titleColor: color1,
                                      imageWidth: 25, imageHeight: 25)
        
        dailyButton.configureForTabBar(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()],
                                       title: "Daily", titleColor: color2,
                                       imageWidth: 26, imageHeight: 26)
        
        awardButton.configureForTabBar(image: Images.award,
                                       title: "Awards", titleColor: color3,
                                       imageWidth: 27, imageHeight: 27)
        
        statisticButton.configureForTabBar(image: Images.statistic,
                                           title: "Statistics", titleColor: color4,
                                           imageWidth: 25, imageHeight: 25)
        
        settingsButton.configureForTabBar(image: Images.settings,
                                          title: "Settings", titleColor: color5,
                                          imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
        statisticButton.addTarget(self, action: #selector(statisticButtonPressed), for: .primaryActionTriggered)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
    }

}
