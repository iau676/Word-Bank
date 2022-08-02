//
//  WordBrain+calculateExercisePoint.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 30.07.2022.
//

import Foundation

extension WordBrain {
    func calculateExercisePoint(userWordCount: Int = UserDefault.userWordCount.getInt()){
        let lastPoint = UserDefault.exercisePoint.getInt()
        switch userWordCount {
        case _ where userWordCount >= 100:
            let newPoint = userWordCount/100*2 + 12
            if newPoint != lastPoint {
                UserDefault.exercisePoint.set(newPoint)
            }
        case _ where userWordCount >= 50:
            UserDefault.exercisePoint.set(12)
        case _ where userWordCount >= 10:
            UserDefault.exercisePoint.set(11)
        default:
            UserDefault.exercisePoint.set(10)
        }
    }
}
