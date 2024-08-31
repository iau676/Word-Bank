//
//  AddController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 1.02.2022.
//

import UIKit
import CoreData

protocol AddControllerDelegate : AnyObject {
    func updateTableView()
}

class AddController: UIViewController {
    
    //MARK: - Properties
    
    var item: Item?
    weak var delegate: AddControllerDelegate?
    
    private var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    private let secondViewHeight: CGFloat = 214
    
    private let flipButton = UIButton()
    private let engTxtField = makeTextField(placeholder: "English")
    private let meaningTxtField = makeTextField(placeholder: "Meaning")
    
    private let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellLeft
        view.setViewCornerRadius(10)
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.setTitle("Save", for: .normal)
        button.setTitleColor(Colors.cellRight, for: .normal)
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        brain.loadItemArray()
        brain.loadHardItemArray()
        
        configureUI()
        addSwipeGesture()
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = saveButton.bounds
        gradientLayer.colors = [Colors.green.cgColor, Colors.lightGreen.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.cornerRadius = 8
        gradientLayer.locations = [0.0, 1.0]
        saveButton.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    //MARK: - Selectors
    
    @objc private func saveButtonPressed(_ sender: Any) {
        saveButton.bounce()
        guard let eng = engTxtField.text else { return }
        guard let meaning = meaningTxtField.text else { return }
        
        if eng.count > 0 && meaning.count > 0 {
           if eng.count <= 20 {
                if let item = item {
                    item.eng = eng
                    item.tr = meaning
                    brain.updateHardItem(item, newEng: eng, newMeaning: meaning)
                    scheduledTimer(timeInterval: 0.75, #selector(dismissView))
                } else {
                    brain.addWord(english: eng, meaning: meaning)
                    scheduledTimer(timeInterval: 1.0, #selector(dismissView))
                }
                cleanTextFields()
                animateFlipButton()
                delegate?.updateTableView()
            } else {
                showAlert(title: "Max character is 20", message: "")
            }
        }
    }
        
    @objc private func dismissView(){
        view.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureTextFields()
        view.backgroundColor = Colors.darkBackground
        
        view.addSubview(flipButton)
        flipButton.centerX(inView: view)
        flipButton.setDimensions(width: 100, height: 100)
        flipButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        stackView.addArrangedSubview(engTxtField)
        stackView.addArrangedSubview(meaningTxtField)
        stackView.addArrangedSubview(saveButton)
        
        secondView.addSubview(stackView)
        view.addSubview(secondView)
        
        secondView.setDimensions(width: view.frame.size.width-32, height: 214)
        secondView.centerX(inView: view)
        secondView.centerY(inView: view)
        
        stackView.setDimensions(width: view.bounds.width-64, height: 182)
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
        
        if keyboardHeight+(secondViewHeight/2) > view.frame.height/2 {
            secondView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
        }
    }
    
    private func configureTextFields() {
        engTxtField.delegate = self
        meaningTxtField.delegate = self
        engTxtField.becomeFirstResponder()
        
        engTxtField.setKeyboardAppearance()
        meaningTxtField.setKeyboardAppearance()
        
        guard let item = item else { return }
        engTxtField.text = item.eng
        meaningTxtField.text = item.tr
    }
    
    private func cleanTextFields() {
        meaningTxtField.text = ""
        engTxtField.text = ""
        engTxtField.becomeFirstResponder()
    }
    
    private func checkAction() {
        guard let eng = engTxtField.text else { return }
        guard let meaning = meaningTxtField.text else { return }
        if eng.count > 0 || meaning.count > 0 {
            if let item = item {
                if eng != item.eng || meaning != item.tr {
                    showAlertWithCancel(title: "Your changes could not be saved", message: "") { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                showAlertWithCancel(title: "Your changes could not be saved", message: "") { _ in
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}

//MARK: - UITextFieldDelegate

extension AddController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == engTxtField {
            meaningTxtField.becomeFirstResponder()
        } else {
            engTxtField.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - Flip Button

extension AddController {
    private func animateFlipButton() {
        let flipButtonImage = item == nil ? Images.dropBlue! : Images.check!
        flipButton.setBackgroundImage(flipButtonImage, for: .normal)
        UIView.transition(with: flipButton, duration: 0.2, options: .transitionFlipFromLeft, animations: nil) { _ in
            UIView.transition(with: self.flipButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { _ in
                self.flipButton.animateCoinDown(y: self.view.frame.height-UserDefault.keyboardHeight.getCGFloat())
            }
        }
        scheduledTimer(timeInterval: 0.9, #selector(clearBackgrounds))
    }
    
    @objc private func clearBackgrounds() {
        flipButton.deleteBackgroundImage()
        self.view.backgroundColor = .clear
    }
}

//MARK: - Swipe Gesture

extension AddController {
    private func addSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
}
