//
//  NewPointViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 28.02.2022.
//

import UIKit
import AVFoundation
import Combine

class NewPointViewController: UIViewController {
    
    let wordCountLabel = UILabel()
    let wordsLabel = UILabel()
    let newPointLabel = UILabel()
    let continueButton = UIButton()
    
    var textForLabel = ""
    var userWordCount = ""
    let player = Player()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configureColor()
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
        wordCountLabel.textColor = .darkGray
        wordsLabel.textColor = .darkGray
        newPointLabel.textColor = .darkGray
        continueButton.changeBackgroundColor(to: .darkGray)
        continueButton.setTitleColor(Colors.cellRight, for: .normal)
    }
}

extension NewPointViewController {
    
    func style() {
        wordCountLabel.translatesAutoresizingMaskIntoConstraints = false
        wordCountLabel.text = String(UserDefault.exercisePoint.getInt())
        wordCountLabel.font = UIFont(name: "ArialRoundedMTBold", size: 70)
        wordCountLabel.textAlignment = .center
        wordCountLabel.numberOfLines = 0
        
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsLabel.text = "Words!"
        wordsLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        wordsLabel.textAlignment = .center
        wordsLabel.numberOfLines = 0
        
        newPointLabel.translatesAutoresizingMaskIntoConstraints = false
        newPointLabel.text = "You will get +\(UserDefault.exercisePoint.getInt()-10) points for each correct answer."
        newPointLabel.font = UIFont(name: "ArialRoundedMTBold", size: 17)
        newPointLabel.textAlignment = .center
        newPointLabel.numberOfLines = 0
        
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
        view.addSubview(wordCountLabel)
        view.addSubview(wordsLabel)
        view.addSubview(newPointLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            wordCountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 66),
            wordCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            wordsLabel.topAnchor.constraint(equalTo: wordCountLabel.bottomAnchor, constant: 0),
            wordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            newPointLabel.topAnchor.constraint(equalTo: wordsLabel.bottomAnchor, constant: 32),
            newPointLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            newPointLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            continueButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -99),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}
