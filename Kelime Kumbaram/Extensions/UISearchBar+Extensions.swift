//
//  UISearchBar+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 21.07.2022.
//

import Foundation
import UIKit

extension UISearchBar {
    
    func updateSearchBarVisibility(_ bool: Bool){
        UIView.transition(with: self, duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.isHidden = bool
                      })
    }
    
}
