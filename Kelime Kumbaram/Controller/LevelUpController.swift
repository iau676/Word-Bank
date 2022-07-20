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

    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    //MARK: - Variables
    
    let player = Player()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        levelLabel.text = UserDefaults.standard.string(forKey: "level")
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
        let when = DispatchTime.now() + 0.1
        if UserDefaults.standard.integer(forKey: "goLevelUp") == 2 {
            UserDefaults.standard.set(0, forKey: "goLevelUp")
            DispatchQueue.main.asyncAfter(deadline: when){
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: when){
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: - Other Functions
    
    private func setupViews() {
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.layer.masksToBounds = false
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        darkView.backgroundColor = UIColor(white: 0.1, alpha: 0)
    }
}

