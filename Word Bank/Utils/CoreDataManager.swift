//
//  CoreDataManager.swift
//  Word Bank
//
//  Created by ibrahim uysal on 30.08.2024.
//

import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createUser() {
        let newUser = User(context: self.context)
        newUser.date = Date()
        newUser.uuid = UUID().uuidString
        saveContext()
    }
    
    func addWord(english: String, meaning: String) {
        let newItem = Item(context: self.context)
        newItem.eng = english
        newItem.tr = meaning
        newItem.date = Date()
        newItem.uuid = UUID().uuidString
        newItem.isCreatedFromUser = true
        saveContext()
    }
    
    func addExercise(type: ExerciseType, kind: ExerciseKind, trueCount: Int16, falseCount: Int16) {
        let newExercise = Exercise(context: self.context)
        newExercise.name = type.description //test writing...
        newExercise.type = kind.description //normal hard
        newExercise.trueCount = trueCount
        newExercise.falseCount = falseCount
        newExercise.date = Date()
        newExercise.uuid = UUID().uuidString
        saveContext()
    }
    
    func removeWord(_ item: Item) { 
        context.delete(item)
        saveContext()
    }
    
    func addWordToHardWords(_ item: Item) {
        let newItem = HardItem(context: context)
        newItem.eng = item.eng
        newItem.tr = item.tr
        newItem.uuid = item.uuid
        newItem.date = Date()
        newItem.correctNumber = 5
        
        item.addedHardWords = true
    
        saveContext()
    }
    
    func deleteHardWord(_ item: Item) {
        let hardItemArray = loadHardItemArray()
        hardItemArray.forEach { hardItem in
            if hardItem.uuid == item.uuid {
                context.delete(hardItem)
            }
        }
        saveContext()
    }
    
    func updateHardItem(_ item: Item?, newEng: String, newMeaning: String) {
        let hardItemArray = loadHardItemArray()
        guard let itemm = item else { return }
        hardItemArray.forEach { hardItem in
            if hardItem.uuid == itemm.uuid {
                hardItem.eng = newEng
                hardItem.tr = newMeaning
            }
        }
        saveContext()
    }
    
    func updateCorrectCountHardWord(_ index: Int) {
        let itemArray = loadItemArray()
        let hardItemArray = loadHardItemArray()
        
        hardItemArray[index].correctNumber -= 1
        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[index].uuid}) {
            itemm.trueCount += 1
            if hardItemArray[index].correctNumber <= 0 {
                if itemArray.count > index {
                    itemm.addedHardWords = false
                }
                context.delete(hardItemArray[index])
            }
        } else {
            context.delete(hardItemArray[index])
        }
        saveContext()
    }
    
    func updateWrongCountHardWords(_ index: Int) {
        let itemArray = loadItemArray()
        let hardItemArray = loadHardItemArray()
        
        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[index].uuid}) {
            itemm.falseCount += 1
        }
        saveContext()
    }
    
    func userGotItCorrect(_ item: Item) {
        item.trueCount += 1
        saveContext()
    }
    
    func userGotItWrong(_ item: Item) {
        item.falseCount += 1
        if item.addedHardWords == false {
            addWordToHardWords(item)
        }
        saveContext()
    }
    
    func loadHardItemArray(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()) -> [HardItem] {
        var hardItems = [HardItem]()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            hardItems = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        
        return hardItems
    }
    
    func loadItemArray(with request: NSFetchRequest<Item> = Item.fetchRequest()) -> [Item] {
        var items = [Item]()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            items = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        
        return items
    }
    
    func loadUser(with request: NSFetchRequest<User> = User.fetchRequest()) -> [User] {
        var users = [User]()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            users = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        
        return users
    }
    
    func loadExerciseArray(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest()) -> [Exercise] {
        var exercises = [Exercise]()
        
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            exercises = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        
        return exercises
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
}
