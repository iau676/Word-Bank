//
//  ExerciseTopView.swift
//  Word Bank
//
//  Created by ibrahim uysal on 12.03.2023.
//

import UIKit

protocol ExerciseTopDelegate: AnyObject {
    func soundHintButtonPressed()
}

class ExerciseTopView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: ExerciseTopDelegate?
    
    lazy var userPointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Colors.raven, for: .normal)
        button.changeBackgroundColor(to: Colors.f6f6f6)
        button.titleLabel?.font =  button.titleLabel?.font.withSize(15)
        button.setTitle(String(UserDefault.lastPoint.getInt().withCommas()), for: .normal)
        return button
    }()
    
    private lazy var xButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.f6f6f6
        button.setTitle("2x", for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 17)
        button.changeBackgroundColor(to: Colors.pink)
        return button
    }()
    
    let progressBar: UIProgressView = {
       let progress = UIProgressView()
        progress.tintColor = Colors.f6f6f6
        return progress
    }()
    
    private lazy var soundHintButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.f6f6f6
        button.addTarget(self, action: #selector(soundHintButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
        
    init(exerciseFormat: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 11, height: 11))
        
        WordBrain.shared.questionCounter = 0
        
        switch exerciseFormat {
        case ExerciseFormat.test:
            if UserDefault.selectedTestType.getInt() == 0 {
                soundHintButton.setImage(image: Images.soundLeft, width: 40, height: 40)
            }
        case ExerciseFormat.writing: soundHintButton.setImage(image: Images.magic, width: 32, height: 32)
        default: break
        }
        
        addSubview(userPointButton)
        userPointButton.setHeight(24)
        userPointButton.setButtonCornerRadius(24 / 2)
        userPointButton.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                               paddingLeft: 32, paddingRight: 32)
        
        addSubview(xButton)
        xButton.setDimensions(width: 32, height: 32)
        xButton.setButtonCornerRadius(32 / 2)
        xButton.centerY(inView: userPointButton, leftAnchor: userPointButton.leftAnchor)
        
        addSubview(progressBar)
        progressBar.anchor(top: userPointButton.bottomAnchor, left: leftAnchor, right: rightAnchor,
                           paddingTop: 8, paddingLeft: 40, paddingRight: 40)
        
        addSubview(soundHintButton)
        soundHintButton.setDimensions(width: 40, height: 40)
        soundHintButton.anchor(top: userPointButton.bottomAnchor, right: rightAnchor,
                               paddingTop: 16, paddingRight: 32)
        
        setHeight(24+16+40)

        xButton.isHidden = !(UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt())
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: - Selectors
    
    @objc func soundHintButtonPressed() {
        soundHintButton.bounce()
        delegate?.soundHintButtonPressed()
    }
    
    //MARK: - Helpers
    
    func updateProgress() {
        progressBar.progress = WordBrain.shared.getProgress()
    }
    
    func updatePoint(lastPoint: Int, exercisePoint: Int, isIncrease: Bool) {
        if isIncrease {
            userPointButton.setTitleWithAnimation(title: (lastPoint+exercisePoint).withCommas())
            UserDefault.lastPoint.set(lastPoint+exercisePoint)
        } else {
            userPointButton.setTitleWithAnimation(title: (lastPoint-exercisePoint).withCommas())
            UserDefault.lastPoint.set(lastPoint-exercisePoint)
        }
    }
}
