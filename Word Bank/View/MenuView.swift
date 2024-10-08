//
//  MenuView.swift
//  Word Bank
//
//  Created by ibrahim uysal on 15.08.2024.
//

import UIKit

protocol MenuViewDelegate {
    func close()
    func daily()
    func awards()
    func stats()
    func settings()
}

class MenuView: UIView {
    
    var delegate: MenuViewDelegate?
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(Colors.black, for: .normal)
        button.backgroundColor = Colors.cellRight
        button.setButtonCornerRadius(10)
        button.setHeight(50)
        button.titleLabel?.font = Fonts.AvenirNextRegular17
        button.addTarget(self, action: #selector(closeButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var dailyButton: UIButton = {
        let button = makeMenuButton(title: "Daily", image: Images.giftBox, imageWidth: 40, imageHeight: 40)
        button.addTarget(self, action: #selector(dailyButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var awardsButton: UIButton = {
        let button = makeMenuButton(title: "Awards", image: Images.award)
        button.addTarget(self, action: #selector(awardsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var statsButton: UIButton = {
        let button = makeMenuButton(title: "Statistics", image: Images.statistic)
        button.addTarget(self, action: #selector(statsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = makeMenuButton(title: "Settings", image: Images.settings)
        button.addTarget(self, action: #selector(settingsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = Colors.purple
        
        let topButtonStack = UIStackView(arrangedSubviews: [dailyButton, awardsButton])
        topButtonStack.axis = .horizontal
        topButtonStack.spacing = 16
        topButtonStack.distribution = .fillEqually
        
        let bottomButtonStack = UIStackView(arrangedSubviews: [statsButton, settingsButton])
        bottomButtonStack.axis = .horizontal
        bottomButtonStack.spacing = 16
        bottomButtonStack.distribution = .fillEqually
        
        let buttonStack = UIStackView(arrangedSubviews: [topButtonStack, bottomButtonStack, closeButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func closeButtonPressed() {
        delegate?.close()
    }
    
    @objc private func dailyButtonPressed() {
        dailyButton.bounce()
        delegate?.daily()
    }
    
    @objc private func awardsButtonPressed() {
        awardsButton.bounce()
        delegate?.awards()
    }
    
    @objc private func statsButtonPressed() {
        statsButton.bounce()
        delegate?.stats()
    }
    
    @objc private func settingsButtonPressed() {
        settingsButton.bounce()
        delegate?.settings()
    }
}
