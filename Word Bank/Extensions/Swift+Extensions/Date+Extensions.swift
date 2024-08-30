//
//  Date+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 19.07.2022.
//

import Foundation

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getTodayDate() -> String {
        self.getFormattedDate(format: DateFormats.yyyyMMdd)
    }
}
