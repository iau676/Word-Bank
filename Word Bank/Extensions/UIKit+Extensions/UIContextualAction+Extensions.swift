//
//  UIContextualAction+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 30.07.2022.
//

import Foundation
import UIKit

extension UIContextualAction {
    func setImage(image: UIImage?, width: CGFloat, height: CGFloat){
        self.image = UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            image?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }
    }
    
    func setBackgroundColor(_ uicolor: UIColor?){
        self.backgroundColor = uicolor
    }
}
