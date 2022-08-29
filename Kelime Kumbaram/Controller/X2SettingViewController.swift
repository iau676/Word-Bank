//
//  X2ViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 23.03.2022.
//

import UIKit
import CoreData
import UserNotifications

class X2SettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    //MARK: - IBOutlet

    var wordBrain = WordBrain()
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lastEditLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Variables
    
    var onViewWillDisappear:((_ id: Int) -> Void)?
    var userSelectedHour = 0
    let notificationCenter = UNUserNotificationCenter.current()
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
        saveButton.layer.cornerRadius = 8
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(UserDefault.userSelectedHour.getInt(), inComponent: 0, animated: true)
        
        let lastEdit = UserDefault.lastEditLabel.getString()
        
        if lastEdit != "empty" {
            lastEditLabel.text = "Last changed on \(lastEdit)"
        } else {
            lastEditLabel.text = ""
        }
        
        updateInfoLabel()
    }
    

    //MARK: - IBAction
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        // subtract date from now
        let dateComponents = Calendar.current.dateComponents([.day], from: UserDefault.x2Time.getValue() as! Date, to: Date())
        
        if let dayCount = dateComponents.day {
            
            var title = ""
            var message = ""
            
            if dayCount >= 1 {
                title = "You will earn 2x points for each correct answer between \(hours[userSelectedHour]) hours."
                message = "You can change this feature only once a day."
            } else {
                title = "You can change this feature only once a day."
                message = ""
            }
            
            let alert = UIAlertController(title:  title , message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                    if dayCount >= 1 {
                        UserDefault.x2Time.set(Date())
                        let lastEditLabel = Date().getFormattedDate(format: "dd/MM/yyyy, HH:mm")
                        UserDefault.lastEditLabel.set(lastEditLabel)
                        self.lastEditLabel.text = "Last changed on \(lastEditLabel)"
                        UserDefault.userSelectedHour.set(self.userSelectedHour)
                        self.onViewWillDisappear?(self.userSelectedHour)
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
    
    //MARK: - pickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hours.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hours[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("user select \(hours[row])")
        userSelectedHour = row
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: hours[row], attributes: [NSAttributedString.Key.foregroundColor: Colors.black!])
    }
    
    //MARK: - Helpers
    
    override func updateViewConstraints() {
        self.view.frame.size.height = UIScreen.main.bounds.height - 120
        self.view.frame.origin.y =  120
        self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
        super.updateViewConstraints()
    }
    
    func updateInfoLabel(){
        infoLabel.text = "You will earn 2x points for each correct answer between \(hours[UserDefault.userSelectedHour.getInt()])  hours."
    }
    
}


