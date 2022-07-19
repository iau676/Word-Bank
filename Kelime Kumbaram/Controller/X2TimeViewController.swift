//
//  X2TimeViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 24.03.2022.
//

import UIKit

class X2TimeViewController: UIViewController {
    
    
    @IBOutlet weak var x2Label: UILabel!
    
    override func viewDidLoad() {
        x2Label.text = "2x puan saatindesiniz!\n\nHer doğru cevap için 2x puan kazanacaksınız.\n\nBu saati ayarlar sayfasından değiştirebilirsiniz."
        
        self.view.backgroundColor = UIColor(red: 0.99, green: 0.55, blue: 0.65, alpha: 1.00)
    }
    
    override func updateViewConstraints() {
                self.view.frame.size.height = UIScreen.main.bounds.height - (UIScreen.main.bounds.height/2-44)
                self.view.frame.origin.y =  UIScreen.main.bounds.height/2-44
                self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
                super.updateViewConstraints()
    }
}

