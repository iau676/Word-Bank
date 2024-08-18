//
//  Factories.swift
//  Word Bank
//
//  Created by ibrahim uysal on 15.08.2024.
//

import UIKit

//MARK: - Button

func makeMenuButton(title: String, image: UIImage? = nil, imageWidth: CGFloat = 30, imageHeight: CGFloat = 30) -> UIButton {
    let button = UIButton()
    button.setTitleColor(.darkGray, for: .normal)
    button.backgroundColor = .white
    button.setTitle(title, for: .normal)
    button.titleLabel?.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
    button.setTitleColor(.black, for: .normal)
    button.setImageWithRenderingMode(image: image, width: imageWidth, height: imageHeight, color: .black)
    button.alignTextBelow()
    button.setDimensions(width: 100, height: 100)
    button.setButtonCornerRadius(10)
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
     button.layer.borderColor = Colors.testAnswerLayer.cgColor
     return button
}

func makeListeningAnswerButton() -> UIButton {
    let button = UIButton()
     button.setImage(Images.sound?.imageResized(to: CGSize(width: 50, height: 50)), for: .normal)
     button.backgroundColor = .clear
     button.layer.borderWidth = 5
     button.layer.borderColor = Colors.testAnswerLayer.cgColor
     button.setDimensions(width: 90, height: 90)
     button.setButtonCornerRadius(90 / 2)
     button.titleLabel?.font = UIFont.systemFont(ofSize: 0)
     return button
}

func makeExerciseButton(image: UIImage?, imageWidth: CGFloat = 45, imageHeight: CGFloat = 30) -> UIButton {
    let button = UIButton()
    button.backgroundColor = Colors.raven
    button.setButtonCornerRadius(10)
    button.setImage(image: image, width: imageWidth, height: imageHeight)
    button.layer.shadowColor = Colors.ravenShadow.cgColor
    button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
    button.layer.shadowOpacity = 1.0
    button.layer.shadowRadius = 0.0
    button.layer.masksToBounds = false
    return button
}

//MARK: - View

func makeLineView() -> UIView {
    let view = UIView()
    view.backgroundColor = .darkGray
    view.setWidth(1)
    return view
}

//MARK: - TextField

func makeTextField(placeholder: String) -> UITextField {
    let tf = UITextField()
    tf.placeholder = placeholder
    tf.textColor = Colors.black
    tf.backgroundColor = Colors.cellRight
    tf.keyboardType = .asciiCapable
    tf.layer.cornerRadius = 8
    tf.setLeftPaddingPoints(10)
    tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    return tf
}

//MARK: - Label

func makeExerciseLabel(text: String) -> UILabel {
    let label = UILabel()
    label.textColor = Colors.black
    label.text = text
    label.textAlignment = .center
    label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
    label.numberOfLines = 1
    return label
}
