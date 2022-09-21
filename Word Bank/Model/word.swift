//
//  word.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import Foundation

struct Word {
    let eng: String
    let tr: String
    let correctNumber: Int16
    
    init(e: String, t: String) {
        eng = e
        tr = t
        correctNumber = 0
    }
}
