//
//  UserDefaultManager.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 26.07.2022.
//

import UIKit

struct UserDefaultsManager {
    
    // MARK: - Unique Key
    
    let key: String
    
    // MARK: - Storing Data
    
    func set(_ value: Any) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Get Data
    
    func getValue() -> Any? {
        UserDefaults.standard.object(forKey: key)
    }
    
    func getInt() -> Int {
        UserDefaults.standard.integer(forKey: key)
    }
    
    func getString() -> String {
        UserDefaults.standard.string(forKey: key) ?? "empty"
    }
    
    func getDouble() -> Double {
        UserDefaults.standard.double(forKey: key)
    }
    
    func getCGFloat() -> CGFloat {
        CGFloat(UserDefaults.standard.integer(forKey: key))
    }
    
    // MARK: - Deleting Data
    
    func deleteValue() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
