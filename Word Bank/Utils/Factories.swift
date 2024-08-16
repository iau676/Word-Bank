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

func makeTestAnswerButton() -> UIButton {
    let button = UIButton()
     button.titleLabel?.font =  button.titleLabel?.font.withSize(UserDefault.textSize.getCGFloat())
     button.titleLabel?.numberOfLines = 3
     button.titleEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)

     button.backgroundColor = .clear
     button.layer.cornerRadius = 18
     button.layer.borderWidth = 5
     button.layer.borderColor = Colors.testAnswerLayer?.cgColor
     return button
}

func makeListeningAnswerButton() -> UIButton {
    let button = UIButton()
     button.setImage(Images.sound?.imageResized(to: CGSize(width: 50, height: 50)), for: .normal)
     button.backgroundColor = .clear
     button.layer.borderWidth = 5
     button.layer.borderColor = Colors.testAnswerLayer?.cgColor
     button.setDimensions(width: 90, height: 90)
     button.setButtonCornerRadius(90 / 2)
     button.titleLabel?.font = UIFont.systemFont(ofSize: 0)
     return button
}

//MARK: - View

func makeLineView() -> UIView {
    let view = UIView()
    view.backgroundColor = .darkGray
    view.setWidth(1)
    return view
}
