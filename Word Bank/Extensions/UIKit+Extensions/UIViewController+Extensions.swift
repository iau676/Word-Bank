//
//  UIViewController+Extensions.swift
//  Word Bank
//
//  Created by ibrahim uysal on 5.11.2022.
//

import UIKit

extension UIViewController {
    
    func size(forText text: String?, minusWidth: CGFloat = 0) -> CGSize {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.lineBreakMode = .byWordWrapping
        label.setWidth((self.view.frame.width/2)-minusWidth)
        return label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String, completion: @escaping(Bool)-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default) { (action) in
            alert.dismiss(animated: false, completion: nil)
            completion(true)
        }
        alert.addAction(actionOK)
        present(alert, animated: true)
    }
    
    func showAlertPopup(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, message: String, actionTitle: String = "OK", style: UIAlertAction.Style = .default, completion: @escaping(Bool)-> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: style) { (action) in
            alert.dismiss(animated: false, completion: nil)
            completion(true)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(actionCancel)
        present(alert, animated: true, completion: nil)
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    func pushViewControllerWithDeadline(controller: UIViewController, deadline: CGFloat = 0.1) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + deadline) {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WordsController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
