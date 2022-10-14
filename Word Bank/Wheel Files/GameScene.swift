//
//  SpinWheel.swift
//  SpinWheel
//
//  Created by Ron Myschuk on 2016-05-27.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//  https://github.com/hsilived/SpinWheel

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var spinWheelOpen = true
    private var spinWheel: SpinWheel!
    
    override func didMove(to view: SKView) {
       setup()
    }
    
    func setup() {
        self.physicsWorld.contactDelegate = self
        self.displaySpinWheel()
    }
    
    func displaySpinWheel() {
        spinWheel = SpinWheel(size: self.size)
        spinWheel.zPosition = 500
        addChild(spinWheel)
        spinWheel.initPhysicsJoints()
        spinWheelOpen = true
        spinWheel.spinWheel()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if spinWheelOpen {
            spinWheel.didBegin(contact)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        if spinWheelOpen {
            spinWheel.updateWheel(currentTime)
        }
    }
}
