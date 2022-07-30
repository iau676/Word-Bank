//
//  WordBrain+calculateExercisePoint.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 30.07.2022.
//

import Foundation

extension WordBrain {
    func calculateExercisePoint(userWordCount: Int = WordBrain.userWordCount.getInt()){
        let lastPoint = exercisePoint.getInt()
        switch userWordCount {
        case _ where userWordCount >= 100:
            let newPoint = userWordCount/100*2 + 12
            if newPoint != lastPoint {
                exercisePoint.set(newPoint)
            }
        case _ where userWordCount >= 50:
            exercisePoint.set(12)
        case _ where userWordCount >= 10:
            exercisePoint.set(11)
        default:
            exercisePoint.set(10)
        }
    }
}
