//
//  Player.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 20.07.2022.
//

import UIKit
import AVFoundation
import Combine

class Player {
    
     private var player: AVPlayer?
     var playerLayer: AVPlayerLayer?
     private let notificationCenter = NotificationCenter.default
     private var appEventSubscribers = [AnyCancellable]()
     var playerMP3: AVAudioPlayer!
     static let synth = AVSpeechSynthesizer()
    
    func playSound(_ selectedSpeed: Double, _ word: String){
        let u = AVSpeechUtterance(string: word)
        u.voice = AVSpeechSynthesisVoice(language: "en-US")
        u.rate = Float(selectedSpeed)
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                             mode: .default, options: .mixWithOthers)
        Player.synth.speak(u)
    }
    
    func playMP3(_ soundName: String) {
        if UserDefaults.standard.integer(forKey: "playAppSound") == 0 {
            let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "mp3")
            playerMP3 = try! AVAudioPlayer(contentsOf: url!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                                mode: .default, options: .mixWithOthers)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
             print(error)
            }
            playerMP3.play()
        }
    }
    
    func buildPlayer(videoName: String) -> AVPlayer? {
        guard let filePath = Bundle.main.path(forResource: videoName, ofType: "mp4") else { return nil }
        let url = URL(fileURLWithPath: filePath)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.isMuted = true
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                             mode: .default, options: .mixWithOthers)
        return player
    }
    
    func buildPlayerLayer() -> AVPlayerLayer? {
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    func playVideo() {
        player?.play()
    }
    
    func restartVideo() {
        player?.seek(to: .zero)
        playVideo()
    }
    
    func pauseVideo() {
        player?.pause()
    }
    
    func setupPlayerIfNeeded(view: UIView, videoName: String) {
        player = buildPlayer(videoName: videoName)
        playerLayer = buildPlayerLayer()
        
        if let layer = self.playerLayer,
            view.layer.sublayers?.contains(layer) == false {
            view.layer.insertSublayer(layer, at: 0)
        }
    }
    
    func removePlayer() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    func observeAppEvents() {
        
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
    
    func removeAppEventsSubscribers() {
        appEventSubscribers.forEach { subscriber in
            subscriber.cancel()
        }
    }
    
}
