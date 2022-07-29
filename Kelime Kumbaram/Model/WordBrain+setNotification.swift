//
//  WordBrain+setNotification.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 29.07.2022.
//

import UIKit
import UserNotifications

extension WordBrain {
    
    func setNotification(){
        DispatchQueue.main.async{
            let title = "2x Time 🎉"
            let message = "You will earn 2x points for every correct answer for an hour!"
            
                let content = UNMutableNotificationContent()
                content.title = title
                content.body = message
                
                // let date = DateComponents(hour: 23, minute: 44)
                let date = DateComponents(hour: userSelectedHour.getInt(), minute: 00)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                let id = UUID().uuidString
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                self.notificationCenter.removeAllPendingNotificationRequests()
                
                self.notificationCenter.add(request) { (error) in
                    if(error != nil){
                        print("Error " + error.debugDescription)
                        return
                    }
                }
                print("id>>\(id)")
        }
    }
}
