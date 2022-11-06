//
//  WordBrain+PrizePoints.swift
//  Word Bank
//
//  Created by ibrahim uysal on 6.11.2022.
//

import Foundation

extension WordBrain {
    func getPrizePoint() -> Int{
        switch UserDefault.level.getInt() {
        case 0..<5:
            return 250
        case 5..<10:
            return 500
        case 10..<15:
            return 1_000
        case 15..<20:
            return 2_000
        case 20..<25:
            return 4_000
        case 25..<30:
            return 10_000
        case 30..<35:
            return 15_000
        case 35..<40:
            return 30_000
        case 40..<45:
            return 50_000
        case 45..<50:
            return 100_000
        case 50..<55:
            return 200_000
        case 55..<60:
            return 400_000
        case 60..<65:
            return 600_000
        case 65..<70:
            return 1_000_000
        case 70..<80:
            return 2_000_000
        case 81..<90:
            return 5_000_000
        case 90..<100:
            return 10_000_000
        default: return 676
        }
    }
}
