//
//  UISegmentedControl+Extensions.swift
//  Word Bank
//
//  Created by ibrahim uysal on 18.10.2022.
//

import UIKit

extension UISegmentedControl {
    func replaceSegments(segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
