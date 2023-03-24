//
//  X2ViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 23.03.2022.
//

import UIKit
import CoreData
import UserNotifications

protocol X2SettingControllerDelegate: AnyObject {
    func x2HourChanged(_ userSelectedHour: Int)
}

class X2SettingController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: X2SettingControllerDelegate?
    private var wordBrain = WordBrain()
    private var userSelectedHour = 0
    
    private let pickerView = UIPickerView()
    private let saveButton = UIButton()
    private let lastEditLabel = UILabel()
    private let infoLabel = UILabel()
    private let allowNotificationButton = UIButton()
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        checkNotificationAllowed()
        updateInfoLabel()
        style()
        layout()
    }
    
    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 120
        self.view.frame.origin.y =  120
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        super.updateViewConstraints()
    }
    
    //MARK: - Selectors
    
    @objc private func saveButtonPressed(_ sender: UIButton) {
        
        // subtract date from now
        let dateComponents = Calendar.current.dateComponents([.day], from: UserDefault.x2Time.getValue() as! Date, to: Date())
        
        if let dayCount = dateComponents.day {
            
            var title = ""
            var message = ""
            
            if dayCount >= 1 {
                title = "You will earn 2x points for each correct answer between \(wordBrain.hours[userSelectedHour]) hours."
                message = "You can change this feature only once a day."
            } else {
                title = "You can change this feature only once a day."
                message = ""
            }
            
            let alert = UIAlertController(title:  title , message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default) { (action) in
                    if dayCount >= 1 {
                        UserDefault.x2Time.set(Date())
                        let lastEditLabel = Date().getFormattedDate(format: "dd/MM/yyyy, HH:mm")
                        UserDefault.lastEditLabel.set(lastEditLabel)
                        self.lastEditLabel.text = "Last changed on \(lastEditLabel)"
                        UserDefault.userSelectedHour.set(self.userSelectedHour)
                        self.delegate?.x2HourChanged(self.userSelectedHour)
                        self.wordBrain.setNotification()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
            
                if dayCount >= 1 {
                    alert.addAction(actionCancel)
                }
                self.present(alert, animated: true, completion: nil)
            }
        updateInfoLabel()
    }
    
    @objc private func notificationButtonPressed(_ sender: UIButton) {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
    
    //MARK: - Helpers
    
    private func style() {
        view.backgroundColor = Colors.cellLeft
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(UserDefault.userSelectedHour.getInt(), inComponent: 0, animated: true)
        
        saveButton.backgroundColor = .darkGray
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font =  UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setButtonCornerRadius(8)
        saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)),
                             for: .primaryActionTriggered)
        
        lastEditLabel.textColor = Colors.black
        lastEditLabel.textAlignment = .center
        lastEditLabel.numberOfLines = 0
        lastEditLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        lastEditLabel.textColor = Colors.black
        configureLastEditLabel()
        
        infoLabel.textColor = Colors.black
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        infoLabel.textColor = Colors.black
        
        allowNotificationButton.backgroundColor = .darkGray
        allowNotificationButton.setTitle("Allow Notification", for: .normal)
        allowNotificationButton.titleLabel?.font =  UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        allowNotificationButton.setTitleColor(.white, for: .normal)
        allowNotificationButton.setButtonCornerRadius(8)
        allowNotificationButton.addTarget(self, action: #selector(notificationButtonPressed(_:)),
                                          for: .primaryActionTriggered)
    }
    
    private func layout() {
        view.addSubview(pickerView)
        view.addSubview(saveButton)
        view.addSubview(lastEditLabel)
        view.addSubview(infoLabel)
        view.addSubview(allowNotificationButton)
        
        pickerView.centerX(inView: view)
        pickerView.anchor(top: view.topAnchor, paddingTop: 32)
        
        saveButton.anchor(top: pickerView.bottomAnchor, left: view.leftAnchor,
                          right: view.rightAnchor, paddingTop: 16,
                          paddingLeft: 32, paddingRight: 32)
        
        lastEditLabel.anchor(top: saveButton.bottomAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 16,
                             paddingLeft: 32, paddingRight: 32)
        
        infoLabel.anchor(top: lastEditLabel.bottomAnchor, left: view.leftAnchor,
                         right: view.rightAnchor, paddingTop: 16,
                         paddingLeft: 32, paddingRight: 32)
        
        allowNotificationButton.anchor(top: infoLabel.bottomAnchor, left: view.leftAnchor,
                                       right: view.rightAnchor, paddingTop: 16,
                                       paddingLeft: 32, paddingRight: 32)
    }
    
    private func configureLastEditLabel(){
        let lastEdit = UserDefault.lastEditLabel.getString()
        
        if lastEdit != "empty" {
            lastEditLabel.text = "Last changed on \(lastEdit)"
        } else {
            lastEditLabel.text = ""
        }
    }
    
    private func updateInfoLabel(){
        infoLabel.text = "You will earn 2x points for each correct answer between \(wordBrain.hours[UserDefault.userSelectedHour.getInt()])  hours."
    }
    
    private func checkNotificationAllowed() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self.allowNotificationButton.isHidden = true
                }
            } else {
                DispatchQueue.main.async {
                    self.allowNotificationButton.isHidden = false
                }
            }
        }
    }
}

//MARK: - UIPickerViewDataSource

extension X2SettingController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return wordBrain.hours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return wordBrain.hours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: wordBrain.hours[row], attributes: [NSAttributedString.Key.foregroundColor: Colors.black!])
    }
}

//MARK: - UIPickerViewDelegate

extension X2SettingController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        userSelectedHour = row
    }
}
