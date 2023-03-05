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
    
    func bounce() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut, .allowUserInteraction]) { [weak self] in
            self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut, .allowUserInteraction]) { [weak self] in
                self?.transform = CGAffineTransform.identity
            } completion: { _ in
                
            }
        }
    }
    
    func flip(duration: Double = 0.5, deadline: Double = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            UIView.transition(with: self,
                              duration: duration,
                              options: .transitionFlipFromLeft,
                              animations: nil,
                              completion: nil)
        }
    }
 }
