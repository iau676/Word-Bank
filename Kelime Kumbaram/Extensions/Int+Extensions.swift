//
//  Int+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 24.07.2022.
//

import Foundation

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
