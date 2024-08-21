//
//  UILabel+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 24.07.2022.
//

import UIKit

extension UILabel {
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        layer.add(flash, forKey: nil)
    }
    
    func flash(withColor color1: UIColor?, originalColor color2: UIColor?) {
        self.flash()
        self.textColor = color1
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.8) {
            self.textColor = color2
        }
    }
    
    func setAttributedText(verb: String, count: Int, noun: String) {
        if let avenirRegular = UIFont(name: Fonts.AvenirNextRegular, size: 15),
           let avenirDemiBold = UIFont(name: Fonts.AvenirNextDemiBold, size: 15) {
            
            let avenirRegularAttrs = [NSAttributedString.Key.font : avenirRegular]
            let avenirDemiBoldAttrs = [NSAttributedString.Key.font : avenirDemiBold]
            
            let text = "\(verb)"
            let string = NSMutableAttributedString(string:text, attributes: avenirRegularAttrs)
            
            let noun = count > 1 ? "\(noun)s" : noun
            let secondText = " \(count) \(noun) "
            let secondString = NSMutableAttributedString(string:secondText, attributes: avenirDemiBoldAttrs)
            
            let thirdText = "this week"
            let thirdString = NSMutableAttributedString(string:thirdText, attributes: avenirRegularAttrs)
            
            string.append(secondString)
            string.append(thirdString)
            
            self.attributedText = string
        }
    }
}
