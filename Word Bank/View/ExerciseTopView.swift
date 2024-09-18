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
    
    private var plainHorizontalProgressBar = PlainHorizontalProgressBar()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 12
        view.setHeight(24)
        return view
    }()
    
    lazy var userPointButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(Colors.raven, for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font =  button.titleLabel?.font.withSize(15)
        button.setTitle(String(UserDefault.lastPoint.getInt().withCommas()), for: .normal)
        return button
    }()
    
    private lazy var soundHintButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Colors.f6f6f6
        button.addTarget(self, action: #selector(soundHintButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
        
    init(exerciseType: ExerciseType) {
        super.init(frame: CGRect(x: 0, y: 0, width: 11, height: 11))
        
        switch exerciseType {
        case .test:
            if UserDefault.selectedTestType.getInt() == 0 {
                soundHintButton.setImage(image: Images.soundLeft, width: 40, height: 40)
            }
        case .writing: soundHintButton.setImage(image: Images.magic, width: 32, height: 32)
        default: break
        }
        
        addSubview(emptyView)
        emptyView.setHeight(24)
        emptyView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        emptyView.addSubview(plainHorizontalProgressBar)
        plainHorizontalProgressBar.fillSuperview()

        addSubview(userPointButton)
        userPointButton.centerX(inView: plainHorizontalProgressBar)
        userPointButton.centerY(inView: plainHorizontalProgressBar)
        
        addSubview(soundHintButton)
        soundHintButton.setDimensions(width: 40, height: 40)
        soundHintButton.anchor(top: plainHorizontalProgressBar.bottomAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 32)
        
        setHeight(24+16+40)
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
    
    func updateProgress(questionCounter: Int) {
        plainHorizontalProgressBar.progress = CGFloat(questionCounter) / CGFloat(totalQuestionNumber)
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
