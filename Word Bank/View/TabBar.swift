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
    
    private var wordBrain = WordBrain()
    private let homeButton = UIButton()
    private let dailyButton = UIButton()
    private let awardButton = UIButton()
    private let statisticButton = UIButton()
    private let settingsButton = UIButton()
    private var timer = Timer()
    
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
        delegate?.homePressed()
    }
    
    @objc func dailyButtonPressed() {
        delegate?.dailyPressed()
    }
    
    @objc func awardButtonPressed() {
        delegate?.awardPressed()
    }
    
    @objc func statisticButtonPressed() {
        delegate?.statisticPressed()
    }
    
    @objc func settingsButtonPressed() {
        delegate?.settingPressed()
    }
    
    //MARK: - Helpers
    
    private func configureButtons(color1: UIColor, color2: UIColor,
                                  color3: UIColor, color4: UIColor,
                                  color5: UIColor) {
        
        homeButton.configureForTabBar(image: Images.home,
                                      title: "Home", titleColor: color1,
                                      imageWidth: 26, imageHeight: 26)
        
        dailyButton.configureForTabBar(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()],
                                       title: "Daily", titleColor: color2,
                                       imageWidth: 26, imageHeight: 26)
        updateDailyButton(color2: color2)
        
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
    
    ///Update for daily icon ticks and 2x
    func updateDailyButton(color2: UIColor = .darkGray) {
        if wordBrain.getCurrentHour() == UserDefault.userSelectedHour.getInt() {
            dailyButton.setImage(image: Images.x2Tab, width: 26, height: 26)
        } else {
            dailyButton.setImage(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()]?.withTintColor(color2),width: 26, height: 26)
        }
    }
    
    func updateDailyButtonTitleColor() {
        if wordBrain.getCurrentHour() == UserDefault.userSelectedHour.getInt() {
            dailyButton.setTitleColor(Colors.pink, for: .normal)
        }
    }
}
