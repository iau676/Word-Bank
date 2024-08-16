//
//  SpinWheel.swift
//  SpinWheel
//
//  Created by Ron Myschuk on 2016-05-27.
//  Copyright © 2016 Orange Think Box. All rights reserved.
//  https://github.com/hsilived/SpinWheel

import UIKit
import SpriteKit

enum WheelState : Int {
    case stopped
    case ready
    case spinning
    case waiting
}

class SpinWheel: SKSpriteNode {
    
    //MARK: - Local variables
    
    var wordBrain = WordBrain()
    
    var wheel: SKSpriteNode!
    var flapper: SKSpriteNode!
    var pivotPin: SKSpriteNode!
    var springPin: SKSpriteNode!
    var backgroundBlocker: SKSpriteNode!
    
    var wheelState: WheelState = .waiting
    var slots = [[String]]()
    var images = [SKSpriteNode]()
    var tickSound: SKAction!
    var errorSound: SKAction!
    var wonSound: SKAction!
    var wooshSound: SKAction!
    var startPos: CGFloat = 0
    
    var wheelHub: PushButton!
    
    let pegCategory: UInt32 = 0x1 << 1
    let flapperCategory: UInt32 = 0x1 << 2
    
    init(size: CGSize) {
        super.init(texture: nil, color: .clear, size: size)
        name = "spinWheel"
        self.size = size
        isUserInteractionEnabled = true
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        setupSounds()
        
        let background = SKSpriteNode(color: Colors.purple, size: self.size)
        background.zPosition = -1
        addChild(background)
        
        slots = [
            ["", "wheel_prize_present", "", "0", "44"],
            ["", "wheel_prize_present", "", "45", "89"],
            ["", "wheel_prize_present", "", "90", "134"],
            ["", "wheel_prize_present", "", "135", "179"],
            ["", "wheel_prize_present", "", "180", "224"],
            ["", "wheel_prize_present", "", "225", "269"],
            ["", "wheel_prize_present", "", "270", "314"],
            ["", "wheel_prize_present", "", "315", "360"]
        ]

        createWheel()
        createFlapper()
    }
    
    func setupSounds() {
        if UserDefault.playAppSound.getInt() == 0 {
            tickSound = SKAction.playSoundFileNamed("bubble_pop.aac", waitForCompletion: false)
            errorSound = SKAction.playSoundFileNamed("error.aac", waitForCompletion: false)
            wonSound = SKAction.playSoundFileNamed("victory.aac", waitForCompletion: false)
            wooshSound = SKAction.playSoundFileNamed("woosh.aac", waitForCompletion: false)
        } else {
            tickSound = SKAction.playSoundFileNamed("silent.aac", waitForCompletion: false)
            errorSound = SKAction.playSoundFileNamed("silent.aac", waitForCompletion: false)
            wonSound = SKAction.playSoundFileNamed("silent.aac", waitForCompletion: false)
            wooshSound = SKAction.playSoundFileNamed("silent.aac", waitForCompletion: false)
        }
    }
    
    //MARK: - Create Prize Wheel Objects
    
    func createWheel() {
        wheel = SKSpriteNode(imageNamed: "wheel.png")
        wheel.position = CGPoint(x: 0, y: -110)
        wheel.name = "wheel"
        wheel.zPosition = 50
        
        let circleSize: CGFloat = 29
        let angleLength: CGFloat = cos(CGFloat.degreesToRadians(45)()) * (wheel.size.width / 2 - circleSize / 2)
        
        let circle1 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: 0, y: wheel.size.height / 2 - circleSize / 2))
        let circle2 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: (0 - wheel.size.width / 2) + circleSize / 2, y: 0))
        let circle3 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: wheel.size.width / 2 - circleSize / 2, y: 0))
        let circle4 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: 0, y: (0 - wheel.size.width / 2) + circleSize / 2))
        let circle5 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: angleLength, y: angleLength))
        let circle6 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: 0 - angleLength, y: 0 - angleLength))
        let circle7 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: angleLength, y: 0 - angleLength))
        let circle8 = SKPhysicsBody(circleOfRadius: circleSize / 2, center: CGPoint(x: 0 - angleLength, y: angleLength))
        let center = SKPhysicsBody(circleOfRadius: 40)
        
        wheel.physicsBody = SKPhysicsBody(bodies: [center, circle1, circle2, circle3, circle4, circle5, circle6, circle7, circle8])
        wheel.physicsBody!.categoryBitMask = pegCategory
        wheel.physicsBody!.collisionBitMask = flapperCategory
        wheel.physicsBody!.contactTestBitMask = flapperCategory
        wheel.physicsBody!.isDynamic = true
        wheel.physicsBody!.affectedByGravity = false
        wheel.physicsBody!.mass = 200
        addChild(wheel)
        
        wheelHub = PushButton(upImage: "wheel_hub", downImage: "wheel_hub")
        wheelHub.setButtonAction(target: self, event: .touchUpInside, function: spinWheel, parent: self)
        wheelHub.zPosition = 500
        wheelHub.position = wheel.position
        wheelHub.bounce = false
        wheelHub.physicsBody = SKPhysicsBody(circleOfRadius: wheelHub.size.width / 2)
        wheelHub.physicsBody!.isDynamic = false
        addChild(wheelHub)

        loadSlotImages()
        
        wheel.zRotation = CGFloat.degreesToRadians(22.25)()
    }
    
    func createFlapper() {
        pivotPin = SKSpriteNode(imageNamed: "flapperDot.png")
        pivotPin.name = "flapperDot"
        pivotPin.position = CGPoint(x: 0, y: wheel.position.y + wheel.size.height / 2 + 63)
        pivotPin.zPosition = 0
        pivotPin.physicsBody = SKPhysicsBody(circleOfRadius: pivotPin.size.width / 2)
        pivotPin.physicsBody!.isDynamic = false
        addChild(pivotPin)
        
        flapper = SKSpriteNode(imageNamed: "flapper.png")
        flapper.position = CGPoint(x: 0, y: wheel.position.y + wheel.size.height / 2 + flapper.size.height / 3 + 10)
        flapper.zPosition = 500
        flapper.name = "flapper"
        flapper.physicsBody = SKPhysicsBody(texture: flapper.texture!, size: flapper.texture!.size())
        flapper.physicsBody!.isDynamic = true
        flapper.physicsBody!.allowsRotation = true
        flapper.physicsBody!.affectedByGravity = false
        flapper.physicsBody!.friction = 100.0
        flapper.physicsBody!.categoryBitMask = flapperCategory
        flapper.physicsBody!.collisionBitMask = pegCategory
        flapper.physicsBody!.contactTestBitMask = pegCategory
        flapper.physicsBody!.usesPreciseCollisionDetection = true
        addChild(flapper)
        
        springPin = SKSpriteNode(imageNamed: "flapperDot.png")
        springPin.name = "flapperDot"
        springPin.position = CGPoint(x: 0, y: flapper.position.y - flapper.size.height / 2 + 30)
        springPin.zPosition = 0
        springPin.physicsBody = SKPhysicsBody(circleOfRadius: springPin.size.width / 2)
        springPin.physicsBody!.isDynamic = false
        springPin.physicsBody!.categoryBitMask = 0
        springPin.physicsBody!.collisionBitMask = 0
        springPin.physicsBody!.contactTestBitMask = 0
        addChild(springPin)
    }
    
    func initPhysicsJoints() {
        let wheelHubPositionConverted: CGPoint = self.convert(self.convert(self.wheelHub.position, from: self), to: self.scene!)
        self.scene?.physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: self.wheelHub.physicsBody!, bodyB: self.wheel.physicsBody!, anchor: wheelHubPositionConverted))

        let flapperPositionConverted: CGPoint = self.convert(self.convert(self.flapper.position, from: self), to: self.scene!)
        let springPinPositionConverted: CGPoint = self.convert(self.convert(self.springPin.position, from: self), to: self.scene!)
        let pivotPinPositionConverted: CGPoint = self.convert(self.convert(self.pivotPin.position, from: self), to: self.scene!)
        self.scene?.physicsWorld.add(SKPhysicsJointSpring.joint(withBodyA: springPin.physicsBody!, bodyB: flapper.physicsBody!, anchorA: CGPoint(x: flapperPositionConverted.x, y: flapperPositionConverted.y - flapper.size.height / 2), anchorB: springPinPositionConverted))
        self.scene?.physicsWorld.add(SKPhysicsJointPin.joint(withBodyA: flapper.physicsBody!, bodyB: pivotPin.physicsBody!, anchor: pivotPinPositionConverted))
    }
    
    func findImagePlacement(_ slot: Int, shortLength: CGFloat, longLength: CGFloat) -> CGPoint {
        switch slot {
            case 1:
                return CGPoint(x: shortLength, y: longLength)
            case 2:
                return CGPoint(x: longLength, y: shortLength)
            case 3:
                return CGPoint(x: longLength, y: -shortLength)
            case 4:
                return CGPoint(x: shortLength, y: -longLength)
            case 5:
                return CGPoint(x: -shortLength, y: -longLength)
            case 6:
                return CGPoint(x: -longLength, y: -shortLength)
            case 7:
                return CGPoint(x: -longLength, y: shortLength)
            case 8:
                return CGPoint(x: -shortLength, y: longLength)
            default:
                return CGPoint.zero
        }
    }
    
    func loadSlotImages() {
        let interval = CGFloat(360 / slots.count)
        let offset: CGFloat = interval / CGFloat(2)
        let length: CGFloat = wheel.size.width / 3 + 10
        let shortLength: CGFloat = sin(CGFloat.degreesToRadians(22.5)()) * length
        let longLength: CGFloat = cos(CGFloat.degreesToRadians(22.5)()) * length
        
        for x in 0..<slots.count {
            let degree: CGFloat = offset + (interval * CGFloat(x))
            let prizeImage: SKSpriteNode = SKSpriteNode(imageNamed: slots[x][1] )
            prizeImage.position = findImagePlacement(x + 1, shortLength: shortLength, longLength: longLength)
            prizeImage.zRotation = CGFloat.degreesToRadians(-degree)()
            prizeImage.name = "prize"
            prizeImage.zPosition = 500
            wheel.addChild(prizeImage)
            images.append(prizeImage)
        }
    }
    
    //MARK: - Game Loop
    
    func updateWheel(_ currentTime: TimeInterval) {
        if wheel.physicsBody!.isResting && wheelState == .spinning {
            wheelState = .stopped
            var degree = CGFloat.radiansToDegrees(wheel.zRotation)()
            
            if degree < 0 {
                degree = 360 + degree
            }
            
            for x in 0..<slots.count {
                if (degree >= CGFloat(Int(slots[x][3])!)) && (degree <= CGFloat(Int(slots[x][4])!)) {
                    print("You landed on \(slots[x][0]) slot and won \(slots[x][1])")
                    highlightWin(x)
                    break
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if let firstNode = contact.bodyA.node as? SKSpriteNode, let secondNode = contact.bodyB.node as? SKSpriteNode {
            let object1: String = firstNode.name!
            let object2: String = secondNode.name!
            
            if (object1 == "wheel") || (object2 == "wheel") {
                run(tickSound)
            }
        }
    }
    
    //MARK: - Wheel Turn functions
    
    func rotate(_ impulse: CGFloat) {
        wheel.zRotation = wheel.zRotation - CGFloat.degreesToRadians(impulse)()
    }
    
    func spinWheel() {
        if wheelState != .spinning {
            let spinPower = CGFloat.random(min: 400, max: 600)
            spin(spinPower)
            wheelState = .spinning
        }
    }
    
    func spin(_ impulse: CGFloat) {
        wheel.physicsBody!.applyAngularImpulse(-(impulse * 30.0))
        wheel.physicsBody!.angularDamping = 1
        let maxAngularVelocity: CGFloat = 100
        wheel.physicsBody!.angularVelocity = min(wheel.physicsBody!.angularVelocity, maxAngularVelocity)
        run(wooshSound)
    }
    
    //MARK: - Highlight win functions
    
    func highlightWin(_ index: Int) {
        let temp: SKSpriteNode = images[index]
        
        run(wonSound)
        
        createBackgroundBlocker(index)
        
        explodeImage(temp, duration: 1.5)
        
        wheel.run(SKAction.wait(forDuration: 0.5)) {
            self.explodeImage(temp, duration: 0.5)
        }
        
        let emitter = SKEmitterNode(fileNamed: "SparkleBlast")!
        emitter.position = temp.position
        emitter.particlePositionRange = CGVector(dx: temp.size.width * 2, dy: temp.size.height * 2)
        emitter.zPosition = 11
        wheel.addChild(emitter)
    }
    
    func explodeImage(_ image: SKSpriteNode, duration: TimeInterval) {
        let prizeImage: SKSpriteNode = image.copy() as! SKSpriteNode
        prizeImage.zPosition = 500
        let scale: SKAction = SKAction.scale(to: 4, duration: duration)
        let fade: SKAction = SKAction.fadeAlpha(to: 0.2, duration: duration)
        let group: SKAction = SKAction.group([scale, fade])
        wheel.addChild(prizeImage)
        
        prizeImage.run(group) {
            prizeImage.removeFromParent()
        }
    }
    
    func createBackgroundBlocker(_ winnningIndex: Int) {
        let prizePoint: Int = Level.shared.getPrizePoint()
        let prizeImage: String = slots[winnningIndex][1]
        
        backgroundBlocker = SKSpriteNode(color: UIColor(white: 0.2, alpha: 0.9), size: self.size)
        backgroundBlocker.zPosition = 1599
        backgroundBlocker.alpha = 0
        self.addChild(backgroundBlocker)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
        backgroundBlocker.run(fadeIn)
        
        userWillGetDailyPrize(prizePoint: prizePoint, prizeImage: prizeImage, winnningIndex: winnningIndex)
    }
    
    func userGotPrize(prizePoint: Int, prizeImage: String){
        let youWonLabel = SKLabelNode()
        youWonLabel.fontName = Fonts.AvenirNextBold
        youWonLabel.text = "YOU WON \(prizePoint.withCommas()) POINTS"
        youWonLabel.fontSize = 84.0
        youWonLabel.fontColor = SKColor(white: 0.9, alpha: 1.0)
        youWonLabel.position = CGPoint(x: 0, y: 0.15 * self.size.height / 2)
        youWonLabel.zPosition = 1600
        backgroundBlocker.addChild(youWonLabel)
        
        let lastPoint = UserDefault.lastPoint.getInt()
        UserDefault.lastPoint.set(lastPoint+prizePoint)
        
        let prize: SKSpriteNode = SKSpriteNode(imageNamed: prizeImage)
        prize.position = CGPoint(x: 0, y: 0)
        prize.zPosition = 5
        backgroundBlocker.addChild(prize)
        
        let continueButton: PushButton = PushButton(upImage: "button_continue_up", downImage: "button_continue_down")
        continueButton.setButtonAction(target: self, event: .touchUpInside, function: closeSpinWheel, parent: self)
        continueButton.position = CGPoint(x: 0, y: 0 - 0.35 * self.size.height / 2)
        continueButton.zPosition = 5
        backgroundBlocker.addChild(continueButton)
    }
    
    func userWillGetDailyPrize(prizePoint: Int, prizeImage: String, winnningIndex: Int){
        var newPrizePoint = Double(prizePoint)
        
        switch winnningIndex {
        case 0:
            newPrizePoint *= 1
        case 1:
            newPrizePoint *= 1.1
        case 2:
            newPrizePoint *= 1.2
        case 3:
            newPrizePoint *= 1.3
        case 4:
            newPrizePoint *= 1.4
        case 5:
            newPrizePoint *= 1.5
        case 6:
            newPrizePoint *= 1.6
        case 7:
            newPrizePoint *= 1.7
        default:
            break
        }
        UserDefault.userGotDailyPrize.set(wordBrain.getTodayDate())
        userGotPrize(prizePoint: Int(newPrizePoint), prizeImage: prizeImage)
    }
    
    func closeSpinWheel() {
        if slots[1][1] == "wheel_prize_present"{
            NotificationCenter.default.post(name: Notification.Name(rawValue: "goHome"), object: nil, userInfo: nil)
        } else {
            slots[7][1] = "blueBackground"
            loadSlotImages()
            slots[7][1] = "cardExercise"
            loadSlotImages()
            backgroundBlocker.removeFromParent()
            spinWheel()
        }
    }
    
    func userWillGoExercise(_ winnningIndex: Int){
        var newIndex = 1
        
        switch winnningIndex {
        case 0:
            newIndex = 1
        case 1:
            newIndex = 2
        case 2:
            newIndex = 3
        case 3:
            newIndex = 4
        case 4:
            newIndex = 1
        case 5:
            newIndex = 2
        case 6:
            newIndex = 3
        case 7:
            newIndex = 4
        default:
            break
        }
        
        let index:[String: Int] = ["index": newIndex]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "presentExercise"), object: nil, userInfo: index)
    }
}
