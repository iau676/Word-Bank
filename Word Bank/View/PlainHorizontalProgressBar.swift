//
//  PlainHorizontalProgressBar.swift
//  Word Bank
//
//  Created by ibrahim uysal on 31.08.2024.
//

import UIKit

class PlainHorizontalProgressBar: UIView {
    
    var color: UIColor? = Colors.f6f6f6
    var progress: CGFloat = 0.0 {
        didSet { setNeedsDisplay() }
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor = .lightGray
        
        let backgroundMask = CAShapeLayer()
        backgroundMask.path = UIBezierPath(roundedRect: rect, cornerRadius: rect.height * 0.5).cgPath
        layer.mask = backgroundMask
        
        let progressRect = CGRect(origin: .zero, size: CGSize(width: rect.width * progress, height: rect.height))
        let progressLayer = CALayer()
        progressLayer.frame = progressRect
        
        layer.addSublayer(progressLayer)
        progressLayer.backgroundColor = color?.cgColor
    }
}
