//
//  CGPoint+Extensions.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

extension CGPoint {

    mutating func add(vector: CGVector) {
        self.x += vector.dx
        self.y += vector.dy
    }

    func adding(vector: CGVector) -> CGPoint {
        var copy = self
        copy.add(vector: vector)
        return copy
    }

    mutating func multiply(by value: CGFloat) {
        self.x *= value
        self.y *= value
    }
}

