//
//  Constants.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 2.08.2022.
//

import UIKit

enum Colors {
    static let darkBackground            = UIColor(white: 0.1, alpha: 0.4)
    static let black                     = UIColor(hex: "#1C1C1C")
    static let cellRight                 = UIColor(hex: "#F5F5F5")
    static let cellLeft                  = UIColor(hex: "#DFDEDE")
    static let blueBottom                = UIColor(hex: "#88D1F0")
    static let yyellow                   = UIColor(hex: "#FFC047")
    static let yellowBottom              = UIColor(hex: "#FFD387")
    static let purple                    = UIColor(hex: "#af52de")
    static let green                     = UIColor(hex: "#17bf8c")
    static let blue                      = UIColor(hex: "#1cbaeb")
    static let yellow                    = UIColor(hex: "#ffbf47")
    static let purpleShadow              = UIColor(hex: "#9527cc")
    static let greenShadow               = UIColor(hex: "#129970")
    static let blueShadow                = UIColor(hex: "#1299bf")
    static let yellowShadow              = UIColor(hex: "#ffa808")
    static let pink                      = UIColor(hex: "#fc8da5")
    static let d6d6d6                    = UIColor(hex: "#d6d6d6")
    static let f6f6f6                    = UIColor(hex: "#f6f6f6")
    static let testAnswerLayer           = UIColor(hex: "#47668f")
    static let red                       = UIColor(hex: "#eb5c70")
    static let raven                     = UIColor(hex: "#323d5a")
    static let ravenShadow               = UIColor(hex: "#293047")
    static let lightBlue                 = UIColor(hex: "#759ecc")
    static let lightGreen                = UIColor(hex: "#70dbba")
    static let lightRed                  = UIColor(hex: "#ff8f9e")
    static let darkGrayShadow            = UIColor(hex: "#444444")
}

enum ExerciseName {
    static let test                      = "test"
    static let writing                   = "writing"
    static let listening                 = "listening"
    static let card                      = "card"
}

enum ExerciseType {
    static let normal                    = "normal"
    static let hard                      = "hard"
}

enum Videos {
    static let levelup                   = "levelup"
    static let newpoint                  = "newpoint"
    static let alltrue                   = "alltrue"
}

enum Sounds {
    static let mario                     = "mario"
    static let falsee                    = "false"
    static let truee                     = "true"
    static let beep                      = "beep"
}


enum Images {
    static let check                     = UIImage(named: "check")
    static let wheel_prize_present       = UIImage(named: "wheel_prize_present")
    static let confetti                  = UIImage(named: "confetti")
    static let arrow_back                = UIImage(named: "arrow_back")
    static let coin                      = UIImage(named: "coin")
    
    static let home                      = UIImage(named: "home")
    static let daily                     = UIImage(named: "daily")
    static let award                     = UIImage(named: "award")
    static let statistic                 = UIImage(named: "statistic")
    static let settings                  = UIImage(named: "settings")
    static let banner                    = UIImage(named: "banner")
    
    static let wheelicon                 = UIImage(named: "wheelicon")
    static let new                       = UIImage(named: "new")
    static let bank                      = UIImage(named: "bank")
    static let hard                      = UIImage(named: "hard")
    
    static let onlyHand                  = UIImage(named: "onlyHand")
    static let drop                      = UIImage(named: "drop")
    
    static let testExercise              = UIImage(named: "testExercise")
    static let writingExercise           = UIImage(named: "writingExercise")
    static let listeningExercise         = UIImage(named: "listeningExercise")
    static let cardExercise              = UIImage(named: "cardExercise")
    
    static let sound                     = UIImage(named: "sound")
    static let soundLeft                 = UIImage(named: "soundLeft")
    static let soundBlack                = UIImage(named: "soundBlack")
    static let question                  = UIImage(named: "question")
    
    static let plus                      = UIImage(named: "plus")
    static let edit                      = UIImage(named: "edit")
    static let bin                       = UIImage(named: "bin")
}

enum UserDefault {
    
    static var userInterfaceStyle        = ""
    static var keyboardHeight            = UserDefaultsManager(key: "keyboardHeight")
    
    static var level                     = UserDefaultsManager(key: "level")
    static var lastPoint                 = UserDefaultsManager(key: "lastPoint")
    
    static var exerciseCount             = UserDefaultsManager(key: "exerciseCount")
    static var testCount                 = UserDefaultsManager(key: "testCount")
    static var writingCount              = UserDefaultsManager(key: "writingCount")
    static var listeningCount            = UserDefaultsManager(key: "listeningCount")
    static var cardCount                 = UserDefaultsManager(key: "cardCount")
    
    static var allTrueCount               = UserDefaultsManager(key: "allTrueCount")
    static var trueCount                 = UserDefaultsManager(key: "trueCount")
    static var falseCount                = UserDefaultsManager(key: "falseCount")
    
    static var startPressed              = UserDefaultsManager(key: "startPressed")
    static var whichButton               = UserDefaultsManager(key: "whichButton")
    static var setNotificationFirstTime  = UserDefaultsManager(key: "setNotificationFirstTime")
    static var x2Time                    = UserDefaultsManager(key: "2xTime")
    static var userSelectedHour          = UserDefaultsManager(key: "userSelectedHour")
    static var lastEditLabel             = UserDefaultsManager(key: "lastEditLabel")
    
    static var needPoint                 = UserDefaultsManager(key: "needPoint")
    static var goLevelUp                 = UserDefaultsManager(key: "goLevelUp")
    static var selectedSegmentIndex      = UserDefaultsManager(key: "selectedSegmentIndex")
    static var soundSpeed                = UserDefaultsManager(key: "soundSpeed")
    static var playSound                 = UserDefaultsManager(key: "playSound")
    static var playAppSound              = UserDefaultsManager(key: "playAppSound")
    static var textSize                  = UserDefaultsManager(key: "textSize")
    static var lastHour                  = UserDefaultsManager(key: "lastHour")
    static var exercisePoint             = UserDefaultsManager(key: "pointForMyWords")
    static var userAnswers               = UserDefaultsManager(key: "userAnswers")
    static var failNumber                = UserDefaultsManager(key: "failNumber")
    static var failIndex                 = UserDefaultsManager(key: "failIndex")
    static var userWordCount             = UserDefaultsManager(key: "userWordCount")
    static var hardWordsCount            = UserDefaultsManager(key: "hardWordsCount")
    static var spinWheelCount            = UserDefaultsManager(key: "spinWheelCount")
    
    static var rightOnce                 = UserDefaultsManager(key: "rightOnce")
    static var rightOnceBool             = UserDefaultsManager(key: "rightOnceBool")
    static var arrayForResultViewENG     = UserDefaultsManager(key: "arrayForResultViewENG")
    static var arrayForResultViewTR      = UserDefaultsManager(key: "arrayForResultViewTR")
    static var addedHardWordsCount       = UserDefaultsManager(key: "addedHardWordsCount")
    
    static var engEdit                   = UserDefaultsManager(key: "engEdit")
    static var trEdit                    = UserDefaultsManager(key: "trEdit")
    
    //will delete next version
    static var blueAllTrue               = UserDefaultsManager(key: "blueAllTrue")
    static var start1count               = UserDefaultsManager(key: "start1count")
    static var start2count               = UserDefaultsManager(key: "start2count")
    static var start3count               = UserDefaultsManager(key: "start3count")
    static var start4count               = UserDefaultsManager(key: "start4count")
    static var blueExerciseCount         = UserDefaultsManager(key: "blueExerciseCount")
    static var blueTrueCount             = UserDefaultsManager(key: "blueTrueCount")
    static var blueFalseCount            = UserDefaultsManager(key: "blueFalseCount")
}
