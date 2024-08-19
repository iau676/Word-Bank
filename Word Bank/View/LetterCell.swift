//
//  LetterCell.swift
//  Word Bank
//
//  Created by ibrahim uysal on 20.12.2022.
//

import UIKit

//MARK: - LetterCell

class LetterCell: UICollectionViewCell {
    
    var letter: String? {
        didSet {
            configure()
        }
    }
    
    private let letterLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 19)
        label.textColor = Colors.black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = Colors.f6f6f6
        contentView.setViewCornerRadius(8)
     
        contentView.addSubview(letterLabel)
        
        NSLayoutConstraint.activate([
            letterLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            letterLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        guard let letter = letter else { return }
        letterLabel.text = letter
    }
}
