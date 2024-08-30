//
//  BubbleView.swift
//  Word Bank
//
//  Created by ibrahim uysal on 21.03.2023.
//

import UIKit

class BubbleView: UIView {
    
    //MARK: - Properties
    
    private var wordBrain = WordBrain()
    private var button = UIButton()
    private var label = UILabel()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = Fonts.ArialRoundedMTBold29
        
        addSubview(button)
        button.centerX(inView: self)
        button.centerY(inView: self)
        button.setDimensions(width: 90, height: 90)
        
        addSubview(label)
        label.centerY(inView: button)
        label.centerX(inView: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func update(answer isTrue: Bool, point: Int) {
        let trueImage = (UserDefault.selectedPointEffect.getInt() == 0) ? Images.greenBubble : Images.greenCircle
        let falseImage = (UserDefault.selectedPointEffect.getInt() == 0) ? Images.redBubble : Images.redCircle
        let image = isTrue ? trueImage :falseImage
        let textColor = isTrue ? Colors.green : Colors.red
        let text = isTrue ? "+\(point)" : "-\(point)"
        
        button.setImage(image, for: .normal)
        label.textColor = textColor
        label.text = text
    }
    
    func rotate() {
        UIView.animate(withDuration:0.2, animations: {
            self.button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            UIView.animate(withDuration:0.2, animations: {
                self.button.transform = .identity
            })
        }
    }
}
