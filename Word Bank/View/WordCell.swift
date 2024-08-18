//
//  WordCell.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit

class WordCell: UITableViewCell {
    
    let engView = UIView()
    let meaningView = UIView()
    
    let engLabel = UILabel()
    let meaningLabel = UILabel()
    let numberLabel = UILabel()
    
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        engView.backgroundColor = Colors.cellLeft
        meaningView.backgroundColor = Colors.cellRight
        
        engView.setHeight(50)
        meaningView.setHeight(50)
        let stack = UIStackView(arrangedSubviews: [engView, meaningView])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.fillSuperview()
        
        engLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        meaningLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        numberLabel.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 11)
        
        engLabel.textColor = Colors.black
        meaningLabel.textColor = Colors.black
        numberLabel.textColor = .white
        
        engView.addSubview(engLabel)
        engLabel.anchor(top: engView.topAnchor, left: engView.leftAnchor,
                        bottom: engView.bottomAnchor, right: engView.rightAnchor,
                        paddingTop: 10, paddingLeft: 16, paddingBottom: 10, paddingRight: 10)
        
        meaningView.addSubview(meaningLabel)
        meaningLabel.anchor(top: meaningView.topAnchor, left: meaningView.leftAnchor,
                            bottom: meaningView.bottomAnchor, right: meaningView.rightAnchor,
                            paddingTop: 10, paddingLeft: 16, paddingBottom: 10, paddingRight: 10)
        
        addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 2, paddingLeft: 16)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateTopCornerRadius(_ number: CGFloat){
        self.engView.layer.cornerRadius = number
        self.engView.layer.maskedCorners = [.layerMinXMinYCorner]
        self.meaningView.layer.cornerRadius = number
        self.meaningView.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.backgroundColor = .clear
    }
    
    func updateBottomCornerRadius(_ number: CGFloat){
        self.engView.layer.cornerRadius = number
        self.engView.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.meaningView.layer.cornerRadius = number
        self.meaningView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        self.backgroundColor = .clear
    }
}
