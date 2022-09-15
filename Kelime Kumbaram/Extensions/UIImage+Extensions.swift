//
//  UIImage+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 15.09.2022.
//

import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
