//
//  UIButton+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 20.07.2022.
//

import UIKit

extension UIButton {
    
    func deleteBackgroundImage(){
        self.setBackgroundImage(nil, for: .normal)
    }
    
    func changeBackgroundColor(to color: UIColor?){
        self.backgroundColor = color
    }
    
    func setButtonCornerRadius(_ number: Int){
        self.layer.cornerRadius = CGFloat(number)
    }
    
    func pulstate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.85
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 5
        pulse.initialVelocity = 0.5
        pulse.damping = 2.5
        layer.add(pulse, forKey: nil)
    }
    
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }

    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 2, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 2, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
    
    func animateCoinDown(y: CGFloat){
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: center.x , y: center.y)
        animation.toValue = CGPoint(x: center.x, y: y)
        animation.duration = 1
        animation.fillMode = .forwards
        layer.add(animation, forKey: nil)
    }
    
    func animateDropDown(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: center.x , y: center.y)
        animation.toValue = CGPoint(x: center.x, y:  center.y+120)
        animation.duration = 0.7
        animation.fillMode = .forwards
        layer.add(animation, forKey: nil)
    }
    
    func setTitleWithAnimation(title: String) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
          self.setTitle(title, for: .normal)
        }, completion: nil)
    }
    
    func setImage(image: UIImage?, width: CGFloat, height: CGFloat){
        self.setImage(UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }, for: .normal)
    }
    
    func setImageWithRenderingMode(image: UIImage?, width: CGFloat, height: CGFloat, color: UIColor){
        let image = image?.withRenderingMode(.alwaysTemplate).imageResized(to: CGSize(width: width, height: height)).withTintColor(color)
        self.setImage(image, for: .normal)
    }
    
    func rotate() {
        UIView.animate(withDuration:0.2, animations: {
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            UIView.animate(withDuration:0.2, animations: {
                self.transform = .identity
            })
        }
    }
}
