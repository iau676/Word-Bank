//
//  LevelUpController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 2.02.2022.
//

import UIKit
import AVFoundation
import Combine

class LevelUpController: UIViewController {
    
    private let levelUpLabel = UILabel()
    private let levelLabel = UILabel()
    private let continueButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        Player.shared.observeAppEvents()
        Player.shared.setupPlayerIfNeeded(view: view, videoName: Videos.levelup)
        Player.shared.restartVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        Player.shared.removeAppEventsSubscribers()
        Player.shared.removePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        Player.shared.playerLayer?.frame = view.bounds
    }
    
    //MARK: - Selectors
    
    @objc private func continueButtonPressed(_ sender: UIButton) {
        continueButton.bounce()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
    
    private func style() {
        levelUpLabel.text = "LEVEL UP"
        levelUpLabel.font = Fonts.ArialRoundedMTBold17
        levelUpLabel.textAlignment = .center
        levelUpLabel.numberOfLines = 1
        levelUpLabel.textColor = Colors.f6f6f6
        
        levelLabel.font = Fonts.ArialRoundedMTBold70
        levelLabel.textAlignment = .center
        levelLabel.numberOfLines = 1
        levelLabel.textColor = Colors.f6f6f6
        levelLabel.text = UserDefault.level.getString()
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font =  Fonts.ArialRoundedMTBold23
        continueButton.layer.shadowColor = Colors.darkGrayShadow.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.setButtonCornerRadius(16)
        continueButton.layer.masksToBounds = false
        continueButton.changeBackgroundColor(to: .darkGray)
        continueButton.setTitleColor(Colors.f6f6f6, for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(levelUpLabel)
        view.addSubview(levelLabel)
        view.addSubview(continueButton)
        
        levelUpLabel.centerX(inView: view)
        levelUpLabel.anchor(top: view.topAnchor, paddingTop: 66)
        
        levelLabel.centerX(inView: view)
        levelLabel.anchor(top: levelUpLabel.bottomAnchor)
        
        continueButton.setHeight(45)
        continueButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor, paddingLeft: 32,
                              paddingBottom: 66, paddingRight: 32)
    }
}
