//
//  CircleColorSparkView.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public final class CircleColorSparkView: SparkView {

    public init(color: UIColor, size: CGSize) {
        super.init(frame: CGRect(origin: .zero, size: size))
        self.backgroundColor = color
        self.layer.cornerRadius = self.frame.width / 2.0
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UIColor {

    public static var sparkColorSet1: [UIColor] = {
        return [
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.pink,
            Colors.purple,
        ]
    }()
}

