//
//  LevelUpController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 2.02.2022.
//

import UIKit
import AVFoundation
import Combine

class LevelUpViewController: UIViewController {
    
    let levelUpLabel = UILabel()
    let levelLabel = UILabel()
    let continueButton = UIButton()
    
    var wordBrain = WordBrain()
    let player = Player()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureColor()
        levelLabel.text = UserDefault.level.getString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.observeAppEvents()
        player.setupPlayerIfNeeded(view: view, videoName: Videos.levelup)
        player.restartVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        player.removeAppEventsSubscribers()
        player.removePlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        player.playerLayer?.frame = view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: - Selectors
    
    @objc func continueButtonPressed(_ sender: UIButton) {
        continueButton.bounce()
        continueButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
    
    func configureColor() {
        levelUpLabel.textColor = Colors.f6f6f6
        levelLabel.textColor = Colors.f6f6f6
        continueButton.changeBackgroundColor(to: .darkGray)
        continueButton.setTitleColor(Colors.f6f6f6, for: .normal)
    }
}

extension LevelUpViewController {
    func style() {
        levelUpLabel.text = "LEVEL UP"
        levelUpLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 17)
        levelUpLabel.textAlignment = .center
        levelUpLabel.numberOfLines = 1
        
        levelLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 70)
        levelLabel.textAlignment = .center
        levelLabel.numberOfLines = 1
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 23)
        continueButton.layer.shadowColor = Colors.darkGrayShadow?.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.setButtonCornerRadius(16)
        continueButton.layer.masksToBounds = false
        continueButton.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .primaryActionTriggered)
    }
    
    func layout() {
        view.addSubview(levelUpLabel)
        view.addSubview(levelLabel)
        view.addSubview(continueButton)
        
        levelUpLabel.centerX(inView: view)
        levelUpLabel.anchor(top: view.topAnchor, paddingTop: 66)
        
        levelLabel.centerX(inView: view)
        levelLabel.anchor(top: levelUpLabel.bottomAnchor)
        
        continueButton.setHeight(height: 45)
        continueButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor, paddingLeft: 32,
                              paddingBottom: 66, paddingRight: 32)
        
    }
}
