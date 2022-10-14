//
//  WheelViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 13.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit

class WheelViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goExercise(_:)), name: Notification.Name(rawValue: "presentExercise"), object: nil)
        self.view = SKView()
        let vieW = self.view as! SKView?
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        vieW?.presentScene(scene!, transition: SKTransition.flipHorizontal(withDuration: 0.42))
    }
    
    @objc func goExercise(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int {
            UserDefault.startPressed.set(index)
            let when = DispatchTime.now() + 0.7
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goExercise", sender: self)
            }
        }
    }
}

extension WheelViewController {
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
