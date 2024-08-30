//
//  WordBrain.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import Foundation
import UIKit
import CoreData

struct WordBrain {
        
    var itemArray = [Item]()
    var hardItemArray = [HardItem]()
    var user = [User]()
    var exerciseArray = [Exercise]()
    var exerciseDict = [String: Int]()
    
    static var shared = WordBrain()
    
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    var failsDictionary = [Int:Int]()
    var newWordsDictionary = [Int:Int]()
    var sortedFailsDictionary = Array<(key: Int, value: Int)>()
    var sortedNewWordsDictionary = Array<(key: Int, value: Int)>()
    
    var questionNumber = 0
    var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    var addedHardWordsCount = 0
    var questionCounter = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func createUser(){
        let newUser = User(context: self.context)
        newUser.date = Date()
        newUser.uuid = UUID().uuidString
        saveContext()
    }

    mutating func addWord(english: String, meaning: String){
        let newItem = Item(context: self.context)
        newItem.eng = english
        newItem.tr = meaning
        newItem.date = Date()
        newItem.uuid = UUID().uuidString
        newItem.isCreatedFromUser = true
        self.itemArray.append(newItem)
        saveContext()
    }
    
    mutating func addExercise(type: ExerciseType, kind: ExerciseKind, trueCount: Int16, falseCount: Int16){
        let newExercise = Exercise(context: self.context)
        newExercise.name = type.description //test writing...
        newExercise.type = kind.description //normal hard
        newExercise.trueCount = trueCount
        newExercise.falseCount = falseCount
        newExercise.date = Date()
        newExercise.uuid = UUID().uuidString
        self.exerciseArray.append(newExercise)
        saveContext()
    }
    
    mutating func removeWord(at index: Int){
        context.delete(itemArray[index])
        itemArray.remove(at: index)
        saveContext()
    }
    
    mutating func addWordToHardWords(_ index: Int) {
        loadItemArray()
        
        let newItem = HardItem(context: context)
        newItem.eng = itemArray[index].eng
        newItem.tr = itemArray[index].tr
        newItem.uuid = itemArray[index].uuid
        newItem.date = Date()
        newItem.correctNumber = 5
        hardItemArray.append(newItem)
        
        addedHardWordsCount = addedHardWordsCount + 1
        UserDefault.addedHardWordsCount.set(addedHardWordsCount)
        
        itemArray[index].addedHardWords = true
    
        saveContext()
    }
    
    mutating func deleteHardWord(_ item: Item) {
        self.hardItemArray.forEach { hardItem in
            if hardItem.uuid == item.uuid {
                context.delete(hardItem)
            }
        }
        saveContext()
    }
    
    func updateHardItem(_ item: Item?, newEng: String, newMeaning: String) {
        guard let itemm = item else { return }
        self.hardItemArray.forEach { hardItem in
            if hardItem.uuid == itemm.uuid {
                hardItem.eng = newEng
                hardItem.tr = newMeaning
            }
        }
        saveContext()
    }
    
    mutating func sortWordsForExercise() {
        for i in 0..<itemArray.count {
            let j = itemArray[i].falseCount - itemArray[i].trueCount
            failsDictionary.updateValue(Int(j), forKey: i)
            let k = itemArray[i].falseCount + itemArray[i].trueCount
            newWordsDictionary.updateValue(Int(k), forKey: i)
        }
         sortedFailsDictionary = failsDictionary.sorted {
            return $0.value > $1.value
        }
         sortedNewWordsDictionary = newWordsDictionary.sorted {
           return $0.value < $1.value
       }
    }
    
    mutating func getQuestionText(_ counter: Int, _ exerciseKind: ExerciseKind, _ exerciseType: ExerciseType) -> String{
        questionNumbers.removeAll()
        loadHardItemArray()
        loadItemArray()

        if exerciseKind == .normal {
            if itemArray.count > totalQuestionNumber {
                switch counter {
                case 0...3:
                    questionNumber = sortedNewWordsDictionary[counter].key
                    break
                case 4:
                    questionNumber = sortedFailsDictionary[0].key
                    break
                case 5:
                    questionNumber = sortedFailsDictionary[1].key
                    break
                case 6:
                    questionNumber = sortedFailsDictionary[2].key
                    break
                case 7:
                    questionNumber = sortedFailsDictionary[3].key
                    break
                case 8...9:
                    questionNumber = Int.random(in: 0..<itemArray.count)
                    break
                default: break
                }
            } else {
                questionNumber = Int.random(in: 0..<itemArray.count)
            }
            for i in 0..<itemArray.count {
                questionNumbers.append(i)
            }
        } else {
            questionNumber = Int.random(in: 0..<hardItemArray.count)
            for i in 0..<hardItemArray.count {
                questionNumbers.append(i)
            }
        }
        
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
        
        switch (exerciseKind, exerciseType) {
        case (.normal, .test):
            return selectedTestType == 0 ? itemArray[questionNumber].eng! : itemArray[questionNumber].tr!
        case (.normal, .writing):
            return itemArray[questionNumber].tr!
        case (.normal, .listening):
             return itemArray[questionNumber].eng!
        case (.hard, .test):
            return selectedTestType == 0 ? hardItemArray[questionNumber].eng! : hardItemArray[questionNumber].tr!
        case (.hard, .writing):
            return  hardItemArray[questionNumber].tr!
        case (.hard, .listening):
            return hardItemArray[questionNumber].eng!
        default: return ""
        }
    } //getQuestionText

    func getMeaning(exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ? itemArray[questionNumber].tr! : hardItemArray[questionNumber].tr!
    }
    
    func getEnglish(exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ? itemArray[questionNumber].eng! : hardItemArray[questionNumber].eng!
    }
    
    mutating func getTestAnswer(exerciseKind: ExerciseKind) -> (String, String) {
        let temp = questionNumbersCopy.randomElement() ?? 0
        var trueAnswer = ""
        var falseAnswer = ""
        
        if exerciseKind == .normal {
            trueAnswer = selectedTestType == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            falseAnswer = selectedTestType == 0 ? itemArray[temp].tr! : itemArray[temp].eng!
        } else {
            trueAnswer = selectedTestType == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            falseAnswer = selectedTestType == 0 ? hardItemArray[temp].tr! : hardItemArray[temp].eng!
        }
        
        let array = [trueAnswer, falseAnswer].shuffled()
        return (array[0], array[1])
    }
    
    mutating func getListeningAnswers(_ exerciseKind: ExerciseKind) -> (String, String, String, String) {
        let answer1 = getListeningAnswer(for: questionNumber, exerciseKind)
        let answer2 = getListeningAnswer(for: Int.random(in: 0..<questionNumbersCopy.count), exerciseKind)
        let answer3 = getListeningAnswer(for: Int.random(in: 0..<questionNumbersCopy.count), exerciseKind)
        let array = [answer1, answer2, answer3].shuffled()
        
        return (array[0], array[1], array[2], answer1)
    }
    
    private func getListeningAnswer(for number: Int, _ exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ?
        itemArray[number].eng! :
        hardItemArray[number].eng!
    }
    
    mutating func updateCorrectCountHardWord() -> Bool {
        hardItemArray[questionNumber].correctNumber -= 1
        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[questionNumber].uuid}) {
            itemm.trueCount += 1
            if hardItemArray[questionNumber].correctNumber <= 0 {
                if itemArray.count > questionNumber {
                    itemm.addedHardWords = false
                }
                context.delete(hardItemArray[questionNumber])
                hardItemArray.remove(at: questionNumber)
            }
        } else {
            context.delete(hardItemArray[questionNumber])
            hardItemArray.remove(at: questionNumber)
        }
        saveContext()
        return hardItemArray.count < 2 ? true : false
    }
    
    func updateWrongCountHardWords(){
        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[questionNumber].uuid}) {
            itemm.falseCount += 1
        }
        saveContext()
    }
    
    func userGotItCorrect(){
        itemArray[questionNumber].trueCount += 1
        saveContext()
    }
    
    mutating func userGotItWrong() {
        itemArray[questionNumber].falseCount += 1
        if itemArray[questionNumber].addedHardWords == false{
            addWordToHardWords(questionNumber)
        }
        saveContext()
    }
    
    mutating func loadHardItemArray(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            hardItemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadItemArray(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadUser(with request: NSFetchRequest<User> = User.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            user = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    mutating func loadExerciseArray(with request: NSFetchRequest<Exercise> = Exercise.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            exerciseArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
}

//MARK: - Card Exercise

extension WordBrain {
    mutating func getWordEnglish() -> String {
        questionNumber = Int.random(in: 0..<itemArray.count)
        return itemArray[questionNumber].eng ?? ""
    }
    
    func getWordMeaning() -> String {
        return itemArray[questionNumber].tr ?? ""
    }
    
    func getQuestionNumber() -> Int {
        return questionNumber
    }
}
