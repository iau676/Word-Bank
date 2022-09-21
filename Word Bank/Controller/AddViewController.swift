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
    
    //MARK: - IBOutlet
    
    @IBOutlet var firstView: UIView!
    @IBOutlet weak var darkView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var engTxtField: UITextField!
    @IBOutlet weak var trTxtField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var coinButton: UIButton!
    
    //MARK: - Variables
    
    var player = Player()
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    var tapGesture = UITapGestureRecognizer()
    var updateWordsPage: (()->())?
    var onViewWillDisappear: (()->())?
    var goEdit = 0
    var editIndex = 0
    var userWordCountInt = 0
    var textForLabel = ""
    var userWordCount = ""
    var userWordCountIntVariable = 0 //fix userdefaults slow problem
    let coinImage = UIImage(named: "coin.png")!
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        wordBrain.loadItemArray()
        setupViews()
        setupButtons()
        setupTxtFields()
        checkEditStatus()
        preventInterrupt()
        userWordCountIntVariable = UserDefault.userWordCount.getInt()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onViewWillDisappear?()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goNewPoint" {
            let destinationVC = segue.destination as! NewPointViewController
            destinationVC.textForLabel = textForLabel
            destinationVC.userWordCount = userWordCount
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func addButtonPressed(_ sender: Any) {
        addButton.bounce()
        if engTxtField.text!.count > 0 && trTxtField.text!.count > 0 {
            player.playMP3("mario")
            if goEdit == 0 {
                wordBrain.addWord(english: engTxtField.text!, meaning: trTxtField.text!)
                UserDefault.userWordCount.set(userWordCountIntVariable+1)
                userWordCountIntVariable += 1
                scheduledTimer(timeInterval: 0.1, #selector(goNewPoint))
            } else {
                itemArray[editIndex].eng = engTxtField.text!
                itemArray[editIndex].tr = trTxtField.text!
                scheduledTimer(timeInterval: 0.9, #selector(dismissView))
            }
            
            updateWordsPage?()
            
            trTxtField.text = ""
            engTxtField.text = ""
            engTxtField.becomeFirstResponder()

            flipCoinButton()
        }
    }
    
    @IBAction func topViewPressed(_ sender: UIButton) {
        checkAction()
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }

    
    //MARK: - Selectors
    
    @objc func flipButton(){
        coinButton.setBackgroundImage(coinImage, for: .normal)
        UIView.transition(with: coinButton, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
    }

    @objc func deleteButtonBackgroundImage(){
        coinButton.deleteBackgroundImage()
    }
    
    @objc func dismissView(){
        firstView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func animateDown(){
        coinButton.animateDown()
    }
    
    @objc func goNewPoint(){
        let lastPoint = UserDefault.exercisePoint.getInt()
        wordBrain.calculateExercisePoint(userWordCount: userWordCountIntVariable)
        let newPoint = UserDefault.exercisePoint.getInt()
        if newPoint != lastPoint {
            textForLabel = "You will get +\(newPoint-10) points for each correct answer."
            userWordCount = String(userWordCountIntVariable)
            performSegue(withIdentifier: "goNewPoint", sender: self)
        }
    }
    
    //MARK: - Helpers
    
    func checkAction(){
        if engTxtField.text!.count > 0 || trTxtField.text!.count > 0 {
            let alert = UIAlertController(title: "Your changes could not be saved", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
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
    
    func setupViews(){
        firstView.backgroundColor = Colors.darkBackground
        textView.layer.cornerRadius = 12
    }
    
    func setupButtons(){
        setupButton(button: addButton, buttonTitle: "", imageName: "plus", imageSize: 23, cornerRadius: 6)
        coinButton.deleteBackgroundImage()
    }
    
    func setupTxtFields(){
        setupTxtField(txtFld: engTxtField, placeholder: "English")
        setupTxtField(txtFld: trTxtField, placeholder: "Meaning")
        engTxtField.becomeFirstResponder()
    }
    
    func setupButton(button: UIButton, buttonTitle: String, imageName: String, imageSize: CGFloat=0, cornerRadius: Int){
        button.setTitle(buttonTitle, for: .normal)
        button.setImage(imageName: imageName, width: imageSize, height: imageSize)
        button.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
    func setupTxtField(txtFld: UITextField, placeholder: String){
        txtFld.delegate = self
        txtFld.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
    }
    
    func flipCoinButton(){
        coinButton.setBackgroundImage(coinImage, for: .normal)
        UIView.transition(with: coinButton, duration: 0.2, options: .transitionFlipFromTop, animations: nil, completion: nil)
        scheduledTimer(timeInterval: 0.3, #selector(flipButton))
        scheduledTimer(timeInterval: 0.7, #selector(animateDown))
        scheduledTimer(timeInterval: 1.5, #selector(deleteButtonBackgroundImage))
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    func checkEditStatus() {
        if goEdit == 1 {
            engTxtField.text = UserDefault.engEdit.getString()
            trTxtField.text = UserDefault.trEdit.getString()
            setupButton(button: addButton, buttonTitle: "Save", imageName: "empty", imageSize: 0, cornerRadius: 6)
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

