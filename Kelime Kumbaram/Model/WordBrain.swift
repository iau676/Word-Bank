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
    
    var questionNumbers: [Int] = []
    var questionNumbersCopy: [Int] = []
    
    var startPressed = UserDefaultsManager(key: "startPressed")
    var whichButton = UserDefaultsManager(key: "whichButton")
    var setNotificationFirstTime = UserDefaultsManager(key: "setNotificationFirstTime")
    var userWordCount = UserDefaultsManager(key: "userWordCount")
    var x2Time = UserDefaultsManager(key: "2xTime")
    var userSelectedHour = UserDefaultsManager(key: "userSelectedHour")
    var lastEditLabel = UserDefaultsManager(key: "lastEditLabel")
    
    var level = UserDefaultsManager(key: "level")
    var needPoint = UserDefaultsManager(key: "needPoint")
    var goLevelUp = UserDefaultsManager(key: "goLevelUp")
    var lastPoint = UserDefaultsManager(key: "lastPoint")
    var selectedSegmentIndex = UserDefaultsManager(key: "selectedSegmentIndex")
    var soundSpeed = UserDefaultsManager(key: "soundSpeed")
    var playSound = UserDefaultsManager(key: "playSound")
    var playAppSound = UserDefaultsManager(key: "playAppSound")
    var textSize = UserDefaultsManager(key: "textSize")
    var lastHour = UserDefaultsManager(key: "lastHour")
    var pointForMyWords = UserDefaultsManager(key: "pointForMyWords")
    var userAnswers = UserDefaultsManager(key: "userAnswers")
    var failNumber = UserDefaultsManager(key: "failNumber")
    var failIndex = UserDefaultsManager(key: "failIndex")
    var hardWordsCount = UserDefaultsManager(key: "hardWordsCount")
    
    var blueExerciseCount = UserDefaultsManager(key: "blueExerciseCount")
    var blueTrueCount = UserDefaultsManager(key: "blueTrueCount")
    var blueFalseCount = UserDefaultsManager(key: "blueFalseCount")
    
    var engEdit = UserDefaultsManager(key: "engEdit")
    var trEdit = UserDefaultsManager(key: "trEdit")
    
    var rightOnce = UserDefaultsManager(key: "rightOnce")
    var rightOnceBool = UserDefaultsManager(key: "rightOnceBool")
    var arrayForResultViewENG = UserDefaultsManager(key: "arrayForResultViewENG")
    var arrayForResultViewTR = UserDefaultsManager(key: "arrayForResultViewTR")
    var blueAllTrue = UserDefaultsManager(key: "blueAllTrue")
    
    var start1count = UserDefaultsManager(key: "start1count")
    var start2count = UserDefaultsManager(key: "start2count")
    var start3count = UserDefaultsManager(key: "start3count")
    var start4count = UserDefaultsManager(key: "start4count")
    
    var questionNumber = 0
    var changedQuestionNumber = 0
    var userSelectedSegmentIndex = 0
    var onlyHereNumber = 0
    var answer = 0
    var firstFalseIndex = -1
    
    var rightOncee = [Int]()
    var rightOnceBooll = [Bool]()
    var arrayForResultViewENGG = [String]()
    var arrayForResultViewTRR = [String]()
    var isWordAddedToHardWords = 0
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hardItemArray = [HardItem]()
    var quizCoreDataArray = [AddedList]()
    
    var itemArray = [Item]()
    
    var failsDictionary =  [Int:Int]()
    var sortedFailsDictionary = Array<(key: Int, value: Int)>()
    
    let defaultWords = [

        Word(e: "hello", t: "merhaba"),
        Word(e: "world", t: "dünya")

    ]
    
    let pageStatistic = ["\(UserDefaults.standard.integer(forKey: "blueExerciseCount")) defa alıştırma yaptınız", "\(UserDefaults.standard.integer(forKey: "blueAllTrue")) alıştırmayı hepsini doğru yaparak tamamladınız" ,"\(UserDefaults.standard.integer(forKey: "blueTrueCount")) defa doğru cevap verdiniz", "\(UserDefaults.standard.integer(forKey: "blueFalseCount")) defa yanlış cevap verdiniz"]

    
    mutating func sortFails(){
        for i in 0..<itemArray.count {
            let j = itemArray[i].falseCount - itemArray[i].trueCount
            failsDictionary.updateValue(Int(j), forKey: i)
        }
         sortedFailsDictionary = failsDictionary.sorted {
            return $0.value > $1.value
        }
    }
    
    mutating func addNewWord(english: String, meaning: String){
        let newItem = Item(context: self.context)
        newItem.eng = english
        newItem.tr = meaning
        newItem.date = Date()
        newItem.uuid = UUID().uuidString
        newItem.isCreatedFromUser = true
        self.itemArray.append(newItem)
    }
    
    mutating func removeWord(at index: Int){
        itemArray.remove(at: index)
    }
    
    mutating func getQuestionText(_ selectedSegmentIndex: Int, _ whichQuestion: Int, _ startPressed:Int) -> String {
        
        questionNumbers.removeAll()
        
        loadHardItemArray()
        loadItemArray()

        // these will be return a function
                if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
                    
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
                        default:
                            print("nothing#getQuestionText")
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

                        default:
                            print("nothing#getQuestionText")
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
            UserDefaults.standard.set(rightOncee, forKey: "rightOnce")
                
        changedQuestionNumber = questionNumber + Int.random(in: 0...9)
        self.userSelectedSegmentIndex = selectedSegmentIndex
     
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
  
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
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
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
            return itemArray[questionNumber].eng!
        } else {
            return hardItemArray[questionNumber].eng!
        }
    }
    
    func getQuestionNumber() -> Int {
        return questionNumber
    }

    func getOriginalList() -> String {
        return hardItemArray[questionNumber].originalList!
    }
    
    func getQuestionTextForSegment() -> String
    {
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
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
            if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
                return userSelectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            } else {
                return userSelectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
        } else {
            if questionNumbersCopy.count > 0 {
                answer = Int.random(in: 0..<questionNumbersCopy.count)
                let temp = questionNumbersCopy[answer]
                     
                if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
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
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
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
        //print("####HardItemArray>>\(HardItemArray)")
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
             trueAnswer = userSelectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
        } else {
             trueAnswer = userSelectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            
            arrayForResultViewENGG.append(hardItemArray[questionNumber].eng ?? "empty")
            UserDefaults.standard.set(arrayForResultViewENGG, forKey: "arrayForResultViewENG")
            
            arrayForResultViewTRR.append(hardItemArray[questionNumber].tr ?? "empty")
            UserDefaults.standard.set(arrayForResultViewTRR, forKey: "arrayForResultViewTR")
           
        }
        
        if userAnswer == trueAnswer {
            //need for result view
            rightOnceBooll.append(true)
            UserDefaults.standard.set(rightOnceBooll, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return true
        } else {
            //need for result view
            rightOnceBooll.append(false)
            UserDefaults.standard.set(rightOnceBooll, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    mutating func arrayForResultView(){
        arrayForResultViewENGG.append(hardItemArray[questionNumber].eng ?? "empty")
        UserDefaults.standard.set(arrayForResultViewENGG, forKey: "arrayForResultViewENG")
        
        arrayForResultViewTRR.append(hardItemArray[questionNumber].tr ?? "empty")
        UserDefaults.standard.set(arrayForResultViewTRR, forKey: "arrayForResultViewTR")
    }
    
    mutating func answerTrue(){ // except test option
        rightOnceBooll.append(true)
        UserDefaults.standard.set(rightOnceBooll, forKey: "rightOnceBool")
        UserDefaults.standard.synchronize()
    }
    
    mutating func answerFalse() { // // except test option
        rightOnceBooll.append(false)
        UserDefaults.standard.set(rightOnceBooll, forKey: "rightOnceBool")
        UserDefaults.standard.synchronize()
    }
    
    
    mutating func addHardWords(_ index: Int) {
 
            loadItemArray()
            
                let newItem = HardItem(context: context)
                newItem.eng = itemArray[index].eng
                newItem.tr = itemArray[index].tr
                newItem.uuid = itemArray[index].uuid
                newItem.originalindex = Int32(index)
                newItem.date = Date()
                newItem.correctNumber = 5
                hardItemArray.append(newItem)
                itemArray[index].addedHardWords = true
                let hardWordsCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
                UserDefaults.standard.set(hardWordsCount+1, forKey: "hardWordsCount")
        
        
            saveWord()
    }
    
    mutating func updateRightCountHardWords() -> Bool {
                
        let i = hardItemArray[questionNumber].correctNumber
        hardItemArray[questionNumber].correctNumber = i - 1
        
        let originalindex = hardItemArray[questionNumber].originalindex

        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[questionNumber].uuid}) {
            itemm.trueCount += 1
        } else {
           // item could not be found
        }
            
        if hardItemArray[questionNumber].correctNumber <= 0 {
            
            if itemArray.count > Int(originalindex) {
                if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[questionNumber].uuid}) {
                    itemm.addedHardWords = false
                } else {
                   // item could not be found
                }
            }
            
            context.delete(hardItemArray[questionNumber])
            hardItemArray.remove(at: questionNumber)
            
            let hardWordsCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
            UserDefaults.standard.set(hardWordsCount-1, forKey: "hardWordsCount")
        }
        saveWord()
        return hardItemArray.count < 2 ? true : false
    }
    
    func updateWrongCountHardWords(){

        if let itemm = itemArray.first(where: {$0.uuid == hardItemArray[questionNumber].uuid}) {
            itemm.falseCount += 1
        } else {
           // item could not be found
        }
        saveWord()
    }
    
    func updateTrueCountMyWords(){
        itemArray[questionNumber].trueCount += 1
        saveWord()
    }
    
    mutating func userGotItWrong() {
        
        //print("BlueFalse-\( quizCoreDataArray[questionNumber].falseCount)")

        itemArray[questionNumber].falseCount += 1
        
        // if word didn't added to hard words
        if itemArray[questionNumber].addedHardWords == false{
            let newItem = HardItem(context: context)
            newItem.eng = itemArray[questionNumber].eng
            newItem.tr = itemArray[questionNumber].tr
            newItem.uuid = itemArray[questionNumber].uuid
            newItem.originalindex = Int32(questionNumber)
            newItem.originalList = "MyWords"
            newItem.date = Date()
            newItem.correctNumber = 5
            hardItemArray.append(newItem)
            
            isWordAddedToHardWords = isWordAddedToHardWords + 1
            
            // the word ADD to hard words
            itemArray[questionNumber].addedHardWords = true
            let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
            UserDefaults.standard.set(lastCount+1, forKey: "hardWordsCount")
        }
        saveWord()
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
    
    func saveWord() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func calculateLevel() -> Float {
        let lastSavedPoint = lastPoint.getInt()
        switch lastSavedPoint {
        case Int(INT16_MIN)..<0:
            level.set(0)
            needPoint.set(0-lastSavedPoint)
            return 0.0
        case 0..<500: //500
            level.set(1)
            needPoint.set(500-lastSavedPoint)
            return Float(lastSavedPoint-0)/Float(500-0)
        case 500..<1_100: //600
            level.set(2)
            needPoint.set(1_100-lastSavedPoint)
            return Float(lastSavedPoint-500)/Float(1_100-500)
            
        case 1_100..<1_800: //700
            level.set(3)
            needPoint.set(1_800-lastSavedPoint)
            return Float(lastSavedPoint-1_100)/Float(1_800-1_100)
            
        case 1_800..<2_600: //800
            level.set(4)
            needPoint.set(2_600-lastSavedPoint)
            return Float(lastSavedPoint-1_800)/Float(2_600-1_800)
            
        case 2_600..<3_500: //900
            level.set(5)
            needPoint.set(3_500-lastSavedPoint)
            return Float(lastSavedPoint-2_600)/Float(3_500-2_600)
            
        case 3_500..<4_500: //1000
            level.set(6)
            needPoint.set(4_500-lastSavedPoint)
            return Float(lastSavedPoint-3_500)/Float(4_500-3_500)
            
        case 4_500..<5_700: //1200
            level.set(7)
            needPoint.set(5_700-lastSavedPoint)
            return Float(lastSavedPoint-4_500)/Float(5_700-4_500)
            
        case 5_700..<7_100: //1400
            level.set(8)
            needPoint.set(7_100-lastSavedPoint)
            return Float(lastSavedPoint-5_700)/Float(7_100-5_700)
            
        case 7_100..<8_700: //1600
            level.set(9)
            needPoint.set(8_700-lastSavedPoint)
            return Float(lastSavedPoint-7_100)/Float(8_700-7_100)
            
        case 8_700..<10_500: //1800
            level.set(10)
            needPoint.set(10_500-lastSavedPoint)
            return Float(lastSavedPoint-8_700)/Float(10_500-8_700)
            
        case 10_500..<12_500: //2000
            level.set(11)
            needPoint.set(12_500-lastSavedPoint)
            return Float(lastSavedPoint-10_500)/Float(12_500-10_500)
            
        case 12_500..<15_000: //2500
            level.set(12)
            needPoint.set(15_000-lastSavedPoint)
            return Float(lastSavedPoint-12_500)/Float(15_000-12_500)
            
        case 15_000..<18_000: //3000
            level.set(13)
            needPoint.set(18_000-lastSavedPoint)
            return Float(lastSavedPoint-15_000)/Float(18_000-15_000)
            
        case 18_000..<21_500: //3500
            level.set(14)
            needPoint.set(21_500-lastSavedPoint)
            return Float(lastSavedPoint-18_000)/Float(21_500-18_000)
            
        case 21_500..<26_000: //4500
            level.set(15)
            needPoint.set(26_000-lastSavedPoint)
            return Float(lastSavedPoint-21_500)/Float(26_000-21_500)
            
        case 26_000..<32_000: //6000
            level.set(16)
            needPoint.set(32_000-lastSavedPoint)
            return Float(lastSavedPoint-26_000)/Float(32_000-26_000)
            
        case 32_000..<40_000: //8000
            level.set(17)
            needPoint.set(40_000-lastSavedPoint)
            return Float(lastSavedPoint-32_000)/Float(40_000-32_000)
            
        case 40_000..<50_000: //10000
            level.set(18)
            needPoint.set(50_000-lastSavedPoint)
            return Float(lastSavedPoint-40_000)/Float(50_000-40_000)
            
        case 50_000..<62_000: //12000
            level.set(19)
            needPoint.set(62_000-lastSavedPoint)
            return Float(lastSavedPoint-50_000)/Float(62_000-50_000)
            
        case 62_000..<77_000: //15000
            level.set(20)
            needPoint.set(77_000-lastSavedPoint)
            return Float(lastSavedPoint-62_000)/Float(77_000-62_000)
            
        case 77_000..<97_000: //20000
            level.set(21)
            needPoint.set(97_000-lastSavedPoint)
            return Float(lastSavedPoint-77_000)/Float(97_000-77_000)
            
        case 97_000..<120_000: //23000
            level.set(22)
            needPoint.set(120_000-lastSavedPoint)
            return Float(lastSavedPoint-97_000)/Float(120_000-97_000)
            
        case 120_000..<145_000: //25000
            level.set(23)
            needPoint.set(145_000-lastSavedPoint)
            return Float(lastSavedPoint-120_000)/Float(145_000-120_000)
            
        case 145_000..<175_000: //30000
            level.set(24)
            needPoint.set(175_000-lastSavedPoint)
            return Float(lastSavedPoint-145_000)/Float(175_000-145_000)
            
        case 175_000..<210_000: //35000
            level.set(25)
            needPoint.set(210_000-lastSavedPoint)
            return Float(lastSavedPoint-175_000)/Float(210_000-175_000)
            
        case 210_000..<250_000: //40000
            level.set(26)
            needPoint.set(250_000-lastSavedPoint)
            return Float(lastSavedPoint-210_000)/Float(250_000-210_000)
            
        case 250_000..<300_000: //50000
            level.set(27)
            needPoint.set(300_000-lastSavedPoint)
            return Float(lastSavedPoint-250_000)/Float(300_000-250_000)
            
        case 300_000..<350_000: //50000
            level.set(28)
            needPoint.set(350_000-lastSavedPoint)
            return Float(lastSavedPoint-300_000)/Float(350_000-300_000)
            
        case 350_000..<400_000: //50000
            level.set(29)
            needPoint.set(400_000-lastSavedPoint)
            return Float(lastSavedPoint-350_000)/Float(400_000-350_000)
            
        case 400_000..<500_000: //100000
            level.set(30)
            needPoint.set(500_000-lastSavedPoint)
            return Float(lastSavedPoint-400_000)/Float(500_000-400_000)
            
        case 500_000..<600_000: //100000
            level.set(31)
            needPoint.set(600_000-lastSavedPoint)
            return Float(lastSavedPoint-500_000)/Float(600_000-500_000)
            
        case 600_000..<700_000: //100000
            level.set(32)
            needPoint.set(700_000-lastSavedPoint)
            return Float(lastSavedPoint-600_000)/Float(700_000-600_000)
            
        case 700_000..<800_000: //100000
            level.set(33)
            needPoint.set(800_000-lastSavedPoint)
            return Float(lastSavedPoint-700_000)/Float(800_000-700_000)
            
        case 800_000..<900_000: //100000
            level.set(34)
            needPoint.set(900_000-lastSavedPoint)
            return Float(lastSavedPoint-800_000)/Float(900_000-800_000)
            
        case 900_000..<1_000_000: //100000
            level.set(35)
            needPoint.set(1_000_000-lastSavedPoint)
            return Float(lastSavedPoint-900_000)/Float(1_000_000-900_000)
            
        case 1_000_000..<1_200_000: //200000
            level.set(36)
            needPoint.set(1_200_000-lastSavedPoint)
            return Float(lastSavedPoint-1_000_000)/Float(1_200_000-1_000_000)
            
        case 1_200_000..<1_400_000: //200000
            level.set(37)
            needPoint.set(1_400_000-lastSavedPoint)
            return Float(lastSavedPoint-1_200_000)/Float(1_400_000-1_200_000)
            
        case 1_400_000..<1_600_000: //200000
            level.set(38)
            needPoint.set(1_600_000-lastSavedPoint)
            return Float(lastSavedPoint-1_400_000)/Float(1_600_000-1_400_000)
            
        case 1_600_000..<2_000_000: //200000
            level.set(39)
            needPoint.set(2_000_000-lastSavedPoint)
            return Float(lastSavedPoint-1_600_000)/Float(2_000_000-1_600_000)
            
        case 2_000_000..<2_300_000: //300000 //2million
            level.set(40)
            needPoint.set(2_300_000-lastSavedPoint)
            return Float(lastSavedPoint-2_000_000)/Float(2_300_000-2_000_000)
            
        case 2_300_000..<2_600_000: //300000
            level.set(41)
            needPoint.set(2_600_000-lastSavedPoint)
            return Float(lastSavedPoint-2_300_000)/Float(2_600_000-2_300_000)
            
        case 2_600_000..<2_900_000: //300000
            level.set(42)
            needPoint.set(2_900_000-lastSavedPoint)
            return Float(lastSavedPoint-2_600_000)/Float(2_900_000-2_600_000)
            
        case 2_900_000..<3_200_000: //300000
            level.set(43)
            needPoint.set(3_200_000-lastSavedPoint)
            return Float(lastSavedPoint-2_900_000)/Float(3_200_000-2_900_000)
            
        case 3_200_000..<3_500_000: //300000
            level.set(44)
            needPoint.set(3_500_000-lastSavedPoint)
            return Float(lastSavedPoint-3_200_000)/Float(3_500_000-3_200_000)
            
        case 3_500_000..<3_800_000: //300000
            level.set(45)
            needPoint.set(3_800_000-lastSavedPoint)
            return Float(lastSavedPoint-3_500_000)/Float(3_800_000-3_500_000)
            
        case 3_800_000..<4_100_000: //300000
            level.set(46)
            needPoint.set(4_100_000-lastSavedPoint)
            return Float(lastSavedPoint-3_800_000)/Float(4_100_000-3_800_000)
            
        case 4_100_000..<4_500_000: //400000
            level.set(47)
            needPoint.set(4_500_000-lastSavedPoint)
            return Float(lastSavedPoint-4_100_000)/Float(4_500_000-4_100_000)
            
        case 4_500_000..<4_900_000: //400000
            level.set(48)
            needPoint.set(4_900_000-lastSavedPoint)
            return Float(lastSavedPoint-4_500_000)/Float(4_900_000-4_500_000)
            
        case 4_900_000..<5_300_000: //400000
            level.set(49)
            needPoint.set(5_300_000-lastSavedPoint)
            return Float(lastSavedPoint-4_900_000)/Float(5_300_000-4_900_000)
            
        case 5_300_000..<5_700_000: //400000
            level.set(50)
            needPoint.set(5_700_000-lastSavedPoint)
            return Float(lastSavedPoint-5_300_000)/Float(5_700_000-5_300_000)
            
        case 5_700_000..<6_200_000: //500000
            level.set(51)
            needPoint.set(6_200_000-lastSavedPoint)
            return Float(lastSavedPoint-5_700_000)/Float(6_200_000-5_700_000)
            
        case 6_200_000..<6_700_000: //500000
            level.set(52)
            needPoint.set(6_700_000-lastSavedPoint)
            return Float(lastSavedPoint-6_200_000)/Float(6_700_000-6_200_000)
            
        case 6_700_000..<7_200_000: //500000
            level.set(53)
            needPoint.set(7_200_000-lastSavedPoint)
            return Float(lastSavedPoint-6_700_000)/Float(7_200_000-6_700_000)
            
        case 7_200_000..<7_700_000: //500000
            level.set(54)
            needPoint.set(7_700_000-lastSavedPoint)
            return Float(lastSavedPoint-7_200_000)/Float(7_700_000-7_200_000)
            
        case 7_700_000..<8_200_000: //500000
            level.set(55)
            needPoint.set(8_200_000-lastSavedPoint)
            return Float(lastSavedPoint-7_700_000)/Float(8_200_000-7_700_000)
            
        case 8_200_000..<8_700_000: //500000
            level.set(56)
            needPoint.set(8_700_000-lastSavedPoint)
            return Float(lastSavedPoint-8_200_000)/Float(8_700_000-8_200_000)
            
        case 8_700_000..<9_200_000: //500000
            level.set(57)
            needPoint.set(9_200_000-lastSavedPoint)
            return Float(lastSavedPoint-8_700_000)/Float(9_200_000-8_700_000)
            
        case 9_200_000..<9_700_000: //500000
            level.set(58)
            needPoint.set(9_700_000-lastSavedPoint)
            return Float(lastSavedPoint-9_200_000)/Float(9_700_000-9_200_000)
            
        case 9_700_000..<10_200_000: //500000
            level.set(59)
            needPoint.set(10_200_000-lastSavedPoint)
            return Float(lastSavedPoint-9_700_000)/Float(10_200_000-9_700_000)
            
        case 10_200_000..<11_000_000: //600000
            level.set(60)
            needPoint.set(11_000_000-lastSavedPoint)
            return Float(lastSavedPoint-10_200_000)/Float(11_000_000-10_200_000)
            
        case 11_000_000..<12_000_000: //1000000
            level.set(61)
            needPoint.set(12_000_000-lastSavedPoint)
            return Float(lastSavedPoint-11_000_000)/Float(12_000_000-11_000_000)
            
        case 12_000_000..<13_000_000: //1000000
            level.set(62)
            needPoint.set(13_000_000-lastSavedPoint)
            return Float(lastSavedPoint-12_000_000)/Float(13_000_000-12_000_000)
            
        case 13_000_000..<14_000_000: //1000000
            level.set(63)
            needPoint.set(14_000_000-lastSavedPoint)
            return Float(lastSavedPoint-13_000_000)/Float(14_000_000-13_000_000)
            
        case 14_000_000..<15_000_000: //1000000
            level.set(64)
            needPoint.set(15_000_000-lastSavedPoint)
            return Float(lastSavedPoint-14_000_000)/Float(15_000_000-14_000_000)
            
        case 15_000_000..<16_000_000: //1000000
            level.set(65)
            needPoint.set(16_000_000-lastSavedPoint)
            return Float(lastSavedPoint-15_000_000)/Float(16_000_000-15_000_000)
            
        case 16_000_000..<17_000_000: //1000000
            level.set(66)
            needPoint.set(17_000_000-lastSavedPoint)
            return Float(lastSavedPoint-16_000_000)/Float(17_000_000-16_000_000)
            
        case 17_000_000..<18_000_000: //1000000
            level.set(67)
            needPoint.set(18_000_000-lastSavedPoint)
            return Float(lastSavedPoint-17_000_000)/Float(18_000_000-17_000_000)
            
        case 18_000_000..<19_000_000: //1000000
            level.set(68)
            needPoint.set(19_000_000-lastSavedPoint)
            return Float(lastSavedPoint-18_000_000)/Float(19_000_000-18_000_000)
            
        case 19_000_000..<20_000_000: //1000000
            level.set(69)
            needPoint.set(20_000_000-lastSavedPoint)
            return Float(lastSavedPoint-19_000_000)/Float(20_000_000-19_000_000)
            
        case 20_000_000..<22_000_000: //2000000 //20million
            level.set(70)
            needPoint.set(22_000_000-lastSavedPoint)
            return Float(lastSavedPoint-20_000_000)/Float(22_000_000-20_000_000)
            
        case 22_000_000..<24_000_000: //2000000
            level.set(71)
            needPoint.set(24_000_000-lastSavedPoint)
            return Float(lastSavedPoint-22_000_000)/Float(24_000_000-22_000_000)
            
        case 24_000_000..<26_000_000: //2000000
            level.set(72)
            needPoint.set(26_000_000-lastSavedPoint)
            return Float(lastSavedPoint-24_000_000)/Float(26_000_000-24_000_000)
            
        case 26_000_000..<28_000_000: //2000000
            level.set(73)
            needPoint.set(28_000_000-lastSavedPoint)
            return Float(lastSavedPoint-26_000_000)/Float(28_000_000-26_000_000)
            
        case 28_000_000..<30_000_000: //2000000
            level.set(74)
            needPoint.set(30_000_000-lastSavedPoint)
            return Float(lastSavedPoint-28_000_000)/Float(30_000_000-28_000_000)
            
        case 30_000_000..<32_000_000: //2000000
            level.set(75)
            needPoint.set(32_000_000-lastSavedPoint)
            return Float(lastSavedPoint-30_000_000)/Float(32_000_000-30_000_000)
            
        case 32_000_000..<34_000_000: //2000000
            level.set(76)
            needPoint.set(34_000_000-lastSavedPoint)
            return Float(lastSavedPoint-32_000_000)/Float(34_000_000-32_000_000)
            
        case 34_000_000..<36_000_000: //2000000
            level.set(77)
            needPoint.set(36_000_000-lastSavedPoint)
            return Float(lastSavedPoint-34_000_000)/Float(36_000_000-34_000_000)
            
        case 36_000_000..<38_000_000: //2000000
            level.set(78)
            needPoint.set(38_000_000-lastSavedPoint)
            return Float(lastSavedPoint-36_000_000)/Float(38_000_000-36_000_000)
            
        case 38_000_000..<40_000_000: //2000000
            level.set(79)
            needPoint.set(40_000_000-lastSavedPoint)
            return Float(lastSavedPoint-38_000_000)/Float(40_000_000-38_000_000)
            
        case 40_000_000..<42_000_000: //2000000
            level.set(80)
            needPoint.set(42_000_000-lastSavedPoint)
            return Float(lastSavedPoint-40_000_000)/Float(42_000_000-40_000_000)
            
        case 42_000_000..<44_000_000: //2000000
            level.set(81)
            needPoint.set(44_000_000-lastSavedPoint)
            return Float(lastSavedPoint-42_000_000)/Float(44_000_000-42_000_000)
            
        case 44_000_000..<46_000_000: //2000000
            level.set(82)
            needPoint.set(46_000_000-lastSavedPoint)
            return Float(lastSavedPoint-44_000_000)/Float(46_000_000-44_000_000)
            
        case 46_000_000..<48_000_000: //2000000
            level.set(83)
            needPoint.set(48_000_000-lastSavedPoint)
            return Float(lastSavedPoint-46_000_000)/Float(48_000_000-46_000_000)
            
        case 48_000_000..<49_000_000: //1000000
            level.set(84)
            needPoint.set(49_000_000-lastSavedPoint)
            return Float(lastSavedPoint-48_000_000)/Float(49_000_000-48_000_000)
            
        case 49_000_000..<50_000_000: //1000000
            level.set(85)
            needPoint.set(50_000_000-lastSavedPoint)
            return Float(lastSavedPoint-49_000_000)/Float(50_000_000-49_000_000)
            
        case 50_000_000..<52_000_000: //2000000
            level.set(86)
            needPoint.set(52_000_000-lastSavedPoint)
            return Float(lastSavedPoint-50_000_000)/Float(52_000_000-50_000_000)
            
        case 52_000_000..<54_000_000: //2000000
            level.set(87)
            needPoint.set(54_000_000-lastSavedPoint)
            return Float(lastSavedPoint-52_000_000)/Float(54_000_000-52_000_000)
            
        case 54_000_000..<56_000_000: //2000000
            level.set(88)
            needPoint.set(56_000_000-lastSavedPoint)
            return Float(lastSavedPoint-54_000_000)/Float(56_000_000-54_000_000)
            
        case 56_000_000..<58_000_000: //2000000
            level.set(89)
            needPoint.set(58_000_000-lastSavedPoint)
            return Float(lastSavedPoint-56_000_000)/Float(58_000_000-56_000_000)
            
        case 58_000_000..<60_000_000: //2000000
            level.set(90)
            needPoint.set(60_000_000-lastSavedPoint)
            return Float(lastSavedPoint-58_000_000)/Float(60_000_000-58_000_000)
            
        case 60_000_000..<64_000_000: //4000000
            level.set(91)
            needPoint.set(64_000_000-lastSavedPoint)
            return Float(lastSavedPoint-60_000_000)/Float(64_000_000-60_000_000)
            
        case 64_000_000..<68_000_000: //4000000
            level.set(92)
            needPoint.set(68_000_000-lastSavedPoint)
            return Float(lastSavedPoint-64_000_000)/Float(68_000_000-64_000_000)
            
        case 68_000_000..<72_000_000: //4000000
            level.set(93)
            needPoint.set(72_000_000-lastSavedPoint)
            return Float(lastSavedPoint-68_000_000)/Float(72_000_000-68_000_000)
            
        case 72_000_000..<76_000_000: //4000000
            level.set(94)
            needPoint.set(76_000_000-lastSavedPoint)
            return Float(lastSavedPoint-72_000_000)/Float(76_000_000-72_000_000)
            
        case 76_000_000..<80_000_000: //4000000
            level.set(95)
            needPoint.set(80_000_000-lastSavedPoint)
            return Float(lastSavedPoint-76_000_000)/Float(80_000_000-76_000_000)
            
        case 80_000_000..<85_000_000: //5000000
            level.set(96)
            needPoint.set(85_000_000-lastSavedPoint)
            return Float(lastSavedPoint-80_000_000)/Float(85_000_000-80_000_000)
            
        case 85_000_000..<90_000_000: //5000000
            level.set(97)
            needPoint.set(90_000_000-lastSavedPoint)
            return Float(lastSavedPoint-85_000_000)/Float(90_000_000-85_000_000)
            
        case 90_000_000..<95_000_000: //5000000
            level.set(98)
            needPoint.set(95_000_000-lastSavedPoint)
            return Float(lastSavedPoint-90_000_000)/Float(95_000_000-90_000_000)
            
        case 95_000_000..<100_000_000: //5000000
            level.set(99)
            needPoint.set(100_000_000-lastSavedPoint)
            return Float(lastSavedPoint-95_000_000)/Float(100_000_000-95_000_000)
            
        case 100_000_000..<676_000_000:
            level.set(100)
            needPoint.set(676_000_000-lastSavedPoint)
            return Float(lastSavedPoint-100_000_000)/Float(676_000_000-100_000_000)
            
        case 676_000_000..<2_147_483_646:
            level.set(676)
            needPoint.set(0)
            return 1.0

        default:
            level.set(0)
            return 1.0
            
        }
    }
}
