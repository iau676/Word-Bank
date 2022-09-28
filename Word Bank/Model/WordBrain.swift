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
    
    static let shareInstance = WordBrain()
    
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    var failsDictionary =  [Int:Int]()
    var sortedFailsDictionary = Array<(key: Int, value: Int)>()
    
    var questionNumber = 0
    var changedQuestionNumber = 0
    var userSelectedSegmentIndex = 0
    var isWordAddedToHardWords = 0
    var onlyHereNumber = 0
    var answer = 0
    var firstFalseIndex = -1
    
    var rightOncee = [Int]()
    var rightOnceBooll = [Bool]()
    var arrayForResultViewENGG = [String]()
    var arrayForResultViewTRR = [String]()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaultWords = [
//        Word(e: "hello", t: "merhaba"),
//        Word(e: "world", t: "dünya")
        Word(e: "1", t: "11"),
        Word(e: "2", t: "22"),
        Word(e: "3", t: "33"),
        Word(e: "4", t: "44")
    ]
    
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
        
        isWordAddedToHardWords = isWordAddedToHardWords + 1
        
        itemArray[index].addedHardWords = true
        let lastCount = UserDefault.hardWordsCount.getInt()
        UserDefault.hardWordsCount.set(lastCount+1)
    
        saveContext()
    }
    
    mutating func sortFails(){
        for i in 0..<itemArray.count {
            let j = itemArray[i].falseCount - itemArray[i].trueCount
            failsDictionary.updateValue(Int(j), forKey: i)
        }
         sortedFailsDictionary = failsDictionary.sorted {
            return $0.value > $1.value
        }
    }
    
    mutating func getQuestionText(_ selectedSegmentIndex: Int, _ whichQuestion: Int, _ startPressed:Int) -> String {
        
        questionNumbers.removeAll()
        loadHardItemArray()
        loadItemArray()

        // these will be return a function
        if UserDefault.whichButton.getString() == "blue" {
                    
                    if itemArray.count > 200 {
                        switch whichQuestion {
                        case 0...9:
                            questionNumber = Int.random(in: 100..<itemArray.count)
                            break
                        case 9...19:
                            questionNumber = Int.random(in: 0...100)
                            break
                        case 20:
                            questionNumber = sortedFailsDictionary[0].key
                            break
                        case 21:
                            questionNumber = sortedFailsDictionary[1].key
                            break
                        case 22:
                            questionNumber = sortedFailsDictionary[2].key
                            break
                        case 23:
                            questionNumber = sortedFailsDictionary[3].key
                            break
                        case 24:
                            questionNumber = sortedFailsDictionary[4].key
                            break
                        default: break
                        }
                    } else {
                        switch whichQuestion {
                        case 0...22:
                            questionNumber = Int.random(in: 0..<itemArray.count)
                            break
                        case 23:
                            questionNumber = sortedFailsDictionary[0].key
                            break
                        case 24:
                            questionNumber = sortedFailsDictionary[1].key
                            break
                        default: break
                        }
                    }
                    for i in 0..<itemArray.count {
                        questionNumbers.append(i)
                    }
                } else {
                    //print("<*>\(HardItemArray)")
                    questionNumber = Int.random(in: 0..<hardItemArray.count)
                    for i in 0..<hardItemArray.count {
                        questionNumbers.append(i)
                    }
                 
                }
            rightOncee.append(questionNumber)
        UserDefault.rightOnce.set(rightOncee)
                
        changedQuestionNumber = questionNumber + Int.random(in: 0...9)
        userSelectedSegmentIndex = selectedSegmentIndex
     
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
  
        if UserDefault.whichButton.getString() == "blue" {
            if startPressed == 1 {
                return selectedSegmentIndex == 0 ? itemArray[questionNumber].eng! : itemArray[questionNumber].tr!
            } else {
                return  startPressed == 2 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            }
        } else {
            if startPressed == 1 {
                return selectedSegmentIndex == 0 ? hardItemArray[questionNumber].eng! : hardItemArray[questionNumber].tr!
            } else {
                return  startPressed == 2 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
        }
    } //getQuestionText
    
    func getAnswer() -> String{
        if UserDefault.whichButton.getString() == "blue" {
            return itemArray[questionNumber].eng!
        } else {
            return hardItemArray[questionNumber].eng!
        }
    }

    mutating func getIsWordAddedToHardWords() -> Int {
        return isWordAddedToHardWords
    }
    
    mutating func getProgress() -> Float {
        onlyHereNumber += 1
        return Float(onlyHereNumber) / Float(25.0)
    }

    mutating func getAnswer(_ sender: Int) -> String {
        if changedQuestionNumber % 2 == sender {
            if UserDefault.whichButton.getString() == "blue" {
                return userSelectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            } else {
                return userSelectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
        } else {
            if questionNumbersCopy.count > 0 {
                answer = Int.random(in: 0..<questionNumbersCopy.count)
                let temp = questionNumbersCopy[answer]
                     
                if UserDefault.whichButton.getString() == "blue" {
                    return userSelectedSegmentIndex == 0 ? itemArray[temp].tr! : itemArray[temp].eng!
                } else {
                    return userSelectedSegmentIndex == 0 ? hardItemArray[temp].tr! : hardItemArray[temp].eng!
                }
            } else {
                return ""
            }
        }
    }
    
    mutating func nextQuestion() {
        if UserDefault.whichButton.getString() == "blue" {
            if questionNumber + 1 < itemArray.count {
                questionNumber += 1
            } else {
                questionNumber = 0
            }
        } else {
            if questionNumber + 1 < hardItemArray.count {
                questionNumber += 1
            } else {
                questionNumber = 0
            }
        }
   }
    
    mutating func checkAnswer(userAnswer: String) -> Bool {
        var trueAnswer = ""
        if UserDefault.whichButton.getString() == "blue" {
             trueAnswer = userSelectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
        } else {
             trueAnswer = userSelectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            
            arrayForResultViewENGG.append(hardItemArray[questionNumber].eng ?? "empty")
            UserDefault.arrayForResultViewENG.set(arrayForResultViewENGG)
            
            arrayForResultViewTRR.append(hardItemArray[questionNumber].tr ?? "empty")
            UserDefault.arrayForResultViewTR.set(arrayForResultViewTRR)
        }
        
        if userAnswer == trueAnswer {
            //need for result view
            rightOnceBooll.append(true)
            UserDefault.rightOnceBool.set(rightOnceBooll)
            UserDefaults.standard.synchronize()
            return true
        } else {
            //need for result view
            rightOnceBooll.append(false)
            UserDefault.rightOnceBool.set(rightOnceBooll)
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    mutating func arrayForResultView(){
        arrayForResultViewENGG.append(hardItemArray[questionNumber].eng ?? "empty")
        UserDefault.arrayForResultViewENG.set(arrayForResultViewENGG)
        
        arrayForResultViewTRR.append(hardItemArray[questionNumber].tr ?? "empty")
        UserDefault.arrayForResultViewTR.set(arrayForResultViewTRR)
    }
    
    mutating func answerTrue(){ // except test option
        rightOnceBooll.append(true)
        UserDefault.rightOnceBool.set(rightOnceBooll)
        UserDefaults.standard.synchronize()
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
                UserDefault.hardWordsCount.set(UserDefault.hardWordsCount.getInt()-1)
            }
        } else {
            context.delete(hardItemArray[questionNumber])
            hardItemArray.remove(at: questionNumber)
            UserDefault.hardWordsCount.set(UserDefault.hardWordsCount.getInt()-1)
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
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
}
