//
//  SettingsViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 13.03.2022.
//

import UIKit
import AVFoundation
import CoreData


class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    
    static let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var playSoundView: UIView!
    
    @IBOutlet weak var fontView: UIView!
    
    @IBOutlet weak var appSoundView: UIView!
    
    @IBOutlet weak var appSoundText: UILabel!
    
    @IBOutlet weak var switchAppSound: UISwitch!
    
    
    
    @IBOutlet weak var soundSpeedView: UIView!
    
    @IBOutlet weak var soundSpeedText: UILabel!
    
    @IBOutlet weak var soundSpeedButton: UIButton!
    
    @IBOutlet weak var soundSpeedSegmentedControl: UISegmentedControl!
    var selectedSpeed = 0.0
    
    
    
    @IBOutlet weak var x2view: UIView!
    
    @IBOutlet weak var x2button: UIButton!
    
    @IBOutlet weak var x2text: UILabel!
    
    @IBOutlet weak var x2time: UILabel!
    
    
    @IBOutlet weak var newWordView: UIView!
    
    @IBOutlet weak var newWordText: UILabel!
    
    @IBOutlet weak var switchNewWord: UISwitch!
    
    
    @IBOutlet weak var settingsText: UILabel!
    
    @IBOutlet weak var playSoundText: UILabel!
    
    @IBOutlet weak var sizeText: UILabel!
    
    
    @IBOutlet weak var switchPlaySound: UISwitch!
    
    @IBOutlet weak var textSegmentedControl: UISegmentedControl!
    
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    
    let hours = ["00:00 - 01:00",
                 "01:00 - 02:00",
                 "02:00 - 03:00",
                 "03:00 - 04:00",
                 "04:00 - 05:00",
                 "05:00 - 06:00",
                 "06:00 - 07:00",
                 "07:00 - 08:00",
                 "08:00 - 09:00",
                 "09:00 - 10:00",
                 "10:00 - 11:00",
                 "11:00 - 12:00",
                 "12:00 - 13:00",
                 "13:00 - 14:00",
                 "14:00 - 15:00",
                 "15:00 - 16:00",
                 "16:00 - 17:00",
                 "17:00 - 18:00",
                 "18:00 - 19:00",
                 "19:00 - 20:00",
                 "20:00 - 21:00",
                 "21:00 - 22:00",
                 "22:00 - 23:00",
                 "23:00 - 00:00"]
    var onViewWillDisappear: (()->())?
    
    var soundImageName = ""
    
    override func viewDidLoad() {
        
        // DETECT LİGHT MODE OR DARK MODE
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    soundImageName = "soundBlack"
                    break
                case .dark:
                    soundImageName = "soundLeft"
                    break
                default:
                    print("success")
                }
        
        
        playSoundView.layer.cornerRadius = 8
        fontView.layer.cornerRadius = 8
        x2view.layer.cornerRadius = 8
        appSoundView.layer.cornerRadius = 8
        soundSpeedView.layer.cornerRadius = 8
        newWordView.layer.cornerRadius = 8
        
        settingsView.clipsToBounds = true
        settingsView.layer.cornerRadius = 16
        settingsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // 1 is false, 0 is true
        if UserDefaults.standard.integer(forKey: "playSound") == 1 {
            switchPlaySound.isOn = false
            soundSpeedView.isHidden = true
            updateMultiplier(3)
        } else {
            switchPlaySound.isOn = true
            soundSpeedView.isHidden = false
            updateMultiplier(5)
        }
        
        // 1 is false, 0 is true
        if UserDefaults.standard.integer(forKey: "playAppSound") == 1 {
            switchAppSound.isOn = false
        } else {
            switchAppSound.isOn = true
        }
        
        // 1 is false, 0 is true
        if UserDefaults.standard.integer(forKey: "newWord") == 1 {
            switchNewWord.isOn = false
        } else {
            switchNewWord.isOn = true
        }
        
        if UserDefaults.standard.integer(forKey: "textSize") == 0 {
            UserDefaults.standard.set(15, forKey: "textSize")
        }
        
        if UserDefaults.standard.double(forKey: "soundSpeed") < 0.3 {
            UserDefaults.standard.set(0.3, forKey: "soundSpeed")
        }
        
        x2time.text = hours[UserDefaults.standard.integer(forKey: "userSelectedHour")]

        selectedSpeed = UserDefaults.standard.double(forKey: "soundSpeed")
        
        
        switch selectedSpeed {
        case 0.3:
            soundSpeedSegmentedControl.selectedSegmentIndex = 0
            break
        case 0.5:
            soundSpeedSegmentedControl.selectedSegmentIndex = 1
            break
        case 0.7:
            soundSpeedSegmentedControl.selectedSegmentIndex = 2
            break

        default:
            print("nothing")
        }
        
        switch UserDefaults.standard.integer(forKey: "textSize") {
        case 9:
            textSegmentedControl.selectedSegmentIndex = 0
            break
        case 11:
            textSegmentedControl.selectedSegmentIndex = 1
            break
        case 13:
            textSegmentedControl.selectedSegmentIndex = 2
            break
        case 15:
            textSegmentedControl.selectedSegmentIndex = 3
            break
        case 17:
            textSegmentedControl.selectedSegmentIndex = 4
            break
        case 19:
            textSegmentedControl.selectedSegmentIndex = 5
            break
        case 21:
            textSegmentedControl.selectedSegmentIndex = 6
            break
        default:
            print("nothing")
        }
        
        updateTextSize()
        
        
        soundSpeedButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30, height: 30)).image { _ in
            UIImage(named: soundImageName)?.draw(in: CGRect(x: 0, y: 0, width: 30, height: 30)) }, for: .normal)
        
       
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        if segue.identifier == "goPicker" {
         
            if segue.destination is X2ViewController {
                (segue.destination as? X2ViewController)?.onViewWillDisappear = { (id) -> Void in
                    self.x2time.text = self.hours[id]
                    self.onViewWillDisappear?()// trigger function in ViewController
                }
            }
            
        }
        
    }

    
    @IBAction func playSoundChanged(_ sender: UISwitch) {
        
    print("gogogogo")
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "playSound")
            UIView.transition(with: soundSpeedView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.soundSpeedView.isHidden = false
                          })
            
            updateMultiplier(5)
            
        } else {
            UserDefaults.standard.set(1, forKey: "playSound")
            UIView.transition(with: soundSpeedView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.soundSpeedView.isHidden = true
                          })
            updateMultiplier(3)
        }
        
    }
    
    func updateMultiplier(_ value:Double){
        let newConstraint = viewConstraint.constraintWithMultiplier(value)
        viewConstraint.isActive = false
        view.addConstraint(newConstraint)
        view.layoutIfNeeded()
        viewConstraint = newConstraint
    }
    
    
    @IBAction func playAppSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "playAppSound")
        } else {
            UserDefaults.standard.set(1, forKey: "playAppSound")
        }
    }
    
    
    @IBAction func newWordChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(0, forKey: "newWord")
        } else {
            UserDefaults.standard.set(1, forKey: "newWord")
        }
    }
    
    
    @IBAction func soundSpeedChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(0.3, forKey: "soundSpeed")
            selectedSpeed = 0.3
            break
        case 1:
            UserDefaults.standard.set(0.5, forKey: "soundSpeed")
            selectedSpeed = 0.5
            break
        case 2:
            UserDefaults.standard.set(0.7, forKey: "soundSpeed")
            selectedSpeed = 0.7
            break
        default:
            print("nothing")
        }
        soundSpeedButton.flash()
        playSound()
    }
    
    
    
    
    @IBAction func soundSpeedButtonPressed(_ sender: UIButton) {
        soundSpeedButton.flash()
        playSound()
    }
    
    func playSound()
    {
        let u = AVSpeechUtterance(string: "how are you?")
            u.voice = AVSpeechSynthesisVoice(language: "en-US")
            //        u.voice = AVSpeechSynthesisVoice(language: "en-GB")
        u.rate = Float(selectedSpeed)
        SettingsViewController.synth.speak(u)
        
    }
    
    @IBAction func textSizeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefaults.standard.set(9, forKey: "textSize")
            break
        case 1:
            UserDefaults.standard.set(11, forKey: "textSize")
            break
        case 2:
            UserDefaults.standard.set(13, forKey: "textSize")
            break
        case 3:
            UserDefaults.standard.set(15, forKey: "textSize")
            break
        case 4:
            UserDefaults.standard.set(17, forKey: "textSize")
            break
        case 5:
            UserDefaults.standard.set(19, forKey: "textSize")
            break
        case 6:
            UserDefaults.standard.set(21, forKey: "textSize")
            break
        default:
            print("nothing")
        }
        //onViewWillDisappear?()
        updateTextSize()
        
    }
    
    
    func updateTextSize(){

        let textSize = CGFloat(UserDefaults.standard.integer(forKey: "textSize"))
        
        settingsText.font = settingsText.font.withSize(textSize)
        
        playSoundText.font = playSoundText.font.withSize(textSize)
        sizeText.font = sizeText.font.withSize(textSize)
        x2text.font = x2text.font.withSize(textSize)
        x2time.font = x2time.font.withSize(textSize)
        appSoundText.font = appSoundText.font.withSize(textSize)
        soundSpeedText.font = soundSpeedText.font.withSize(textSize)
        newWordText.font = newWordText.font.withSize(textSize)
  
        textSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "cellTextColor")!, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        soundSpeedSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor(named: "cellTextColor")!, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
        

    }
    
    
    @IBAction func topViewPressed(_ sender: UIButton) {
        checkAction()
    }
    
    @IBAction func bottomViewPressed(_ sender: UIButton) {
        //checkAction()
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        checkAction()
    }
    
    func checkAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func updateViewConstraints() {
                self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
                super.updateViewConstraints()
    }
}
