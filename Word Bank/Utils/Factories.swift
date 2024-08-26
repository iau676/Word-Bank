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
    button.backgroundColor = .white
    button.tintColor = Colors.black
    button.layer.cornerRadius = 10
    button.setImageWithRenderingMode(image: image, width: imageWidth, height: imageHeight, color: .black)
    button.setDimensions(width: 100, height: 100)
    
    var config = UIButton.Configuration.bordered()
    config.titlePadding = 5
    config.imagePadding = 5
    config.imagePlacement = .top
    config.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : Fonts.AvenirNextRegular15!]))
    button.configuration = config
    
    return button
}

func makeTestAnswerButton() -> UIButton {
    let button = UIButton()
     button.titleLabel?.font =  Fonts.AvenirNextRegular15
     button.titleLabel?.numberOfLines = 3
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

func makeBackgroundView(bgColor: UIColor) -> UIView {
    let view = UIView()
    view.backgroundColor = bgColor
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
    label.font = Fonts.AvenirNextRegular13
    label.numberOfLines = 1
    return label
}

func makeSettingLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = Colors.black
    label.font = Fonts.AvenirNextRegular15
    return label
}

func makeAwardLabel(text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = Fonts.AvenirNextRegular19
    label.textColor = Colors.black
    return label
}

func makePaddingLabel(text: String) -> UILabel {
    let label = UILabelPadding()
    label.numberOfLines = 0
    label.text = text
    label.textColor = UIColor.white
    label.backgroundColor = Colors.blue
    label.font = Fonts.AvenirNextDemiBold15
    label.layer.cornerRadius = 8
    label.layer.masksToBounds = true 
    return label
}

private class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}

//MARK: - UIContextualAction

func makeContextualAction(image: UIImage?, bgColor: UIColor, handler: @escaping UIContextualAction.Handler) -> UIContextualAction {
    let cAction = UIContextualAction(style: .normal, title: "", handler: handler)
    cAction.setImage(image: image, width: 25, height: 25)
    cAction.backgroundColor = bgColor
    return cAction
}

//MARK: - UICollectionView

func makeAwardCollectionView(withIdentifier: String) -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.backgroundColor = Colors.cellLeft
    cv.register(AwardCell.self, forCellWithReuseIdentifier: withIdentifier)
    cv.showsHorizontalScrollIndicator = false
    return cv
}

func makeSettingCollectionView(withIdentifier: String) -> UICollectionView {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.translatesAutoresizingMaskIntoConstraints = false
    cv.backgroundColor = Colors.cellRight
    cv.register(SettingsCell.self, forCellWithReuseIdentifier: withIdentifier)
    cv.showsHorizontalScrollIndicator = false
    return cv
}

//MARK: - UISwitch

func makeSwitch(isOn bool: Bool) -> UISwitch {
    let sw = UISwitch()
    sw.isOn = bool
    return sw
}

//MARK: - UISegmentedControl

func makeSegmentedControl(tintColor: UIColor, segments: [String]) -> UISegmentedControl {
    let sg = UISegmentedControl()
    sg.tintColor = tintColor
    sg.replaceSegments(segments: segments)
    sg.setTitleTextAttributes([.foregroundColor: Colors.black, .font: UIFont.systemFont(ofSize: 13),], for: .normal)
    return sg
}
