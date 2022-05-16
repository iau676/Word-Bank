//
//  X2ViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 23.03.2022.
//

import UIKit
import CoreData
import UserNotifications


class X2ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    
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

    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var lastEditLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    
    var onViewWillDisappear:((_ id: Int) -> Void)?
    
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
    
    var userSelectedHour = 0
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        saveButton.layer.cornerRadius = 8
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.selectRow(UserDefaults.standard.integer(forKey: "userSelectedHour"), inComponent: 0, animated: true)
        
        let lastEdit = UserDefaults.standard.string(forKey: "lastEditLabel") ?? "empty"
        
        if lastEdit != "empty" {
            lastEditLabel.text = "En son \(lastEdit) tarihinde değiştirildi."
        } else {
            lastEditLabel.text = ""
        }
        
        updateInfoLabel()
        
    }
    
    override func updateViewConstraints() {
                self.view.frame.size.height = UIScreen.main.bounds.height - 120
                self.view.frame.origin.y =  120
                self.view.roundCorners(corners: [.topLeft, .topRight], radius: 16.0)
                super.updateViewConstraints()
    }
    
    func updateInfoLabel(){
        infoLabel.text = "\(hours[UserDefaults.standard.integer(forKey: "userSelectedHour")]) saatleri arasında her doğru cevap için 2x puan kazanacaksınız."
    }

    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        print("userSelectedHour>\(userSelectedHour)")
        

        // subtract date from now
        let dateComponents = Calendar.current.dateComponents([.day], from: UserDefaults.standard.object(forKey: "2xTime") as! Date, to: Date())
        
        

        if let dayCount = dateComponents.day {
            
                print("daysCount>>\(dayCount)")
            
            var title = ""
            var message = ""
            
            if dayCount >= 1 {
                title = "\(hours[userSelectedHour]) saatleri arasında 2x puan kazanacaksınız"
                message = "Bu özelliği günde sadece bir defa değiştirebilirsiniz."
            } else {
                title = "Bu özelliği günde sadece bir defa değiştirebilirsiniz."
                message = ""
            }
            
            
            let alert = UIAlertController(title:  title , message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                    // what will happen once user clicks the add item button on UIAlert
                    
                    if dayCount >= 1 {
                        UserDefaults.standard.set(Date(), forKey: "2xTime")
                       
                        let lastEditLabel = Date().getFormattedDate(format: "dd/MM/yyyy, HH:mm")
                        UserDefaults.standard.set(lastEditLabel, forKey: "lastEditLabel")
                        self.lastEditLabel.text = "En son \(lastEditLabel) tarihinde değiştirildi."
                        
                        UserDefaults.standard.set(self.userSelectedHour, forKey: "userSelectedHour")
                        self.onViewWillDisappear?(self.userSelectedHour)
                        
                        self.setNotification()
                    }
          
                    self.dismiss(animated: true, completion: nil)
                }
                let actionCancel = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel) { (action) in
                    // what will happen once user clicks the cancel item button on UIAlert
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
    
    
    func setNotification(){
            
            DispatchQueue.main.async
            {
                let title = "2x Saati 🎉"
                let message = "Bir saat boyunca her doğru cevap için 2x puan kazanacaksınız!"
                
             
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                
                    
                let date = DateComponents(hour: self.userSelectedHour, minute: 00)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    
                    let id = UUID().uuidString
                    
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
                    
                    self.notificationCenter.removeAllPendingNotificationRequests()
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    print("selected new date")
            }
    }
    
    
}
extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
 }
