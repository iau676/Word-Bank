//
//  SettingsCell.swift
//  Word Bank
//
//  Created by ibrahim uysal on 24.03.2023.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 2
        contentView.setViewCornerRadius(8)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: UIImage?, borderColor: CGColor?) {
        imageView.image = image
        contentView.layer.borderColor = borderColor
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
    }
}
