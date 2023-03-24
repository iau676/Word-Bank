//
//  NewPointViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 28.02.2022.
//

import UIKit
import AVFoundation
import Combine

class NewPointController: UIViewController {
    
    private let wordCountLabel = UILabel()
    private let wordsLabel = UILabel()
    private let newPointLabel = UILabel()
    private let continueButton = UIButton()
    
    private var textForLabel = ""
    private var userWordCount = ""
    private let player = Player()
    var newWordsCount = 0
    var newExercisePoint = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.observeAppEvents()
        player.setupPlayerIfNeeded(view: view, videoName: Videos.newpoint)
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
        
    //MARK: - Selectors
    
    @objc private func continueButtonPressed(_ sender: UIButton) {
        continueButton.bounce()
        continueButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helpers
    
    private func style() {
        wordCountLabel.text = "\(newWordsCount)"
        wordCountLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 70)
        wordCountLabel.textAlignment = .center
        wordCountLabel.numberOfLines = 0
        wordCountLabel.textColor = .darkGray
        
        wordsLabel.text = "Words!"
        wordsLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 21)
        wordsLabel.textAlignment = .center
        wordsLabel.numberOfLines = 0
        wordsLabel.textColor = .darkGray
        
        newPointLabel.text = "You will get \(newExercisePoint) points for each correct answer."
        newPointLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 21)
        newPointLabel.textAlignment = .center
        newPointLabel.numberOfLines = 0
        newPointLabel.textColor = .darkGray
        
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font =  UIFont(name: Fonts.ArialRoundedMTBold, size: 23)
        continueButton.layer.shadowColor = Colors.darkGrayShadow?.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.setButtonCornerRadius(16)
        continueButton.layer.masksToBounds = false
        continueButton.changeBackgroundColor(to: .darkGray)
        continueButton.setTitleColor(Colors.cellRight, for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonPressed(_:)), for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(wordCountLabel)
        view.addSubview(wordsLabel)
        view.addSubview(newPointLabel)
        view.addSubview(continueButton)
        
        wordCountLabel.centerX(inView: view)
        wordCountLabel.anchor(top: view.topAnchor, paddingTop: 66)
        
        wordsLabel.centerX(inView: view)
        wordsLabel.anchor(top: wordCountLabel.bottomAnchor)
        
        newPointLabel.anchor(top: wordsLabel.bottomAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 32,
                             paddingLeft: 32, paddingRight: 32)
        
        continueButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                              right: view.rightAnchor, paddingLeft: 32,
                              paddingBottom: 66, paddingRight: 32)
    }
}
