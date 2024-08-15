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
    var changedQuestionNumber = 0
    var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    var addedHardWordsCount = 0
    var questionCounter = 0
    var answer = 0
    
    var rightOnceBooll = [Bool]()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaultWords = [
        Word(e: "hello", t: "merhaba"),
        Word(e: "hello", t: "hola"),
        Word(e: "hello", t: "bonjour"),
        Word(e: "hello", t: "guten tag"),
        Word(e: "hello", t: "salve"),
        Word(e: "hello", t: "konnichiwa")
    ]
    
    let dailyImages: [UIImage?] = [Images.daily1, Images.daily2, Images.daily3, Images.daily4, Images.daily5, Images.daily6, Images.daily7, Images.daily8]
    
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
    
    mutating func addExercise(name: String, type: String, trueCount: Int16, falseCount: Int16, hintCount: Int16){
        let newExercise = Exercise(context: self.context)
        newExercise.name = name
        newExercise.type = type
        newExercise.trueCount = trueCount
        newExercise.falseCount = falseCount
        newExercise.hintCount = hintCount
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
    
    mutating func getQuestionText(_ whichQuestion: Int, _ startPressed:Int, _ exerciseType: String) -> String{
        
        questionNumbers.removeAll()
        loadHardItemArray()
        loadItemArray()

        // these will be return a function
        if exerciseType == ExerciseType.normal {
            if itemArray.count > 20 {
                switch whichQuestion {
                case 0...4:
                    questionNumber = sortedNewWordsDictionary[whichQuestion].key
                    break
                case 5...14:
                    questionNumber = Int.random(in: 0..<itemArray.count)
                    break
                case 15:
                    questionNumber = sortedFailsDictionary[0].key
                    break
                case 16:
                    questionNumber = sortedFailsDictionary[1].key
                    break
                case 17:
                    questionNumber = sortedFailsDictionary[2].key
                    break
                case 18:
                    questionNumber = sortedFailsDictionary[3].key
                    break
                case 19:
                    questionNumber = sortedFailsDictionary[4].key
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
                
        changedQuestionNumber = questionNumber + Int.random(in: 0...9)
     
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
  
        if exerciseType == ExerciseType.normal {
            if startPressed == 1 {
                return selectedTestType == 0 ? itemArray[questionNumber].eng! : itemArray[questionNumber].tr!
            } else {
                return  startPressed == 2 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            }
        } else {
            if startPressed == 1 {
                return selectedTestType == 0 ? hardItemArray[questionNumber].eng! : hardItemArray[questionNumber].tr!
            } else {
                return  startPressed == 2 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
        }
    } //getQuestionText
    
    func getMeaning(exerciseType: String) -> String {
        if exerciseType == ExerciseType.normal {
            return itemArray[questionNumber].tr!
        } else {
            return hardItemArray[questionNumber].tr!
        }
    }
    
    func getEnglish(exerciseType: String) -> String {
        if exerciseType == ExerciseType.normal {
            return itemArray[questionNumber].eng!
        } else {
            return hardItemArray[questionNumber].eng!
        }
    }
        
    mutating func getProgress() -> Float {
        questionCounter += 1
        return Float(questionCounter) / Float(10.0)
    }

    mutating func getAnswer(_ sender: Int, _ exerciseType: String) -> String {
        if changedQuestionNumber % 2 == sender {
            if exerciseType == ExerciseType.normal {
                return selectedTestType == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            } else {
                return selectedTestType == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
        } else {
            if questionNumbersCopy.count > 0 {
                answer = Int.random(in: 0..<questionNumbersCopy.count)
                let temp = questionNumbersCopy[answer]
                     
                if exerciseType == ExerciseType.normal {
                    return selectedTestType == 0 ? itemArray[temp].tr! : itemArray[temp].eng!
                } else {
                    return selectedTestType == 0 ? hardItemArray[temp].tr! : hardItemArray[temp].eng!
                }
            } else {
                return ""
            }
        }
    }
    
    mutating func getListeningAnswers(_ exerciseType: String) -> (String, String, String, String) {
        let answer1 = getListeningAnswer(for: questionNumber, exerciseType)
        let answer2 = getListeningAnswer(for: Int.random(in: 0..<questionNumbersCopy.count), exerciseType)
        let answer3 = getListeningAnswer(for: Int.random(in: 0..<questionNumbersCopy.count), exerciseType)
        let array = [answer1, answer2, answer3].shuffled()
        
        return (array[0], array[1], array[2], answer1)
    }
    
    private func getListeningAnswer(for number: Int, _ exerciseType: String) -> String {
        return exerciseType == ExerciseType.normal ?
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
    
    func getHour() {
        UserDefault.currentHour.set(Calendar.current.component(.hour, from: Date()))
    }
    
    func getCurrentHour() -> Int {
        return Int(Calendar.current.component(.hour, from: Date()))
    }
    
    func getTodayDate() -> String{
        return Date().getFormattedDate(format: "yyyy-MM-dd")
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

//MARK: - User Defaults

extension WordBrain {
    func isUserWillGetDailyPrize() -> Bool {
        if UserDefault.userGotDailyPrize.getString() == "willGet" {
            return true
        } else {
            return false
        }
    }
    
    func isUserGotWheelPrize() -> Bool {
        if UserDefault.userGotWheelPrize.getString() == getTodayDate() {
            return true
        } else {
            return false
        }
    }
    
    func getTruePointImage() -> UIImage? {
        return (UserDefault.selectedPointEffect.getInt() == 0) ? Images.greenBubble : Images.greenCircle
    }
    
    func getFalsePointImage() -> UIImage? {
        return (UserDefault.selectedPointEffect.getInt() == 0) ? Images.redBubble : Images.redCircle
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

//MARK: - Daily Exercise Info

extension WordBrain {
    mutating func findExercisesCompletedToday(){
        loadExerciseArray()
        exerciseDict.removeAll()
        let todayDate = getTodayDate()
        let exerciseArrayCount = (exerciseArray.count > 5760) ? 5760 : exerciseArray.count //24*60*4
        for i in 0..<exerciseArrayCount {
            let exerciseDate = exerciseArray[i].date?.getFormattedDate(format: "yyyy-MM-dd") ?? ""
            let exerciseName = exerciseArray[i].name ?? ""
            if exerciseDate == todayDate {
                exerciseDict.updateValue((exerciseDict[exerciseName] ?? 0)+1, forKey: exerciseName)
            }
        }
    }
    
    func getExerciseCountToday(for exerciseFormat: String) -> Int {
        return exerciseDict[exerciseFormat] ?? 0
    }
        
    mutating func updateTabBarDailyImage(){
        findExercisesCompletedToday()
        
        let testExerciseCount = getExerciseCountToday(for: ExerciseFormat.test) >= 10 ? 1 : 0
        let writingExerciseCount = getExerciseCountToday(for: ExerciseFormat.writing) >= 10 ? 10 : 0
        let listeningExerciseCount = getExerciseCountToday(for: ExerciseFormat.listening) >= 10 ? 100 : 0
        
        switch testExerciseCount + writingExerciseCount + listeningExerciseCount {
        case 0:
            UserDefault.dailyImageIndex.set(0)
        case 1:
            UserDefault.dailyImageIndex.set(1)
        case 10:
            UserDefault.dailyImageIndex.set(2)
        case 100:
            UserDefault.dailyImageIndex.set(3)
        case 11:
            UserDefault.dailyImageIndex.set(4)
        case 101:
            UserDefault.dailyImageIndex.set(5)
        case 110:
            UserDefault.dailyImageIndex.set(6)
        case 111:
            UserDefault.dailyImageIndex.set(7)
        default: break
        }
    }
}
