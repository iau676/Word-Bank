//
//  UIColor+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 30.07.2022.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }
        self.init(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)
        return
    }
}
