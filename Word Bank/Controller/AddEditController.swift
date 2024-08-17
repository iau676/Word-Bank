//
//  AddController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 1.02.2022.
//

import UIKit
import CoreData

protocol AddEditControllerDelegate : AnyObject {
    func updateTableView()
    func onViewWillDisappear()
}

class AddEditController: UIViewController {
    
    var item: Item?
    var goEdit = 0
    weak var delegate: AddEditControllerDelegate?
    private var wordBrain = WordBrain()
    
    private var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    private let textViewHeight: CGFloat = 214
    
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
    
    private lazy var addButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.setTitle("+", for: .normal)
        button.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        wordBrain.loadItemArray()
        wordBrain.loadHardItemArray()
        
        configureUI()
        addSwipeGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.onViewWillDisappear()
    }
    
    //MARK: - Selectors
    
    @objc private func addButtonPressed(_ sender: Any) {
        addButton.bounce()
        if engTxtField.text!.count > 0 && meaningTxtField.text!.count > 0 {
            let eng = engTxtField.text!
            let meaning = meaningTxtField.text!
           if engTxtField.text!.count <= 20 {
                if goEdit == 0 {
                    wordBrain.addWord(english: eng, meaning: meaning)
                } else {
                    item?.eng = eng
                    item?.tr = meaning
                    wordBrain.updateHardItem(item, newEng: eng, newMeaning: meaning)
                    scheduledTimer(timeInterval: 0.8, #selector(dismissView))
                }
                
                meaningTxtField.text = ""
                engTxtField.text = ""
                engTxtField.becomeFirstResponder()

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
        view.backgroundColor = Colors.darkBackground
        
        setupButtons()
        configureColor()
        configureTextFields()
        cofigureTextViewYAnchor()
        
        view.addSubview(flipButton)
        flipButton.centerX(inView: view)
        flipButton.setDimensions(width: 120, height: 120)
        flipButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        stackView.addArrangedSubview(engTxtField)
        stackView.addArrangedSubview(meaningTxtField)
        stackView.addArrangedSubview(addButton)
        
        secondView.addSubview(stackView)
        view.addSubview(secondView)
        
        secondView.setDimensions(width: view.frame.size.width-32, height: 214)
        secondView.centerX(inView: view)
        secondView.centerY(inView: view)
        
        stackView.setDimensions(width: view.bounds.width-64, height: 182)
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
    }
    
    private func configureColor() {
        engTxtField.textColor = Colors.black
        meaningTxtField.textColor = Colors.black
        engTxtField.backgroundColor = Colors.cellRight
        meaningTxtField.backgroundColor = Colors.cellRight
        addButton.changeBackgroundColor(to: .darkGray)
        addButton.setTitleColor(Colors.cellRight, for: .normal)
    }

    private func setupButtons() {
        setupButton(button: addButton, buttonTitle: "", image: Images.plus, imageSize: 23, cornerRadius: 6)
        flipButton.deleteBackgroundImage()
    }
    
    private func configureTextFields() {
        engTxtField.delegate = self
        meaningTxtField.delegate = self
        engTxtField.becomeFirstResponder()
        
        switch UserDefault.userInterfaceStyle {
        case "dark":
            engTxtField.keyboardAppearance = .dark
            meaningTxtField.keyboardAppearance = .dark
            break
        default:
            engTxtField.keyboardAppearance = .default
            meaningTxtField.keyboardAppearance = .default
        }
        
        guard let item = item else { return }
        engTxtField.text = item.eng
        meaningTxtField.text = item.tr
//        setupButton(button: addButton, buttonTitle: "Save", image: UIImage(), imageSize: 0, cornerRadius: 6)
    }
    
    private func cofigureTextViewYAnchor() {
        if keyboardHeight+(textViewHeight/2) > view.frame.height/2 {
            secondView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
        }
    }
    
    private func setupButton(button: UIButton, buttonTitle: String, image: UIImage?, imageSize: CGFloat=0, cornerRadius: Int){
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(image: image, width: imageSize, height: imageSize)
        button.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func checkAction(){
        if engTxtField.text!.count > 0 || meaningTxtField.text!.count > 0 {
            if goEdit == 1 {
                guard let item = item else { return }
                if engTxtField.text != item.eng || meaningTxtField.text != item.tr {
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

extension AddEditController: UITextFieldDelegate {
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

extension AddEditController {
    private func animateFlipButton() {
        let flipButtonImage = goEdit == 0 ? Images.dropBlue! : Images.check!
        flipButton.setBackgroundImage(flipButtonImage, for: .normal)
        UIView.transition(with: flipButton, duration: 0.2, options: .transitionFlipFromLeft, animations: nil) { _ in
            UIView.transition(with: self.flipButton, duration: 0.5, options: .transitionFlipFromLeft, animations: nil) { _ in
                self.flipButton.animateCoinDown(y: self.view.frame.height-UserDefault.keyboardHeight.getCGFloat()-66)
            }
        }
        scheduledTimer(timeInterval: 1.5, #selector(deleteButtonBackgroundImage))
    }

    @objc private func deleteButtonBackgroundImage() {
        flipButton.deleteBackgroundImage()
    }
}

//MARK: - Swipe Gesture

extension AddEditController {
    private func addSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
}
