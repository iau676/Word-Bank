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
        label.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 29)
        
        addSubview(button)
        button.centerX(inView: self)
        button.centerY(inView: self)
        button.setDimensions(height: 90, width: 90)
        
        addSubview(label)
        label.centerY(inView: button)
        label.centerX(inView: button)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func update(answer isTrue: Bool, point: Int) {
        let image = isTrue ? wordBrain.getTruePointImage() : wordBrain.getFalsePointImage()
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
