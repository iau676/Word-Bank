//
//  WheelViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 13.10.2022.
//

import UIKit
import SpriteKit
import GameplayKit

final class WheelController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goHome),
                                               name: Notification.Name(rawValue: "goHome"),
                                               object: nil)
        self.view = SKView()
        let vieW = self.view as! SKView?
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        vieW?.presentScene(scene!, transition: SKTransition.flipHorizontal(withDuration: 0.42))
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
    
    @objc private func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension WheelController {
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
