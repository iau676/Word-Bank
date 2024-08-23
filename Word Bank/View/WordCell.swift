//
//  WordCell.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit

class WordCell: UITableViewCell {
    
    let engView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellLeft
        return view
    }()
    
    let meaningView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellRight
        return view
    }()
    
    let engLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.AvenirNextRegular15
        label.textColor = Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    let meaningLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.AvenirNextRegular15
        label.textColor = Colors.black
        label.numberOfLines = 0
        return label
    }()
    
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = Fonts.AvenirNextDemiBold11
        label.textColor = UIColor.white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stack = UIStackView(arrangedSubviews: [engView, meaningView])
        stack.axis = .horizontal
        stack.spacing = 0
        stack.distribution = .fillEqually
        
        addSubview(stack)
        stack.fillSuperview()
        
        engView.addSubview(engLabel)
        engLabel.anchor(top: engView.topAnchor, left: engView.leftAnchor,
                        bottom: engView.bottomAnchor, right: engView.rightAnchor,
                        paddingTop: 10, paddingLeft: 16, paddingBottom: 10, paddingRight: 10)
        
        meaningView.addSubview(meaningLabel)
        meaningLabel.anchor(top: meaningView.topAnchor, left: meaningView.leftAnchor,
                            bottom: meaningView.bottomAnchor, right: meaningView.rightAnchor,
                            paddingTop: 10, paddingLeft: 16, paddingBottom: 10, paddingRight: 10)
        
        addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor,
                           paddingTop: 2, paddingLeft: 16)
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
