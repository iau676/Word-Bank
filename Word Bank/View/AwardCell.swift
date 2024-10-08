//
//  AwardCell.swift
//  Word Bank
//
//  Created by ibrahim uysal on 20.12.2022.
//

import UIKit

//MARK: - AwardCell

class AwardCell: UICollectionViewCell {
    
    private let badgeCP = BadgeView(frame: CGRect(x: 10.0, y: 10.0, width: 60.0, height: 60.0))
    
    private let badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setViewCornerRadius(12)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.AvenirNextDemiBold19
        label.textColor = Colors.b9b9b9
        return label
    }()
    
    private let bannerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LEVEL"
        label.font = Fonts.AvenirNextDemiBold9
        label.textColor = .white
        return label
    }()
    
    private let bannerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.titleLabel?.font = Fonts.AvenirNextDemiBold15
        button.backgroundColor = .clear
        button.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        badgeCP.trackColor = Colors.d9d9d9
        badgeCP.progressColor = Colors.blue
        badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
        badgeCP.center = CGPoint(x: contentView.center.x+65, y: contentView.center.y+70)
        
        contentView.addSubview(badgeView)
        contentView.addSubview(badgeCP)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(bannerButton)
        contentView.addSubview(bannerLabel)
        
        NSLayoutConstraint.activate([
            badgeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            badgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: 120),
            badgeView.widthAnchor.constraint(equalToConstant: 120),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: badgeCP.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: badgeCP.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bannerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            bannerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 14.5),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(bannerText: String, titleText: String, cpValue: Float, color: UIColor) {
        bannerLabel.text = bannerText
        titleLabel.text = titleText
        badgeCP.setProgressWithAnimation(duration: 1.0, value: cpValue)
        bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: color)
        titleLabel.textColor = color
    }
}
