//
//  WordCell.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit

class WordCell: UITableViewCell {
    
    @IBOutlet weak var engView: UIView!
    @IBOutlet weak var engLabel: UILabel!
    
    @IBOutlet weak var trView: UIView!
    @IBOutlet weak var trLabel: UILabel!
    
    @IBOutlet weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateLabelTextSize(_ uilabel: UILabel, _ textSize: CGFloat){
        uilabel.font = uilabel.font.withSize(textSize)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.engView.layer.cornerRadius = 0
        self.trView.layer.cornerRadius = 0
    }
    
    func updateTopCornerRadius(_ number: CGFloat){
        self.engView.layer.cornerRadius = number
        self.engView.layer.maskedCorners = [.layerMinXMinYCorner]
        self.trView.layer.cornerRadius = number
        self.trView.layer.maskedCorners = [.layerMaxXMinYCorner]
        self.backgroundColor = .clear
    }
    
    func updateBottomCornerRadius(_ number: CGFloat){
        self.engView.layer.cornerRadius = number
        self.engView.layer.maskedCorners = [.layerMinXMaxYCorner]
        self.trView.layer.cornerRadius = number
        self.trView.layer.maskedCorners = [.layerMaxXMaxYCorner]
        self.backgroundColor = .clear
    }
}
