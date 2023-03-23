//
//  ClassicFireworkController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public class ClassicFireworkController {

    public init() {}

    public var sparkAnimator: SparkViewAnimator {
        return ClassicFireworkAnimator()
    }

    public func createFirework(at origin: CGPoint, sparkSize: CGSize, scale: CGFloat) -> Firework {
        return ClassicFirework(origin: origin, sparkSize: sparkSize, scale: scale)
    }

    /// It allows fireworks to explodes in close range of corners of a source view
    public func addFireworks(count fireworksCount: Int = 1,
                      sparks sparksCount: Int = 8,
                      around sourceButton: UIButton,
                      sparkSize: CGSize = CGSize(width: 6, height: 6),
                      scale: CGFloat = 100.0,
                      maxVectorChange: CGFloat = 5.0,
                      animationDuration: TimeInterval = 0.7,
                      canChangeZIndex: Bool = true) {
        guard let superview = sourceButton.superview else { fatalError() }

        let origins = [
            CGPoint(x: sourceButton.center.x, y: sourceButton.center.y-8),
            CGPoint(x: sourceButton.center.x, y: sourceButton.center.y-8),
            CGPoint(x: sourceButton.center.x, y: sourceButton.center.y-8),
        ]
        
        for _ in 0..<fireworksCount {
            let idx = Int(arc4random_uniform(UInt32(origins.count)))
            let origin = origins[idx].adding(vector: self.randomChangeVector(max: maxVectorChange))

            let firework = self.createFirework(at: origin, sparkSize: sparkSize, scale: scale)

            for sparkIndex in 0..<sparksCount {
                let spark = firework.spark(at: sparkIndex)
                spark.sparkView.isHidden = true
                superview.addSubview(spark.sparkView)

                if canChangeZIndex {
                    let zIndexChange: CGFloat = arc4random_uniform(2) == 0 ? -1 : +1
                    spark.sparkView.layer.zPosition = sourceButton.layer.zPosition + zIndexChange
                } else {
                    spark.sparkView.layer.zPosition = sourceButton.layer.zPosition
                }

                self.sparkAnimator.animate(spark: spark, duration: animationDuration)
            }
        }
    }

    private func randomChangeVector(max: CGFloat) -> CGVector {
        return CGVector(dx: self.randomChange(max: max), dy: self.randomChange(max: max))
    }

    private func randomChange(max: CGFloat) -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(max))) - (max / 2.0)
    }
}

