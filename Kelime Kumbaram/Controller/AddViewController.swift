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
    
    @IBOutlet var firstView: UIView!
    
    @IBOutlet weak var darkView: UIView!
    var tapGesture = UITapGestureRecognizer()
    
    @IBOutlet weak var textView: UIView!
    
    
    @IBOutlet weak var engTxtField: UITextField!
    
    @IBOutlet weak var trTxtField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    
    var isOpen = false
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemArray = [Item]()

    var player: AVAudioPlayer!
    var onViewWillDisappear: (()->())?
    
    var goEdit = 0
    var editIndex = 0
    
    var textForLabel = ""
    var userWordCount = ""
    var userWordCountInt = 0
    var userWordCountIntVariable = 0 //fix userdefaults slow problem
    
    override func viewDidLoad() {
        
        addButton.setTitle("", for: .normal)
        addButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 23, height: 23)).image { _ in
            UIImage(named: "plus")?.draw(in: CGRect(x: 0, y: 0, width: 23, height: 23)) }, for: .normal)
        
        firstView.backgroundColor = UIColor(white: 0.1, alpha: 0.4)
        textView.layer.cornerRadius = 12
        addButton.layer.cornerRadius = 6

        checkButton.setBackgroundImage(nil, for: .normal)
        checkButton.setTitle("", for: .normal)
        engTxtField.delegate = self
        trTxtField.delegate = self
        
        if goEdit == 1 {
            engTxtField.text = UserDefaults.standard.string(forKey: "engEdit")
            trTxtField.text = UserDefaults.standard.string(forKey: "trEdit")
            addButton.setTitle("Kaydet", for: UIControl.State.normal)
            addButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 0, height: 0)).image { _ in
                UIImage(named: "empty")?.draw(in: CGRect(x: 0, y: 0, width: 0, height: 0)) }, for: .normal)
        }
        
        engTxtField.attributedPlaceholder = NSAttributedString(
            string: "İngilizce",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        trTxtField.attributedPlaceholder = NSAttributedString(
            string: "Türkçe",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        )
        
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        engTxtField.becomeFirstResponder()
        userWordCountIntVariable = UserDefaults.standard.integer(forKey: "userWordCount")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onViewWillDisappear?()
        }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == engTxtField {
                trTxtField.becomeFirstResponder()
            }else {
                engTxtField.becomeFirstResponder()
            }
                return true
        }
    
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
            if engTxtField.text!.count > 0 && trTxtField.text!.count > 0 {
                
                playMP3("mario")
                
                if goEdit == 0 {
                    let newItem = Item(context: self.context)
                    newItem.eng = engTxtField.text!
                    newItem.tr = trTxtField.text!
                    newItem.date = Date()
                    newItem.uuid = UUID().uuidString
                    newItem.isCreatedFromUser = true
                    self.itemArray.append(newItem)
                    
                    let userWord = UserDefaults.standard.integer(forKey: "userWordCount")
                    UserDefaults.standard.set(userWord+1, forKey: "userWordCount")
                    
                    userWordCountIntVariable += 1
                 
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(goVideo), userInfo: nil, repeats: false)
                    
                } else {
                    itemArray[editIndex].eng = engTxtField.text!
                    itemArray[editIndex].tr = trTxtField.text!
                    
                    Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(diss), userInfo: nil, repeats: false)
                }
                
                onViewWillDisappear?()
 
                
                engTxtField.text = ""
                trTxtField.text = ""
                
                engTxtField.becomeFirstResponder()

                let image = UIImage(named: "coin.png")!
                checkButton.setBackgroundImage(image, for: .normal)
                
                UIView.transition(with: checkButton, duration: 0.2, options: .transitionFlipFromTop, animations: nil, completion: nil)
                
                Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(flipSecond), userInfo: nil, repeats: false)

                Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(animateDown), userInfo: nil, repeats: false)
                
                Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(changeSomething), userInfo: nil, repeats: false)

            }
        
    }
    
    @objc func flipSecond(){
        
        let image = UIImage(named: "coin.png")!
        checkButton.setBackgroundImage(image, for: .normal)
        
        UIView.transition(with: checkButton, duration: 0.5, options: .transitionFlipFromTop, animations: nil, completion: nil)
        
    }

    @objc func changeSomething(){
        checkButton.setBackgroundImage(nil, for: .normal)
        
    }
    @IBAction func topViewPressed(_ sender: UIButton) {
        checkAction()
    }
    
    @objc func diss(){
        firstView.backgroundColor = UIColor.clear
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func animateDown(){
        checkButton.animateDown()
    }
    
    @objc func goVideo(){
        let lastPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        
        //print("userWordCountIntVariable>>\(userWordCountIntVariable)")
        //print("lastPoint>>\(lastPoint)")
        if userWordCountIntVariable >= 100 {
           
           let newPoint = userWordCountIntVariable/100*2 + 12
           // print("newPoint>>\(newPoint)")
            if newPoint - lastPoint > 0 {
                textForLabel = "Her doğru cevap için\n +\(newPoint-10) puan alacaksınız."
                userWordCount = String(userWordCountIntVariable)
                UserDefaults.standard.set(newPoint, forKey: "pointForMyWords")
                performSegue(withIdentifier: "goNewPoint", sender: self)
            }
        } else {
            var newPoint = 0
            if  userWordCountIntVariable >= 10{
                if userWordCountIntVariable < 50 {
                    newPoint = 11
                } else {
                    newPoint = 12
                }
                if newPoint - lastPoint > 0 {
                    textForLabel = "Her doğru cevap için\n +\(newPoint-10) puan kazanacaksınız."
                    userWordCount = String(userWordCountIntVariable)
                    UserDefaults.standard.set(newPoint, forKey: "pointForMyWords")
                    performSegue(withIdentifier: "goNewPoint", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goNewPoint" {
                let destinationVC = segue.destination as! NewPointViewController
                destinationVC.textForLabel = textForLabel
                destinationVC.userWordCount = userWordCount
            }
        }
    
    
    @IBAction func bottomViewPressed(_ sender: UIButton) {
      //  checkAction()
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
    
    func checkAction(){
        if engTxtField.text!.count > 0 || trTxtField.text!.count > 0 {
            let alert = UIAlertController(title: "Değişiklikler kaydedilmedi", message: "", preferredStyle: .alert)

            let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.dismiss(animated: true, completion: nil)
            }
            
            let actionCancel = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel) { (action) in
                // what will happen once user clicks the cancel item button on UIAlert
                alert.dismiss(animated: true, completion: nil)

            }
            
            
            alert.addAction(action)
            alert.addAction(actionCancel)
            if goEdit == 1 {
                if engTxtField.text != UserDefaults.standard.string(forKey: "engEdit") ||
                    trTxtField.text != UserDefaults.standard.string(forKey: "trEdit") {
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

    
    func playMP3(_ soundName: String)
    {
        if UserDefaults.standard.integer(forKey: "playAppSound") == 0 {
            let url = Bundle.main.url(forResource: "/sounds/\(soundName)", withExtension: "mp3")
            player = try! AVAudioPlayer(contentsOf: url!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                 try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                 print(error)
               }
            player.play()
        }
    }
}

