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
    
    var questionNumber = 0
    var changedQuestionNumber = 0
    var selectedSegmentIndex = 0
    var onlyHereNumber = 0
    var answer = 0
    var firstFalseIndex = -1
    
    var rightOnce = [Int]()
    var rightOnceBool = [Bool]()
    var arrayForResultViewENG = [String]()
    var arrayForResultViewTR = [String]()
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

            rightOnce.append(questionNumber)
            UserDefaults.standard.set(rightOnce, forKey: "rightOnce")
                
        changedQuestionNumber = questionNumber + Int.random(in: 0...9)
        self.selectedSegmentIndex = selectedSegmentIndex
     
        questionNumbersCopy = questionNumbers
        questionNumbersCopy.remove(at: questionNumber)
  
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
            print("segmenttttt")
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
                return selectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
            } else {
                return selectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            }
            
        } else {
            answer = Int.random(in: 0..<questionNumbersCopy.count)
            let temp = questionNumbersCopy[answer]
                 
            if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
                return selectedSegmentIndex == 0 ? itemArray[temp].tr! : itemArray[temp].eng!
            } else {
                return selectedSegmentIndex == 0 ? hardItemArray[temp].tr! : hardItemArray[temp].eng!
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
             trueAnswer = selectedSegmentIndex == 0 ? itemArray[questionNumber].tr! : itemArray[questionNumber].eng!
        } else {
             trueAnswer = selectedSegmentIndex == 0 ? hardItemArray[questionNumber].tr! : hardItemArray[questionNumber].eng!
            
            arrayForResultViewENG.append(hardItemArray[questionNumber].eng ?? "empty")
            UserDefaults.standard.set(arrayForResultViewENG, forKey: "arrayForResultViewENG")
            
            arrayForResultViewTR.append(hardItemArray[questionNumber].tr ?? "empty")
            UserDefaults.standard.set(arrayForResultViewTR, forKey: "arrayForResultViewTR")
           
        }
        
        if userAnswer == trueAnswer {
            //need for result view
            rightOnceBool.append(true)
            UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return true
        } else {
            //need for result view
            rightOnceBool.append(false)
            UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
            UserDefaults.standard.synchronize()
            return false
        }
    }
    
    mutating func arrayForResultView(){
        arrayForResultViewENG.append(hardItemArray[questionNumber].eng ?? "empty")
        UserDefaults.standard.set(arrayForResultViewENG, forKey: "arrayForResultViewENG")
        
        arrayForResultViewTR.append(hardItemArray[questionNumber].tr ?? "empty")
        UserDefaults.standard.set(arrayForResultViewTR, forKey: "arrayForResultViewTR")
    }
    
    mutating func answerTrue(){ // except test option
        rightOnceBool.append(true)
        UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
        UserDefaults.standard.synchronize()
    }
    
    mutating func answerFalse() { // // except test option
        rightOnceBool.append(false)
        UserDefaults.standard.set(rightOnceBool, forKey: "rightOnceBool")
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
        let lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        switch lastPoint {
        case Int(INT16_MIN)..<0:
            UserDefaults.standard.set(0, forKey: "level")
            UserDefaults.standard.set(0-lastPoint, forKey: "needPoint")
            return 0.0
        case 0..<500: //500
            UserDefaults.standard.set(1, forKey: "level")
            UserDefaults.standard.set(500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-0))/Float(500-0)
        case 500..<1100: //600
            UserDefaults.standard.set(2, forKey: "level")
            UserDefaults.standard.set(1100-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-500))/Float(1100-500)
            
        case 1100..<1800: //700
            UserDefaults.standard.set(3, forKey: "level")
            UserDefaults.standard.set(1800-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1100))/Float(1800-1100)
            
        case 1800..<2600: //800
            UserDefaults.standard.set(4, forKey: "level")
            UserDefaults.standard.set(2600-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1800))/Float(2600-1800)
            
        case 2600..<3500: //900
            UserDefaults.standard.set(5, forKey: "level")
            UserDefaults.standard.set(3500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2600))/Float(3500-2600)
            
        case 3500..<4500: //1000
            UserDefaults.standard.set(6, forKey: "level")
            UserDefaults.standard.set(4500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3500))/Float(4500-3500)
            
        case 4500..<5700: //1200
            UserDefaults.standard.set(7, forKey: "level")
            UserDefaults.standard.set(5700-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4500))/Float(5700-4500)
            
        case 5700..<7100: //1400
            UserDefaults.standard.set(8, forKey: "level")
            UserDefaults.standard.set(7100-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5700))/Float(7100-5700)
            
        case 7100..<8700: //1600
            UserDefaults.standard.set(9, forKey: "level")
            UserDefaults.standard.set(8700-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7100))/Float(8700-7100)
            
        case 8700..<10500: //1800
            UserDefaults.standard.set(10, forKey: "level")
            UserDefaults.standard.set(10500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8700))/Float(10500-8700)
            
        case 10500..<12500: //2000
            UserDefaults.standard.set(11, forKey: "level")
            UserDefaults.standard.set(12500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-10500))/Float(12500-10500)
            
        case 12500..<15000: //2500
            UserDefaults.standard.set(12, forKey: "level")
            UserDefaults.standard.set(15000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-12500))/Float(15000-12500)
            
        case 15000..<18000: //3000
            UserDefaults.standard.set(13, forKey: "level")
            UserDefaults.standard.set(18000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-15000))/Float(18000-15000)
            
        case 18000..<21500: //3500
            UserDefaults.standard.set(14, forKey: "level")
            UserDefaults.standard.set(21500-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-18000))/Float(21500-18000)
            
        case 21500..<26000: //4500
            UserDefaults.standard.set(15, forKey: "level")
            UserDefaults.standard.set(26000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-21500))/Float(26000-21500)
            
        case 26000..<32000: //6000
            UserDefaults.standard.set(16, forKey: "level")
            UserDefaults.standard.set(32000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-26000))/Float(32000-26000)
            
        case 32000..<40000: //8000
            UserDefaults.standard.set(17, forKey: "level")
            UserDefaults.standard.set(40000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-32000))/Float(40000-32000)
            
        case 40000..<50000: //10000
            UserDefaults.standard.set(18, forKey: "level")
            UserDefaults.standard.set(50000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-40000))/Float(50000-40000)
            
        case 50000..<62000: //12000
            UserDefaults.standard.set(19, forKey: "level")
            UserDefaults.standard.set(62000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-50000))/Float(62000-50000)
            
        case 62000..<77000: //15000
            UserDefaults.standard.set(20, forKey: "level")
            UserDefaults.standard.set(77000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-62000))/Float(77000-62000)
            
        case 77000..<97000: //20000
            UserDefaults.standard.set(21, forKey: "level")
            UserDefaults.standard.set(97000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-77000))/Float(97000-77000)
            
        case 97000..<120000: //23000
            UserDefaults.standard.set(22, forKey: "level")
            UserDefaults.standard.set(120000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-97000))/Float(120000-97000)
            
        case 120000..<145000: //25000
            UserDefaults.standard.set(23, forKey: "level")
            UserDefaults.standard.set(145000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-120000))/Float(145000-120000)
            
        case 145000..<175000: //30000
            UserDefaults.standard.set(24, forKey: "level")
            UserDefaults.standard.set(175000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-145000))/Float(175000-145000)
            
        case 175000..<210000: //35000
            UserDefaults.standard.set(25, forKey: "level")
            UserDefaults.standard.set(210000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-175000))/Float(210000-175000)
            
        case 210000..<250000: //40000
            UserDefaults.standard.set(26, forKey: "level")
            UserDefaults.standard.set(250000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-210000))/Float(250000-210000)
            
        case 250000..<300000: //50000
            UserDefaults.standard.set(27, forKey: "level")
            UserDefaults.standard.set(300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-250000))/Float(300000-250000)
            
        case 300000..<350000: //50000
            UserDefaults.standard.set(28, forKey: "level")
            UserDefaults.standard.set(350000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-300000))/Float(350000-300000)
            
        case 350000..<400000: //50000
            UserDefaults.standard.set(29, forKey: "level")
            UserDefaults.standard.set(400000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-350000))/Float(400000-350000)
            
        case 400000..<500000: //100000
            UserDefaults.standard.set(30, forKey: "level")
            UserDefaults.standard.set(500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-400000))/Float(500000-400000)
            
        case 500000..<600000: //100000
            UserDefaults.standard.set(31, forKey: "level")
            UserDefaults.standard.set(600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-500000))/Float(600000-500000)
            
        case 600000..<700000: //100000
            UserDefaults.standard.set(32, forKey: "level")
            UserDefaults.standard.set(700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-600000))/Float(700000-600000)
            
        case 700000..<800000: //100000
            UserDefaults.standard.set(33, forKey: "level")
            UserDefaults.standard.set(800000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-700000))/Float(800000-700000)
            
        case 800000..<900000: //100000
            UserDefaults.standard.set(34, forKey: "level")
            UserDefaults.standard.set(900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-800000))/Float(900000-800000)
            
        case 900000..<1000000: //100000
            UserDefaults.standard.set(35, forKey: "level")
            UserDefaults.standard.set(1000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-900000))/Float(1000000-900000)
            
        case 1000000..<1200000: //200000
            UserDefaults.standard.set(36, forKey: "level")
            UserDefaults.standard.set(1200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1000000))/Float(1200000-1000000)
            
        case 1200000..<1400000: //200000
            UserDefaults.standard.set(37, forKey: "level")
            UserDefaults.standard.set(1400000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1200000))/Float(1400000-1200000)
            
        case 1400000..<1600000: //200000
            UserDefaults.standard.set(38, forKey: "level")
            UserDefaults.standard.set(1600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1400000))/Float(1600000-1400000)

            
        case 1600000..<2000000: //200000
            UserDefaults.standard.set(39, forKey: "level")
            UserDefaults.standard.set(2000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-1600000))/Float(2000000-1600000)
            
        case 2000000..<2300000: //300000 //2million
            UserDefaults.standard.set(40, forKey: "level")
            UserDefaults.standard.set(2300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2000000))/Float(2300000-2000000)
            
        case 2300000..<2600000: //300000
            UserDefaults.standard.set(41, forKey: "level")
            UserDefaults.standard.set(2600000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2300000))/Float(2600000-2300000)
            
        case 2600000..<2900000: //300000
            UserDefaults.standard.set(42, forKey: "level")
            UserDefaults.standard.set(2900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2600000))/Float(2900000-2600000)
            
        case 2900000..<3200000: //300000
            UserDefaults.standard.set(43, forKey: "level")
            UserDefaults.standard.set(3200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-2900000))/Float(3200000-2900000)
            
        case 3200000..<3500000: //300000
            UserDefaults.standard.set(44, forKey: "level")
            UserDefaults.standard.set(3500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3200000))/Float(3500000-3200000)
            
        case 3500000..<3800000: //300000
            UserDefaults.standard.set(45, forKey: "level")
            UserDefaults.standard.set(3800000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3500000))/Float(3800000-3500000)
            
        case 3800000..<4100000: //300000
            UserDefaults.standard.set(46, forKey: "level")
            UserDefaults.standard.set(4100000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-3800000))/Float(4100000-3800000)
            
        case 4100000..<4500000: //400000
            UserDefaults.standard.set(47, forKey: "level")
            UserDefaults.standard.set(4500000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4100000))/Float(4500000-4100000)
            
        case 4500000..<4900000: //400000
            UserDefaults.standard.set(48, forKey: "level")
            UserDefaults.standard.set(4900000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4500000))/Float(4900000-4500000)
            
        case 4900000..<5300000: //400000
            UserDefaults.standard.set(49, forKey: "level")
            UserDefaults.standard.set(5300000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-4900000))/Float(5300000-4900000)
            
        case 5300000..<5700000: //400000
            UserDefaults.standard.set(50, forKey: "level")
            UserDefaults.standard.set(5700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5300000))/Float(5700000-5300000)
            
        case 5700000..<6200000: //500000
            UserDefaults.standard.set(51, forKey: "level")
            UserDefaults.standard.set(6200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-5700000))/Float(6200000-5700000)
            
        case 6200000..<6700000: //500000
            UserDefaults.standard.set(52, forKey: "level")
            UserDefaults.standard.set(6700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-6200000))/Float(6700000-6200000)
            
        case 6700000..<7200000: //500000
            UserDefaults.standard.set(53, forKey: "level")
            UserDefaults.standard.set(7200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-6700000))/Float(7200000-6700000)
            
        case 7200000..<7700000: //500000
            UserDefaults.standard.set(54, forKey: "level")
            UserDefaults.standard.set(7700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7200000))/Float(7700000-7200000)
            
        case 7700000..<8200000: //500000
            UserDefaults.standard.set(55, forKey: "level")
            UserDefaults.standard.set(8200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-7700000))/Float(8200000-7700000)
            
        case 8200000..<8700000: //500000
            UserDefaults.standard.set(56, forKey: "level")
            UserDefaults.standard.set(8700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8200000))/Float(8700000-8200000)
            
        case 8700000..<9200000: //500000
            UserDefaults.standard.set(57, forKey: "level")
            UserDefaults.standard.set(9200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-8700000))/Float(9200000-8700000)
            
        case 9200000..<9700000: //500000
            UserDefaults.standard.set(58, forKey: "level")
            UserDefaults.standard.set(9700000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-9200000))/Float(9700000-9200000)
            
        case 9700000..<10200000: //500000
            UserDefaults.standard.set(59, forKey: "level")
            UserDefaults.standard.set(10200000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-9700000))/Float(10200000-9700000)
            
        case 10200000..<11000000: //600000
            UserDefaults.standard.set(60, forKey: "level")
            UserDefaults.standard.set(11000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-10200000))/Float(11000000-10200000)
            
        case 11000000..<12000000: //1000000
            UserDefaults.standard.set(61, forKey: "level")
            UserDefaults.standard.set(12000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-11000000))/Float(12000000-11000000)
            
        case 12000000..<13000000: //1000000
            UserDefaults.standard.set(62, forKey: "level")
            UserDefaults.standard.set(13000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-12000000))/Float(13000000-12000000)
            
        case 13000000..<14000000: //1000000
            UserDefaults.standard.set(63, forKey: "level")
            UserDefaults.standard.set(14000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-13000000))/Float(14000000-13000000)
            
        case 14000000..<15000000: //1000000
            UserDefaults.standard.set(64, forKey: "level")
            UserDefaults.standard.set(15000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-14000000))/Float(15000000-14000000)
            
        case 15000000..<16000000: //1000000
            UserDefaults.standard.set(65, forKey: "level")
            UserDefaults.standard.set(16000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-15000000))/Float(16000000-15000000)
            
        case 16000000..<17000000: //1000000
            UserDefaults.standard.set(66, forKey: "level")
            UserDefaults.standard.set(17000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-16000000))/Float(17000000-16000000)
            
        case 17000000..<18000000: //1000000
            UserDefaults.standard.set(67, forKey: "level")
            UserDefaults.standard.set(18000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-17000000))/Float(18000000-17000000)
            
        case 18000000..<19000000: //1000000
            UserDefaults.standard.set(68, forKey: "level")
            UserDefaults.standard.set(19000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-18000000))/Float(19000000-18000000)
            
        case 19000000..<20000000: //1000000
            UserDefaults.standard.set(69, forKey: "level")
            UserDefaults.standard.set(20000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-19000000))/Float(20000000-19000000)
            
        case 20000000..<22000000: //2000000 //20million
            UserDefaults.standard.set(70, forKey: "level")
            UserDefaults.standard.set(22000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-20000000))/Float(22000000-20000000)
            
        case 22000000..<24000000: //2000000
            UserDefaults.standard.set(71, forKey: "level")
            UserDefaults.standard.set(24000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-22000000))/Float(24000000-22000000)
            
        case 24000000..<26000000: //2000000
            UserDefaults.standard.set(72, forKey: "level")
            UserDefaults.standard.set(26000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-24000000))/Float(26000000-24000000)
            
        case 26000000..<28000000: //2000000
            UserDefaults.standard.set(73, forKey: "level")
            UserDefaults.standard.set(28000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-26000000))/Float(28000000-26000000)
            
        case 28000000..<30000000: //2000000
            UserDefaults.standard.set(74, forKey: "level")
            UserDefaults.standard.set(30000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-28000000))/Float(30000000-28000000)
            
        case 30000000..<32000000: //2000000
            UserDefaults.standard.set(75, forKey: "level")
            UserDefaults.standard.set(32000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-30000000))/Float(32000000-30000000)
            
        case 32000000..<34000000: //2000000
            UserDefaults.standard.set(76, forKey: "level")
            UserDefaults.standard.set(34000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-32000000))/Float(34000000-32000000)
            
        case 34000000..<36000000: //2000000
            UserDefaults.standard.set(77, forKey: "level")
            UserDefaults.standard.set(36000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-34000000))/Float(36000000-34000000)
            
        case 36000000..<38000000: //2000000
            UserDefaults.standard.set(78, forKey: "level")
            UserDefaults.standard.set(38000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-36000000))/Float(38000000-36000000)
            
        case 38000000..<40000000: //2000000
            UserDefaults.standard.set(79, forKey: "level")
            UserDefaults.standard.set(40000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-38000000))/Float(40000000-38000000)
            
        case 40000000..<42000000: //2000000
            UserDefaults.standard.set(80, forKey: "level")
            UserDefaults.standard.set(42000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-40000000))/Float(42000000-40000000)
            
        case 42000000..<44000000: //2000000
            UserDefaults.standard.set(81, forKey: "level")
            UserDefaults.standard.set(44000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-42000000))/Float(44000000-42000000)
            
        case 44000000..<46000000: //2000000
            UserDefaults.standard.set(82, forKey: "level")
            UserDefaults.standard.set(46000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-44000000))/Float(46000000-44000000)
            
        case 46000000..<48000000: //2000000
            UserDefaults.standard.set(83, forKey: "level")
            UserDefaults.standard.set(48000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-46000000))/Float(48000000-46000000)
            
        case 48000000..<49000000: //1000000
            UserDefaults.standard.set(84, forKey: "level")
            UserDefaults.standard.set(49000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-48000000))/Float(49000000-48000000)
            
        case 49000000..<50000000: //1000000
            UserDefaults.standard.set(85, forKey: "level")
            UserDefaults.standard.set(50000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-49000000))/Float(50000000-49000000)
            
        case 50000000..<52000000: //2000000
            UserDefaults.standard.set(86, forKey: "level")
            UserDefaults.standard.set(52000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-50000000))/Float(52000000-50000000)
            
        case 52000000..<54000000: //2000000
            UserDefaults.standard.set(87, forKey: "level")
            UserDefaults.standard.set(54000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-52000000))/Float(54000000-52000000)
            
        case 54000000..<56000000: //2000000
            UserDefaults.standard.set(88, forKey: "level")
            UserDefaults.standard.set(56000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-54000000))/Float(56000000-54000000)
            
        case 56000000..<58000000: //2000000
            UserDefaults.standard.set(89, forKey: "level")
            UserDefaults.standard.set(58000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-56000000))/Float(58000000-56000000)
            
        case 58000000..<60000000: //2000000
            UserDefaults.standard.set(90, forKey: "level")
            UserDefaults.standard.set(60000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-58000000))/Float(60000000-58000000)
            
        case 60000000..<64000000: //4000000
            UserDefaults.standard.set(91, forKey: "level")
            UserDefaults.standard.set(64000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-60000000))/Float(64000000-60000000)
            
        case 64000000..<68000000: //4000000
            UserDefaults.standard.set(92, forKey: "level")
            UserDefaults.standard.set(68000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-64000000))/Float(68000000-64000000)
            
        case 68000000..<72000000: //4000000
            UserDefaults.standard.set(93, forKey: "level")
            UserDefaults.standard.set(72000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-68000000))/Float(72000000-68000000)
            
        case 72000000..<76000000: //4000000
            UserDefaults.standard.set(94, forKey: "level")
            UserDefaults.standard.set(76000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-72000000))/Float(76000000-72000000)
            
        case 76000000..<80000000: //4000000
            UserDefaults.standard.set(95, forKey: "level")
            UserDefaults.standard.set(80000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-76000000))/Float(80000000-76000000)
            
        case 80000000..<85000000: //5000000
            UserDefaults.standard.set(96, forKey: "level")
            UserDefaults.standard.set(85000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-80000000))/Float(85000000-80000000)
            
        case 85000000..<90000000: //5000000
            UserDefaults.standard.set(97, forKey: "level")
            UserDefaults.standard.set(90000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-85000000))/Float(90000000-85000000)
            
        case 90000000..<95000000: //5000000
            UserDefaults.standard.set(98, forKey: "level")
            UserDefaults.standard.set(95000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-90000000))/Float(95000000-90000000)
            
        case 95000000..<100000000: //5000000
            UserDefaults.standard.set(99, forKey: "level")
            UserDefaults.standard.set(100000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-95000000))/Float(100000000-95000000)
            
            
        case 100000000..<676000000:
            UserDefaults.standard.set(100, forKey: "level")
            UserDefaults.standard.set(676000000-lastPoint, forKey: "needPoint")
            return Float((UserDefaults.standard.integer(forKey: "lastPoint")-100000000))/Float(676000000-100000000)
            
        case 676000000..<2147483646:
            UserDefaults.standard.set(676, forKey: "level")
            UserDefaults.standard.set(0, forKey: "needPoint")
            return 1.0

        default:
            UserDefaults.standard.set(0, forKey: "level")
            return 1.0
            
        }
    }
}
