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

    @objc func goExercise(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int {
            UserDefault.startPressed.set(index)
            let when = DispatchTime.now() + 0.7
            DispatchQueue.main.asyncAfter(deadline: when){
                if index == 4 {
                    let controller = CardViewController(exerciseType: ExerciseType.normal,
                                                        exerciseFormat: ExerciseFormat.card)
                    controller.wheelPressed = 1
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    let vc = ExerciseViewController()
                    vc.wheelPressed = 1
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func goHome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goExercise" {
            let destinationVC = segue.destination as! ExerciseViewController
            destinationVC.wheelPressed = 1
        }
        
        if segue.identifier == "goCard" {
            let destinationVC = segue.destination as! CardViewController
            destinationVC.wheelPressed = 1
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
