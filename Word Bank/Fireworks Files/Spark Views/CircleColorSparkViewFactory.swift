//
//  CircleColorSparkViewFactory.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public class CircleColorSparkViewFactory: SparkViewFactory {

    public var colors: [UIColor] {
        return UIColor.sparkColorSet1
    }

    public func create(with data: SparkViewFactoryData) -> SparkView {
        let color = self.colors[data.index % self.colors.count]
        return CircleColorSparkView(color: color, size: data.size)
    }
}

