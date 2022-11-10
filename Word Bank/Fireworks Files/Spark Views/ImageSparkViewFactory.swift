//
//  ImageSparkViewFactory.swift
//  Word Bank
//
//  Created by ibrahim uysal on 10.11.2022.
//

import UIKit

public struct ImageSparkViewFactoryData: SparkViewFactoryData {

    public let image: UIImage
    public let size: CGSize
    public let index: Int
}

public struct ImageSparkViewFactory: SparkViewFactory {

    public func create(with data: SparkViewFactoryData) -> SparkView {
        guard let data = data as? ImageSparkViewFactoryData else {
            fatalError("Wrong data.")
        }

        return ImageSparkView(image: data.image, size: data.size)
    }
}

