//
//  UIViewController+Extensions.swift
//  Word Bank
//
//  Created by ibrahim uysal on 5.11.2022.
//

import UIKit

extension UIViewController {
    var topbarHeight: CGFloat {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
}
