//
//  TaskView.swift
//  Word Bank
//
//  Created by ibrahim uysal on 17.08.2024.
//

import UIKit

class TaskView: UIView {
    
    private let exerciseCount: Int
    
    private lazy var taskButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.imagePadding = 8
        config.imagePlacement = .leading
        config.baseBackgroundColor = .clear
        button.configuration = config
        button.isUserInteractionEnabled = false
        button.tintColor = UIColor.white
        return button
    }()
    
    private let ravenLayerButton: UIButton = {
       let button = UIButton()
        button.setButtonCornerRadius(10)
        button.backgroundColor = Colors.raven
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let blueLayerButton: UIButton = {
       let button = UIButton()
        button.setHeight(60)
        button.setButtonCornerRadius(10)
        button.backgroundColor = Colors.blue
        button.isUserInteractionEnabled = false
        return button
    }()
    
    init(title: String, exerciseCount: Int) {
        self.exerciseCount = exerciseCount
        super.init(frame: .zero)
        
        taskButton.configurationUpdateHandler = { button in
            button.configuration?.attributedTitle = AttributedString(title, attributes: AttributeContainer([NSAttributedString.Key.font : Fonts.AvenirNextDemiBold15!]))
        }
        
        addSubview(ravenLayerButton)
        ravenLayerButton.fillSuperview()
        
        addSubview(blueLayerButton)
        
        addSubview(taskButton)
        taskButton.anchor(left: ravenLayerButton.leftAnchor)
        taskButton.centerY(inView: ravenLayerButton)
        
        let image = exerciseCount >= 10 ? Images.check : Images.whiteCircle
        taskButton.setImageWithRenderingMode(image: image, width: 25, height: 25, color: .white)
    }
    
    override func layoutSubviews() {
        let width = self.bounds.width
        let blueLayerWidth = (width/10)*CGFloat(exerciseCount)
        blueLayerButton.setWidth(blueLayerWidth)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
