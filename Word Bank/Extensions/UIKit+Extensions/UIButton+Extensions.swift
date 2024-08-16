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
    
    func alignVertical(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
                    let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: 60, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
                    let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -titleSize.width)
                }
    }
    
    func setImage(image: UIImage?, width: CGFloat, height: CGFloat){
        self.setImage(UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }, for: .normal)
    }
    
    func setImageWithRenderingMode(image: UIImage?, width: CGFloat, height: CGFloat, color: UIColor){
        let image = image?.withRenderingMode(.alwaysTemplate).imageResized(to: CGSize(width: width, height: height)).withTintColor(color)
        self.setImage(image, for: .normal)
    }
    
    func updateShadowHeight(withDuration: CGFloat, height: CGFloat){
        UIView.animate(withDuration: withDuration) {
            self.layer.shadowOffset = CGSize(width: 0.0, height: height)
        }
    }
    
    func alignTextBelow(spacing: CGFloat = 2.0){
        if let image = self.imageView?.image{
            let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font ?? 15])
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
    
    func configureForTabBar(image: UIImage?, title: String, titleColor: UIColor, imageWidth: CGFloat, imageHeight: CGFloat){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        self.setTitleColor(titleColor, for: .normal)
        self.setImageWithRenderingMode(image: image, width: imageWidth, height: imageHeight, color: titleColor)
        self.alignTextBelow()
    }
    
    func moveImageTitleLeft() {
        let imageSize: CGSize = self.imageView?.image?.size ?? CGSize(width: 25, height: 25)
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageSize.width, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
    func moveImageRight(){
        let _: CGSize = self.imageView?.image?.size ?? CGSize(width: 25, height: 25)
        let buttonWidth = self.bounds.width
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-32, bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
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
