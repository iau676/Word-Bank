//
//  Item+Extensions.swift
//  Word Bank
//
//  Created by ibrahim uysal on 8.09.2024.
//

import Foundation
import CoreData

extension Item {
    
    static func exists(context: NSManagedObjectContext, eng: String) -> Bool {
        
        let request = Item.fetchRequest()
        request.predicate = NSPredicate(format: "eng == %@", eng)
        
        do {
            let results = try context.fetch(request)
            return !results.isEmpty
        } catch {
            return false
        }
    }
    
}
