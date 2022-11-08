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
        levelUpLabel.translatesAutoresizingMaskIntoConstraints = false
        levelUpLabel.text = "LEVEL UP"
        levelUpLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        levelUpLabel.textAlignment = .center
        levelUpLabel.numberOfLines = 1
        
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.font = UIFont(name: "ArialRoundedMTBold", size: 70)
        levelLabel.textAlignment = .center
        levelLabel.numberOfLines = 1
        
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font =  UIFont(name: "ArialRoundedMTBold", size: 23)
        continueButton.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .primaryActionTriggered)
        continueButton.layer.shadowColor = Colors.darkGrayShadow?.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.setButtonCornerRadius(16)
        continueButton.layer.masksToBounds = false
    }
    
    func layout() {
        view.addSubview(levelUpLabel)
        view.addSubview(levelLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            levelUpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            levelUpLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: levelUpLabel.bottomAnchor, constant: 0),
            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            continueButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -99),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}
