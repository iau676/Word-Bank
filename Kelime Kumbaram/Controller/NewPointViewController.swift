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

    
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var levelLabel: UILabel!
        
    @IBOutlet weak var newPointLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    var textForLabel = ""
    var userWordCount = ""

    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let notificationCenter = NotificationCenter.default
    private var appEventSubscribers = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()

        levelLabel.text = userWordCount
        newPointLabel.text = textForLabel

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        observeAppEvents()
        setupPlayerIfNeeded()
        restartVideo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        removeAppEventsSubscribers()
        removePlayer()
    }
    
    @IBAction func continuePressed(_ sender: UIButton) {
        continueButton.pulstate()
        
        let when = DispatchTime.now() + 0.1
        
        if UserDefaults.standard.integer(forKey: "goLevelUp") == 1 {
            UserDefaults.standard.set(2, forKey: "goLevelUp")
            performSegue(withIdentifier: "goLevelUp", sender: self)

        } else {
            DispatchQueue.main.asyncAfter(deadline: when){
                self.dismiss(animated: true, completion: nil)
            }
        }
      
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupViews() {
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.layer.shadowColor = UIColor(red: 0.27, green: 0.27, blue: 0.27, alpha: 1.00).cgColor
        continueButton.layer.shadowOffset = CGSize(width: 0.0, height: 6.0)
        continueButton.layer.shadowOpacity = 1.0
        continueButton.layer.shadowRadius = 0.0
        continueButton.layer.masksToBounds = false
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        darkView.backgroundColor = UIColor(white: 0.1, alpha: 0)
    }
    
    private func buildPlayer() -> AVPlayer? {
        guard let filePath = Bundle.main.path(forResource: "dog", ofType: "mp4") else { return nil }
        let url = URL(fileURLWithPath: filePath)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.isMuted = true
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        return player
    }
    
    private func buildPlayerLayer() -> AVPlayerLayer? {
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    private func playVideo() {
        player?.play()
    }
    
    private func restartVideo() {
        player?.seek(to: .zero)
        playVideo()
    }
    
    private func pauseVideo() {
        player?.pause()
    }
    
    private func setupPlayerIfNeeded() {
        player = buildPlayer()
        playerLayer = buildPlayerLayer()
        
        if let layer = self.playerLayer,
            view.layer.sublayers?.contains(layer) == false {
            view.layer.insertSublayer(layer, at: 0)
        }
    }
    
    private func removePlayer() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    private func observeAppEvents() {
        
        notificationCenter.publisher(for: .AVPlayerItemDidPlayToEndTime).sink { [weak self] _ in
            self?.restartVideo()
        }.store(in: &appEventSubscribers)
        
        notificationCenter.publisher(for: UIApplication.willResignActiveNotification).sink { [weak self] _ in
            self?.pauseVideo()
        }.store(in: &appEventSubscribers)
        
        notificationCenter.publisher(for: UIApplication.didBecomeActiveNotification).sink { [weak self] _ in
            self?.playVideo()
        }.store(in: &appEventSubscribers)
    }
    
    private func removeAppEventsSubscribers() {
        appEventSubscribers.forEach { subscriber in
            subscriber.cancel()
        }
    }
    
}
