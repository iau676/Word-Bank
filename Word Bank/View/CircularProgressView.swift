//
//  CircularProgressView.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 30.01.2022.
//


import UIKit

class CircularProgressView: UIView {

    var progressLayer = CAShapeLayer()
    var trackLayer = CAShapeLayer()
    
    var progressColor: UIColor
    var trackColor: UIColor
    var bgColor: UIColor
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var button = UIButton()
    
    init(progressColor: UIColor, trackColor: UIColor, bgColor: UIColor) {
        self.progressColor = progressColor
        self.trackColor = trackColor
        self.bgColor = bgColor
        super.init(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
        createCircularPath()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = bgColor
        self.layer.cornerRadius = self.frame.size.width/2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLayer.path = circlePath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = 7.0
        trackLayer.strokeEnd = 1.0
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 7.0
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
        button.titleLabel?.font =  Fonts.ArialRoundedMTBold30
        addSubview(button)
        button.centerX(inView: self)
        button.centerY(inView: self)
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateprogress")
    }
    
}
