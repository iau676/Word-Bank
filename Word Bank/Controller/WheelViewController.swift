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
    
    var popToRootViewController = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(goExercise(_:)), name: Notification.Name(rawValue: "presentExercise"), object: nil)
        self.view = SKView()
        let vieW = self.view as! SKView?
        let scene = SKScene(fileNamed: "GameScene")
        scene?.scaleMode = .aspectFill
        vieW?.presentScene(scene!, transition: SKTransition.flipHorizontal(withDuration: 0.42))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if popToRootViewController == 1 {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    @objc func goExercise(_ notification: Notification) {
        if let index = notification.userInfo?["index"] as? Int {
            popToRootViewController = 1
            UserDefault.startPressed.set(index)
            let goView = (index == 4) ? "goCard" : "goExercise"
            let when = DispatchTime.now() + 0.7
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: goView, sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goExercise" {
            let destinationVC = segue.destination as! ExerciseViewController
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
