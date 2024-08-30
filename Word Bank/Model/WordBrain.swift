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
    
    static var shared = WordBrain()
    private init() {}
        
    var itemArray = [Item]()
    var hardItemArray = [HardItem]()
    var user = [User]()
    var exerciseArray = [Exercise]()
    
    var sortedFailsDictionary = Array<(key: Int, value: Int)>()
    var sortedNewWordsDictionary = Array<(key: Int, value: Int)>()
    
    var questionNumber = 0
    var questionCounter = 0
    var addedHardWordsCount = 0
    var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    
    mutating func createUser() {
        CoreDataManager.shared.createUser()
        loadUser()
    }

    mutating func addWord(english: String, meaning: String){
        CoreDataManager.shared.addWord(english: english, meaning: meaning)
        loadItemArray()
    }
    
    mutating func addExercise(type: ExerciseType, kind: ExerciseKind, trueCount: Int16, falseCount: Int16){
        CoreDataManager.shared.addExercise(type: type, kind: kind, trueCount: trueCount, falseCount: falseCount)
    }
    
    mutating func removeWord(at index: Int) {
        let item = itemArray[index]
        CoreDataManager.shared.removeWord(item)
        loadItemArray()
    }
    
    mutating func addWordToHardWords(_ index: Int) {
        let item = itemArray[questionNumber]
        CoreDataManager.shared.addWordToHardWords(item)
        addedHardWordsCount = addedHardWordsCount + 1
    }
    
    mutating func clearAddedHardWordsCount() {
        addedHardWordsCount = 0
        UserDefault.addedHardWordsCount.set(0)
    }
    
    func updateHardItem(_ item: Item?, newEng: String, newMeaning: String) {
        CoreDataManager.shared.updateHardItem(item, newEng: newEng, newMeaning: newMeaning)
    }
    
    mutating func updateCorrectCountHardWord() -> Bool {
        CoreDataManager.shared.updateCorrectCountHardWord(questionNumber)
        loadHardItemArray()
        return hardItemArray.count < 2 ? true : false
    }
    
    func updateWrongCountHardWords() {
        CoreDataManager.shared.updateWrongCountHardWords(questionNumber)
    }
    
    func userGotItCorrect() {
        let item = itemArray[questionNumber]
        CoreDataManager.shared.userGotItCorrect(item)
    }
    
    mutating func userGotItWrong() {
        let item = itemArray[questionNumber]
        CoreDataManager.shared.userGotItWrong(item)
    }
    
    mutating func loadHardItemArray() {
        hardItemArray = CoreDataManager.shared.loadHardItemArray()
    }
    
    mutating func loadItemArray(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        itemArray = CoreDataManager.shared.loadItemArray(with: request)
    }
    
    mutating func loadUser() {
        user = CoreDataManager.shared.loadUser()
    }
    
    mutating func loadExerciseArray() {
        exerciseArray = CoreDataManager.shared.loadExerciseArray()
    }
    
    mutating func sortWordsForExercise() {
        var failsDictionary = [Int:Int]()
        var newWordsDictionary = [Int:Int]()
        
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
        loadHardItemArray()
        loadItemArray()

        if exerciseKind == .normal {
            if itemArray.count > totalQuestionNumber {
                switch counter {
                case 0...3:  questionNumber = sortedNewWordsDictionary[counter].key
                case 4...7: questionNumber = sortedFailsDictionary[counter-4].key
                case 8...9: questionNumber = Int.random(in: 0..<itemArray.count)
                default: break
                }
            } else {
                questionNumber = Int.random(in: 0..<itemArray.count)
            }
        } else {
            questionNumber = Int.random(in: 0..<hardItemArray.count)
        }
        
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
    }

    mutating func getTestAnswer(exerciseKind: ExerciseKind) -> (String, String) {
        var questionNumbersCopy = exerciseKind == .normal ? Array(itemArray.indices) : Array(hardItemArray.indices)
        questionNumbersCopy.remove(at: questionNumber)
        
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
        var questionNumbersCopy = exerciseKind == .normal ? Array(itemArray.indices) : Array(hardItemArray.indices)
        questionNumbersCopy.remove(at: questionNumber)
        
        let randomNumber1 = questionNumbersCopy.randomElement() ?? 0
        let deleteIndex = questionNumbersCopy.firstIndex(where: {$0 == randomNumber1}) ?? 0
        questionNumbersCopy.remove(at: deleteIndex)
        
        let randomNumber2 = questionNumbersCopy.randomElement() ?? 0
        
        let answer1 = getListeningAnswer(for: questionNumber, exerciseKind)
        let answer2 = getListeningAnswer(for: randomNumber1, exerciseKind)
        let answer3 = getListeningAnswer(for: randomNumber2, exerciseKind)
        let array = [answer1, answer2, answer3].shuffled()
        
        return (array[0], array[1], array[2], answer1)
    }
    
    private func getListeningAnswer(for number: Int, _ exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ? itemArray[number].eng! : hardItemArray[number].eng!
    }
    
    func getMeaning(exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ? itemArray[questionNumber].tr! : hardItemArray[questionNumber].tr!
    }
    
    func getEnglish(exerciseKind: ExerciseKind) -> String {
        return exerciseKind == .normal ? itemArray[questionNumber].eng! : hardItemArray[questionNumber].eng!
    }
}
