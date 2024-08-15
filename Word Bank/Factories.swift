//
//  Factories.swift
//  Word Bank
//
//  Created by ibrahim uysal on 15.08.2024.
//

import UIKit

//MARK: - Button

func makeMenuButton(title: String, image: UIImage? = nil) -> UIButton {
    let button = UIButton()
    button.setTitleColor(.darkGray, for: .normal)
    button.setButtonCornerRadius(10)
    button.configureForTabBar(image: image, title: title, titleColor: .black, imageWidth: 30, imageHeight: 30)
    button.setDimensions(width: 100, height: 100)
    return button
}
