//
//  AddController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 1.02.2022.
//

import UIKit
import AVFoundation
import CoreData

class AddViewController: UIViewController, UITextFieldDelegate {
    
    let coinButtonView = UIButton()
    let coinButton = UIButton()
    
    let textView = UIView()
    let stackView = UIStackView()
    let engTxtField = UITextField()
    let trTxtField = UITextField()
    let addButton = UIButton()
    
    var player = Player()
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    var tapGesture = UITapGestureRecognizer()
    var updateWordsPage: (()->())?
    var onViewWillDisappear: (()->())?
    var goEdit = 0
    var editIndex = 0
    var userWordCountInt = 0
    var userWordCountIntVariable = 0 //fix userdefaults slow problem
    
    var coinButtonImage: UIImage { return goEdit == 0 ? Images.coin! : Images.check!}
    var coinButtonAnimation: UIView.AnimationOptions { return goEdit == 0 ? .transitionFlipFromTop : .transitionFlipFromLeft }
    
    var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    let textViewHeight: CGFloat = 214
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        wordBrain.loadItemArray()
        
        style()
        layout()
        
        setupButtons()
        configureColor()
        configureTextFields()
        cofigureTextViewYAnchor()
        addGestureRecognizer()
        checkEditStatus()
        preventInterrupt()
        userWordCountIntVariable = UserDefault.userWordCount.getInt()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onViewWillDisappear?()
    }
    
    //MARK: - Selectors
    
    @objc func addButtonPressed(_ sender: Any) {
        addButton.bounce()
        if engTxtField.text!.count > 0 && trTxtField.text!.count > 0 {
            player.playMP3(Sounds.mario)
            if goEdit == 0 {
                wordBrain.addWord(english: engTxtField.text!, meaning: trTxtField.text!)
                UserDefault.userWordCount.set(userWordCountIntVariable+1)
                userWordCountIntVariable += 1
                scheduledTimer(timeInterval: 0.1, #selector(goNewPoint))
            } else {
                itemArray[editIndex].eng = engTxtField.text!
                itemArray[editIndex].tr = trTxtField.text!
                scheduledTimer(timeInterval: 0.8, #selector(dismissView))
            }
            
            updateWordsPage?()
            
            trTxtField.text = ""
            engTxtField.text = ""
            engTxtField.becomeFirstResponder()

            flipCoinButton()
        }
    }
    
    @objc func coinButtonViewPressed(_ sender: UIButton) {
        checkAction()
    }
    
    @objc func coinButtonPressed(_ sender: UIButton) {
        checkAction()
    }
        
    @objc func dismissView(){
        view.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func goNewPoint(){
        let lastPoint = UserDefault.exercisePoint.getInt()
        wordBrain.calculateExercisePoint(userWordCount: userWordCountIntVariable)
        let newPoint = UserDefault.exercisePoint.getInt()
        
        if newPoint != lastPoint {
            let vc = NewPointViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
    
    //MARK: - Helpers
    
    func configureColor(){
        engTxtField.textColor = Colors.black
        trTxtField.textColor = Colors.black
        engTxtField.backgroundColor = Colors.cellRight
        trTxtField.backgroundColor = Colors.cellRight
        addButton.changeBackgroundColor(to: .darkGray)
        addButton.setTitleColor(Colors.cellRight, for: .normal)
    }

    func setupButtons(){
        setupButton(button: addButton, buttonTitle: "", image: Images.plus, imageSize: 23, cornerRadius: 6)
        coinButton.deleteBackgroundImage()
    }
    
    func configureTextFields(){
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
    
    func cofigureTextViewYAnchor(){
        if keyboardHeight+(textViewHeight/2) > view.frame.height/2 {
            textView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
            stackView.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-120).isActive = true
        }
    }
    
    func setupButton(button: UIButton, buttonTitle: String, image: UIImage?, imageSize: CGFloat=0, cornerRadius: Int){
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(image: image, width: imageSize, height: imageSize)
        button.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    func setupTxtField(txtFld: UITextField, placeholder: String){
        txtFld.delegate = self
        txtFld.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    func checkEditStatus() {
        if goEdit == 1 {
            engTxtField.text = UserDefault.engEdit.getString()
            trTxtField.text = UserDefault.trEdit.getString()
            setupButton(button: addButton, buttonTitle: "Save", image: UIImage(), imageSize: 0, cornerRadius: 6)
        }
    }
    
    func checkAction(){
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
                if engTxtField.text != UserDefault.engEdit.getString() ||
                    trTxtField.text != UserDefault.trEdit.getString() {
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
        
    func preventInterrupt(){
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }
    
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

extension AddViewController {
    
    func flipCoinButton(){
        coinButton.setBackgroundImage(coinButtonImage, for: .normal)
        UIView.transition(with: coinButton, duration: 0.2, options: coinButtonAnimation, animations: nil, completion: nil)
        scheduledTimer(timeInterval: 0.3, #selector(flipSecond))
        scheduledTimer(timeInterval: 0.7, #selector(animateDown))
        scheduledTimer(timeInterval: 1.5, #selector(deleteButtonBackgroundImage))
    }
    
    @objc func flipSecond(){
        UIView.transition(with: coinButton, duration: 0.5, options: coinButtonAnimation, animations: nil, completion: nil)
    }
    
    @objc func animateDown(){
        coinButton.animateCoinDown()
    }

    @objc func deleteButtonBackgroundImage(){
        coinButton.deleteBackgroundImage()
    }
}

//MARK: - Layout

extension AddViewController {
    
    func style(){
        view.backgroundColor = Colors.darkBackground
        
        coinButtonView.translatesAutoresizingMaskIntoConstraints = false
        
        coinButton.translatesAutoresizingMaskIntoConstraints = false
        coinButton.addTarget(self, action: #selector(coinButtonPressed), for: .touchUpInside)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = Colors.cellLeft
        textView.setViewCornerRadius(10)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        
        engTxtField.translatesAutoresizingMaskIntoConstraints = false
        engTxtField.placeholder = "English"
        engTxtField.keyboardType = .asciiCapable
        engTxtField.backgroundColor = Colors.cellRight
        engTxtField.layer.cornerRadius = 8
        engTxtField.setLeftPaddingPoints(10)
        
        trTxtField.translatesAutoresizingMaskIntoConstraints = false
        trTxtField.placeholder = "Meaning"
        trTxtField.keyboardType = .asciiCapable
        trTxtField.backgroundColor = Colors.cellRight
        trTxtField.layer.cornerRadius = 8
        trTxtField.setLeftPaddingPoints(10)
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .darkGray
        addButton.layer.cornerRadius = 8
        addButton.setTitle("+", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    }
    
    func layout(){
        coinButtonView.addSubview(coinButton)
        view.addSubview(coinButtonView)
        
        stackView.addArrangedSubview(engTxtField)
        stackView.addArrangedSubview(trTxtField)
        stackView.addArrangedSubview(addButton)
        
        textView.addSubview(stackView)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            coinButtonView.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            
            coinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            coinButtonView.heightAnchor.constraint(equalToConstant: view.frame.size.height-(view.center.y+130)),
            coinButtonView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            coinButton.heightAnchor.constraint(equalToConstant: 120),
            coinButton.widthAnchor.constraint(equalToConstant: 120),
            
            textView.heightAnchor.constraint(equalToConstant: 214),
            textView.widthAnchor.constraint(equalToConstant: view.frame.size.width-32),
            
            stackView.heightAnchor.constraint(equalToConstant: 182),
        ])
    }
}

//MARK: - Swipe Gesture

extension AddViewController {
    
    func addGestureRecognizer(){
        let dismissView = UITapGestureRecognizer(target: self, action:  #selector(coinButtonViewPressed))
        self.coinButtonView.addGestureRecognizer(dismissView)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeDownGesture))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    @objc func swipeDownGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
}
