//
//  AddController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 1.02.2022.
//

import UIKit
import AVFoundation
import CoreData

protocol AddEditControllerDelegate : AnyObject {
    func updateTableView()
    func onViewWillDisappear()
}

class AddEditController: UIViewController {
    
    var item: Item?
    weak var delegate: AddEditControllerDelegate?
    
    private let coinButtonView = UIButton()
    private let coinButton = UIButton()
    
    private let textView = UIView()
    private let stackView = UIStackView()
    private let engTxtField = UITextField()
    private let trTxtField = UITextField()
    private let addButton = UIButton()
    
    private var player = Player()
    private var wordBrain = WordBrain()
    
    var goEdit = 0
    
    private var coinButtonImage: UIImage { return goEdit == 0 ? Images.coin! : Images.check!}
    private var coinButtonAnimation: UIView.AnimationOptions { return goEdit == 0 ?
        .transitionFlipFromTop : .transitionFlipFromLeft }
    
    private var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    private let textViewHeight: CGFloat = 214
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        wordBrain.loadItemArray()
        wordBrain.loadHardItemArray()
        
        style()
        layout()
        
        setupButtons()
        configureColor()
        configureTextFields()
        cofigureTextViewYAnchor()
        addGestureRecognizer()
        checkEditStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.onViewWillDisappear()
    }
    
    //MARK: - Selectors
    
    @objc private func addButtonPressed(_ sender: Any) {
        addButton.bounce()
        if engTxtField.text!.count > 0 && trTxtField.text!.count > 0 {
            let eng = engTxtField.text!
            let meaning = trTxtField.text!
           if engTxtField.text!.count <= 20 {
                player.playMP3(Sounds.mario)
                if goEdit == 0 {
                    wordBrain.addWord(english: eng, meaning: meaning)
                } else {
                    item?.eng = eng
                    item?.tr = meaning
                    wordBrain.updateHardItem(item, newEng: eng, newMeaning: meaning)
                    scheduledTimer(timeInterval: 0.8, #selector(dismissView))
                }
                
                trTxtField.text = ""
                engTxtField.text = ""
                engTxtField.becomeFirstResponder()

                flipCoinButton()
                delegate?.updateTableView()
            } else {
                showAlert(title: "Max character is 20", message: "")
            }
        }
    }
    
    @objc private func coinButtonViewPressed(_ sender: UIButton) {
        checkAction()
    }
    
    @objc private func coinButtonPressed(_ sender: UIButton) {
        checkAction()
    }
        
    @objc private func dismissView(){
        view.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    private func configureColor(){
        engTxtField.textColor = Colors.black
        trTxtField.textColor = Colors.black
        engTxtField.backgroundColor = Colors.cellRight
        trTxtField.backgroundColor = Colors.cellRight
        addButton.changeBackgroundColor(to: .darkGray)
        addButton.setTitleColor(Colors.cellRight, for: .normal)
    }

    private func setupButtons(){
        setupButton(button: addButton, buttonTitle: "", image: Images.plus, imageSize: 23, cornerRadius: 6)
        coinButton.deleteBackgroundImage()
    }
    
    private func configureTextFields(){
        setupTxtField(txtFld: engTxtField, placeholder: "English")
        setupTxtField(txtFld: trTxtField, placeholder: "Meaning")
        
        engTxtField.becomeFirstResponder()
        
        engTxtField.keyboardType = .asciiCapable
        trTxtField.keyboardType = .asciiCapable
        
        switch UserDefault.userInterfaceStyle {
        case "dark":
            engTxtField.keyboardAppearance = .dark
            trTxtField.keyboardAppearance = .dark
            break
        default:
            engTxtField.keyboardAppearance = .default
            trTxtField.keyboardAppearance = .default
        }
    }
    
    private func cofigureTextViewYAnchor(){
        if keyboardHeight+(textViewHeight/2) > view.frame.height/2 {
            textView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
        }
    }
    
    private func setupButton(button: UIButton, buttonTitle: String, image: UIImage?, imageSize: CGFloat=0, cornerRadius: Int){
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(image: image, width: imageSize, height: imageSize)
        button.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    private func setupTxtField(txtFld: UITextField, placeholder: String){
        txtFld.delegate = self
        txtFld.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    private func checkEditStatus() {
        if goEdit == 1 {
            guard let item = item else { return }
            engTxtField.text = item.eng
            trTxtField.text = item.tr
            setupButton(button: addButton, buttonTitle: "Save", image: UIImage(), imageSize: 0, cornerRadius: 6)
        }
    }
    
    private func checkAction(){
        if engTxtField.text!.count > 0 || trTxtField.text!.count > 0 {
            let alert = UIAlertController(title: "Your changes could not be saved", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            alert.addAction(actionCancel)
            
            if goEdit == 1 {
                guard let item = item else { return }
                if engTxtField.text != item.eng ||
                    trTxtField.text != item.tr {
                    present(alert, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                present(alert, animated: true, completion: nil)
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
            trTxtField.becomeFirstResponder()
        } else {
            engTxtField.becomeFirstResponder()
        }
        return true
    }
}

//MARK: - Flip Button

extension AddEditController {
    
    private func flipCoinButton(){
        coinButton.setBackgroundImage(coinButtonImage, for: .normal)
        UIView.transition(with: coinButton, duration: 0.2, options: coinButtonAnimation, animations: nil, completion: nil)
        scheduledTimer(timeInterval: 0.3, #selector(flipSecond))
        scheduledTimer(timeInterval: 0.7, #selector(animateDown))
        scheduledTimer(timeInterval: 1.5, #selector(deleteButtonBackgroundImage))
    }
    
    @objc private func flipSecond(){
        UIView.transition(with: coinButton, duration: 0.5, options: coinButtonAnimation, animations: nil, completion: nil)
    }
    
    @objc private func animateDown(){
        coinButton.animateCoinDown(y: self.view.frame.height-UserDefault.keyboardHeight.getCGFloat()-66)
    }

    @objc private func deleteButtonBackgroundImage(){
        coinButton.deleteBackgroundImage()
    }
}

//MARK: - Layout

extension AddEditController {
    
    private func style(){
        view.backgroundColor = Colors.darkBackground
        
        coinButton.addTarget(self, action: #selector(coinButtonPressed), for: .touchUpInside)
        
        textView.backgroundColor = Colors.cellLeft
        textView.setViewCornerRadius(10)
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        engTxtField.placeholder = "English"
        engTxtField.keyboardType = .asciiCapable
        engTxtField.backgroundColor = Colors.cellRight
        engTxtField.layer.cornerRadius = 8
        engTxtField.setLeftPaddingPoints(10)
        
        trTxtField.placeholder = "Meaning"
        trTxtField.keyboardType = .asciiCapable
        trTxtField.backgroundColor = Colors.cellRight
        trTxtField.layer.cornerRadius = 8
        trTxtField.setLeftPaddingPoints(10)
        
        addButton.backgroundColor = .darkGray
        addButton.layer.cornerRadius = 8
        addButton.setTitle("+", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    private func layout(){
        coinButtonView.addSubview(coinButton)
        view.addSubview(coinButtonView)
        
        stackView.addArrangedSubview(engTxtField)
        stackView.addArrangedSubview(trTxtField)
        stackView.addArrangedSubview(addButton)
        
        textView.addSubview(stackView)
        view.addSubview(textView)
        
        coinButtonView.setDimensions(width: view.bounds.width,
                                     height: view.frame.size.height-(view.center.y+130))
        coinButtonView.anchor(top: view.topAnchor, paddingTop: 32)
        
        coinButton.setDimensions(width: 120, height: 120)
        coinButton.centerX(inView: view)
        
        textView.setDimensions(width: view.frame.size.width-32, height: 214)
        textView.centerX(inView: view)
        textView.centerY(inView: view)
        
        stackView.setDimensions(width: view.bounds.width-64, height: 182)
        stackView.centerY(inView: view)
        stackView.centerX(inView: view)
    }
}

//MARK: - Swipe Gesture

extension AddEditController {
    
    private func addGestureRecognizer(){
        let dismissView = UITapGestureRecognizer(target: self, action:  #selector(coinButtonViewPressed))
        self.coinButtonView.addGestureRecognizer(dismissView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc private func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
}
