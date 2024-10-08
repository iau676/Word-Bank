//
//  Constants.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 2.08.2022.
//

import UIKit

var brain = WordBrain.shared
let totalQuestionNumber = 10

enum Colors {
    static let darkBackground            = UIColor(white: 0.1, alpha: 0.4)
    static let black                     = UIColor(hex: "#1C1C1C")
    static let cellRight                 = UIColor(hex: "#F5F5F5")
    static let cellLeft                  = UIColor(hex: "#DFDEDE")
    
    static let pink                      = UIColor(hex: "#fc8da5")
    static let green                     = UIColor(hex: "#17bf8c")
    static let blue                      = UIColor(hex: "#1cbaeb")
    static let yellow                    = UIColor(hex: "#ffbf47")
    static let purple                    = UIColor(hex: "#af52de")
    
    static let pinkLight                 = UIColor(hex: "#f198ab")
    static let greenLight                = UIColor(hex: "#27e5ab")
    static let blueLight                 = UIColor(hex: "#58ccf0")
    static let yellowLight               = UIColor(hex: "#ffdb99")
    static let purpleLight               = UIColor(hex: "#cd92ea")
    
    static let d6d6d6                    = UIColor(hex: "#d6d6d6")
    static let f6f6f6                    = UIColor(hex: "#f6f6f6")
    static let d9d9d9                    = UIColor(hex: "#d9d9d9")
    static let b9b9b9                    = UIColor(hex: "#b9b9b9")
    static let testAnswerLayer           = UIColor(hex: "#47668f")
    static let red                       = UIColor(hex: "#eb5c70")
    static let raven                     = UIColor(hex: "#323d5a")
    static let ravenShadow               = UIColor(hex: "#293047")
    static let lightBlue                 = UIColor(hex: "#759ecc")
    static let lightGreen                = UIColor(hex: "#70dbba")
    static let lightRed                  = UIColor(hex: "#ff8f9e")
    static let lightYellow               = UIColor(hex: "#ffdb99")
    static let darkGrayShadow            = UIColor(hex: "#444444")
}

enum ExerciseType {
    case test
    case writing
    case listening
    case card
    
    var description: String {
        switch self {
        case .test: return "test"
        case .writing: return "writing"
        case .listening: return "listening"
        case .card: return "card"
        }
    }
}

enum ExerciseKind {
    case normal
    case hard
    
    var description: String {
        switch self {
        case .normal: return "normal"
        case .hard: return "hard"
        }
    }
}

enum Videos {
    static let levelup                   = "levelup"
    static let alltrue                   = "alltrue"
}

enum Sounds {
    static let falsee                    = "false"
    static let truee                     = "true"
}

enum Images {
    static let house                     = UIImage(systemName: "house.fill")
    static let refresh                   = UIImage(systemName: "arrow.clockwise")
    static let xmark                     = UIImage(systemName: "xmark")
    static let chevronRight              = UIImage(systemName: "chevron.right")
    static let add                       = UIImage(systemName: "plus")
    static let questionmark              = UIImage(systemName: "questionmark.app")
    
    
    static let menu                      = UIImage(named: "menu")
    static let check                     = UIImage(named: "check")
    static let whiteCircle               = UIImage(named: "whiteCircle")
    static let wheel_prize_present       = UIImage(named: "wheel_prize_present")
    static let confetti                  = UIImage(named: "confetti")
    static let arrow_back                = UIImage(named: "arrow_back")
    static let dropBlue                  = UIImage(named: "dropBlue")
    
    static let home                      = UIImage(named: "home")
    static let giftBox                   = UIImage(named: "gift-box")
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
    static let magic                     = UIImage(named: "magic")
    static let greenBubble               = UIImage(named: "greenBubble")
    static let redBubble                 = UIImage(named: "redBubble")
    static let greenCircle               = UIImage(named: "greenCircle")
    static let redCircle                 = UIImage(named: "redCircle")
    static let defaultKeyboard           = UIImage(named: "defaultKeyboard")
    static let customKeyboard            = UIImage(named: "customKeyboard")
    static let next                      = UIImage(named: "next")
    static let backspace                 = UIImage(named: "backspace")
    
    static let plus                      = UIImage(named: "plus")
    static let edit                      = UIImage(named: "edit")
    static let bin                       = UIImage(named: "bin")
}

enum UserDefault {
    static var userInterfaceStyle        = ""
    static var version206                = UserDefaultsManager(key: "version206")
    static var keyboardHeight            = UserDefaultsManager(key: "keyboardHeight")
    static var userGotDailyPrize         = UserDefaultsManager(key: "userGotDailyPrize")
    static var addedHardWordsCount       = UserDefaultsManager(key: "addedHardWordsCount")
    
    static var level                     = UserDefaultsManager(key: "level")
    static var lastPoint                 = UserDefaultsManager(key: "lastPoint")
        
    static var needPoint                 = UserDefaultsManager(key: "needPoint")
    static var selectedTestType          = UserDefaultsManager(key: "selectedTestType")
    static var selectedPointEffect       = UserDefaultsManager(key: "selectedPointEffect")
    static var selectedTyping            = UserDefaultsManager(key: "selectedTyping")
    static var soundSpeed                = UserDefaultsManager(key: "soundSpeed")
    static var playSound                 = UserDefaultsManager(key: "playSound")
    static var playAppSound              = UserDefaultsManager(key: "playAppSound")
}

enum DateFormats {
    static var yyyyMMdd                  = "yyyy-MM-dd"
    static var EEE                       = "EEE"
}

enum Fonts {
    static var AvenirNextRegular13 = UIFont(name: "AvenirNext-Regular", size: 13)
    static var AvenirNextRegular15 = UIFont(name: "AvenirNext-Regular", size: 15)
    static var AvenirNextRegular17 = UIFont(name: "AvenirNext-Regular", size: 17)
    static var AvenirNextRegular19 = UIFont(name: "AvenirNext-Regular", size: 19)
    
    static var AvenirNextDemiBold9 = UIFont(name: "AvenirNext-DemiBold", size: 9)
    static var AvenirNextDemiBold11 = UIFont(name: "AvenirNext-DemiBold", size: 11)
    static var AvenirNextDemiBold15 = UIFont(name: "AvenirNext-DemiBold", size: 15)
    static var AvenirNextDemiBold19 = UIFont(name: "AvenirNext-DemiBold", size: 19)
    static var AvenirNextDemiBold25 = UIFont(name: "AvenirNext-DemiBold", size: 25)
    
    static var AvenirNextMedium15 = UIFont(name: "AvenirNext-Medium", size: 15)
    static var AvenirNextMedium19 = UIFont(name: "AvenirNext-Medium", size: 19)
    
    static var ArialRoundedMTBold17 = UIFont(name: "ArialRoundedMTBold", size: 17)
    static var ArialRoundedMTBold20 = UIFont(name: "ArialRoundedMTBold", size: 20)
    static var ArialRoundedMTBold23 = UIFont(name: "ArialRoundedMTBold", size: 23)
    static var ArialRoundedMTBold29 = UIFont(name: "ArialRoundedMTBold", size: 29)
    static var ArialRoundedMTBold30 = UIFont(name: "ArialRoundedMTBold", size: 30)
    static var ArialRoundedMTBold70 = UIFont(name: "ArialRoundedMTBold", size: 70)
}
