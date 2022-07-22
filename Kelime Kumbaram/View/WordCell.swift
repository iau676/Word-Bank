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
    
}
