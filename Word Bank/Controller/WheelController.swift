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
        NotificationCenter.default.addObserver(self, selector: #selector(goExercise(_:)),
                                               name: Notification.Name(rawValue: "presentExercise"),
                                               object: nil)
        
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

    @objc private func goExercise(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.7){
                self.goExercise(index: index)
            }
        }
    }
    
    private func goExercise(index: Int) {
        var controller = UIViewController()
        switch index {
        case 1:
            controller = TestController(exerciseKind: .normal)
        case 2:
            controller = WritingController(exerciseKind: .normal)
        case 3:
            controller = ListeningController(exerciseKind: .normal)
        case 4:
            controller = CardController()
        default: break
        }
        self.navigationController?.pushViewController(controller, animated: true)
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
