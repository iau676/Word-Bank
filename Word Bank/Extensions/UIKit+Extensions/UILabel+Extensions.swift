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
}
