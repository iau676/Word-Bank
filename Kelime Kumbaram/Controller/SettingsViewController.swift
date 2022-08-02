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
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var playSoundView: UIView!
    @IBOutlet weak var fontView: UIView!
    @IBOutlet weak var appSoundView: UIView!
    @IBOutlet weak var appSoundText: UILabel!
    @IBOutlet weak var soundSpeedView: UIView!
    @IBOutlet weak var x2view: UIView!
    
    @IBOutlet weak var x2text: UILabel!
    @IBOutlet weak var x2time: UILabel!
    @IBOutlet weak var settingsText: UILabel!
    @IBOutlet weak var wordSoundText: UILabel!
    @IBOutlet weak var soundSpeedText: UILabel!
    @IBOutlet weak var sizeText: UILabel!
    
    @IBOutlet weak var switchWordSound: UISwitch!
    @IBOutlet weak var switchAppSound: UISwitch!
    
    @IBOutlet weak var textSegmentedControl: UISegmentedControl!
    @IBOutlet weak var soundSpeedSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var x2button: UIButton!
    @IBOutlet weak var soundSpeedButton: UIButton!
    
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    //MARK: - Variable
    var player = Player()
    var wordBrain = WordBrain()
    var soundSpeed = 0.0
    var onViewWillDisappear: (()->())?
    var soundImageName = ""
    var textSize : CGFloat = 0.0
    
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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        assignSoundImageName()
        updateTextSize()
        setupCornerRadius()
        setupDefaults()
        setupButton(soundSpeedButton)
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPicker" {
            if segue.destination is X2SettingViewController {
                (segue.destination as? X2SettingViewController)?.onViewWillDisappear = { (id) -> Void in
                    self.x2time.text = self.hours[id]
                    self.onViewWillDisappear?()// trigger function in ViewController
                }
            }
        }
    }
    
    //MARK: - IBAction

    @IBAction func wordSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playSound.set(0)
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        } else {
            UserDefault.playSound.set(1)
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        }
    }
    
    @IBAction func appSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playAppSound.set(0)
        } else {
            UserDefault.playAppSound.set(1)
        }
    }
    
    @IBAction func soundSpeedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefault.soundSpeed.set(0.3)
            soundSpeed = 0.3
            break
        case 1:
            UserDefault.soundSpeed.set(0.5)
            soundSpeed = 0.5
            break
        case 2:
            UserDefault.soundSpeed.set(0.7)
            soundSpeed = 0.7
            break
        default: break
        }
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    
    @IBAction func speakerButtonPressed(_ sender: UIButton) {
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    @IBAction func textSizeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefault.textSize.set(9)
            break
        case 1:
            UserDefault.textSize.set(11)
            break
        case 2:
            UserDefault.textSize.set(13)
            break
        case 3:
            UserDefault.textSize.set(15)
            break
        case 4:
            UserDefault.textSize.set(17)
            break
        case 5:
            UserDefault.textSize.set(19)
            break
        default:
            UserDefault.textSize.set(21)
        }
        updateTextSize()
    }
    
    @IBAction func topViewPressed(_ sender: UIButton) {
        dismissView()
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        dismissView()
    }
    
    //MARK: - Other Functions
    
    func assignSoundImageName(){
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            soundImageName = "soundBlack"
            break
        case .dark:
            soundImageName = "soundLeft"
            break
        default: break
        }
    }
    
    func setupButton(_ button: UIButton){
        button.setImage(imageName: soundImageName, width: 30, height: 30)
    }
    
    func setupCornerRadius(){
        playSoundView.layer.cornerRadius = 8
        fontView.layer.cornerRadius = 8
        x2view.layer.cornerRadius = 8
        appSoundView.layer.cornerRadius = 8
        soundSpeedView.layer.cornerRadius = 8
        
        settingsView.clipsToBounds = true
        settingsView.layer.cornerRadius = 16
        settingsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    func setupDefaults(){
        if UserDefault.playSound.getInt() == 1 {
            switchWordSound.isOn = false
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        } else {
            switchWordSound.isOn = true
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        }
        
        if UserDefault.playAppSound.getInt() == 1 {
            switchAppSound.isOn = false
        } else {
            switchAppSound.isOn = true
        }
        
        if UserDefault.textSize.getInt() == 0 {
            UserDefault.textSize.set(15)
            UserDefault.soundSpeed.set(0.3)
        }
        
        x2time.text = hours[UserDefault.userSelectedHour.getInt()]
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        switch soundSpeed {
        case 0.3:
            soundSpeedSegmentedControl.selectedSegmentIndex = 0
            break
        case 0.5:
            soundSpeedSegmentedControl.selectedSegmentIndex = 1
            break
        case 0.7:
            soundSpeedSegmentedControl.selectedSegmentIndex = 2
            break
        default: break
        }
        
        switch UserDefault.textSize.getInt() {
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
        default: break
        }
    }

    func updateTextSize(){
        textSize = UserDefault.textSize.getCGFloat()
        
        updateLabelTextSize(settingsText)
        updateLabelTextSize(wordSoundText)
        updateLabelTextSize(sizeText)
        updateLabelTextSize(x2text)
        updateLabelTextSize(x2time)
        updateLabelTextSize(appSoundText)
        updateLabelTextSize(soundSpeedText)
  
        updateSegmentedControlTextSize(textSegmentedControl)
        updateSegmentedControlTextSize(soundSpeedSegmentedControl)
    }
    
    func updateSegmentedControlTextSize(_ segmentedControl: UISegmentedControl){
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black!, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
    }
    
    func updateLabelTextSize(_ label: UILabel){
        label.font = label.font.withSize(textSize)
    }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    func changeViewState(_ uiview: UIView, alpha a: CGFloat, isUserInteraction bool: Bool){
        UIView.transition(with: uiview, duration: 0.4,
                          options: (a < 1 ? .transitionFlipFromTop : .transitionFlipFromBottom),
                          animations: {
            uiview.isUserInteractionEnabled = bool
            uiview.alpha = a
        })
    }
    
    override func updateViewConstraints() {
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        super.updateViewConstraints()
    }
}
