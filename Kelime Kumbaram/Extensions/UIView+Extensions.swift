//
//  UIView+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 19.07.2022.
//

import UIKit

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setViewCornerRadius(_ number: Int) {
        self.layer.cornerRadius = CGFloat(number)
    }
    
    func updateViewVisibility(_ bool: Bool){
        UIView.transition(with: self, duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.isHidden = bool
                      })
    }
    
 }
