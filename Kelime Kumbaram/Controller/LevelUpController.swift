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
    
    //MARK: - IBOutlet

    var wordBrain = WordBrain()
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Variables
    
    let player = Player()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDarkView()
        setupContinueButton()
        levelLabel.text = UserDefault.level.getString()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        player.observeAppEvents()
        player.setupPlayerIfNeeded(view: view, videoName: "levelup")
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
    
    //MARK: - IBAction
    
    @IBAction func continuePressed(_ sender: UIButton) {
        continueButton.pulstate()
        dismissView()
    }
    
    //MARK: - Other Functions
    
    func dismissView(){
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    private func setupDarkView(){
        darkView.backgroundColor = Colors.darkBackground
    }
    
    private func setupContinueButton(){
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.layer.shadowColor = Colors.darkGrayShadow?.cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.layer.masksToBounds = false
    }
}

