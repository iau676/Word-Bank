//
//  Level.swift
//  Word Bank
//
//  Created by ibrahim uysal on 16.08.2024.
//

import Foundation

struct Level {
    
    static var shared = Level()
    private init() {}
    
    let _1 = 0
    let _2 = 500
    let _3 = 1_000
    let _4 = 1_500
    let _5 = 2_000 // 500
    let _6 = 3_000
    let _7 = 4_000
    let _8 = 5_000
    let _9 = 6_000
    let _10 = 7_000  // 1.000
    let _11 = 9_000
    let _12 = 11_000
    let _13 = 13_000
    let _14 = 15_000
    let _15 = 17_000 // 2.000
    let _16 = 21_000
    let _17 = 25_000
    let _18 = 29_000
    let _19 = 33_000
    let _20 = 37_000 // 4.000
    let _21 = 45_000
    let _22 = 53_000
    let _23 = 61_000
    let _24 = 69_000
    let _25 = 77_000 // 8.000
    let _26 = 93_000
    let _27 = 109_000
    let _28 = 125_000
    let _29 = 141_000
    let _30 = 157_000 // 16.000
    let _31 = 189_000
    let _32 = 221_000
    let _33 = 253_000
    let _34 = 285_000
    let _35 = 317_000 // 32.000
    let _36 = 381_000
    let _37 = 445_000
    let _38 = 509_000
    let _39 = 573_000
    let _40 = 637_000 // 64.000
    let _41 = 765_000
    let _42 = 893_000
    let _43 = 1_021_000
    let _44 = 1_149_000
    let _45 = 1_277_000 // 128.000
    let _46 = 1_533_000
    let _47 = 1_789_000
    let _48 = 2_045_000
    let _49 = 2_301_000
    let _50 = 2_557_000 // 256.000
    let _51 = 3_069_000
    let _52 = 3_581_000
    let _53 = 4_093_000
    let _54 = 4_605_000
    let _55 = 5_117_000 // 512.000
    let _56 = 6_141_000
    let _57 = 7_165_000
    let _58 = 8_189_000
    let _59 = 9_213_000
    let _60 = 10_237_000 // 1.024.000
    let _61 = 12_285_000
    let _62 = 14_333_000
    let _63 = 16_381_000
    let _64 = 18_429_000
    let _65 = 20_477_000 // 2.048.000
    let _66 = 24_573_000
    let _67 = 28_669_000
    let _68 = 32_765_000
    let _69 = 36_861_000
    let _70 = 40_957_000 // 4.096.000
    let _71 = 49_149_000
    let _72 = 57_341_000
    let _73 = 65_533_000
    let _74 = 73_725_000
    let _75 = 81_917_000 // 8.192.000
    let _76 = 98_301_000
    let _77 = 114_685_000
    let _78 = 131_069_000
    let _79 = 147_453_000
    let _80 = 163_837_000 // 16.384.000
    let _81 = 196_605_000
    let _82 = 229_373_000
    let _83 = 262_141_000
    let _84 = 294_909_000
    let _85 = 327_677_000 // 32.768.000
    let _86 = 393_213_000
    let _87 = 458_749_000
    let _88 = 524_285_000
    let _89 = 589_821_000
    let _90 = 655_357_000 // 65.536.000
    let _91 = 786_429_000
    let _92 = 917_501_000
    let _93 = 1_048_573_000
    let _94 = 1_179_645_000
    let _95 = 1_310_717_000 // 131.072.000
    let _96 = 1_572_861_000
    let _97 = 1_835_005_000
    let _98 = 2_097_149_000
    let _99 = 2_359_293_000
    let _100 = 2_621_437_000 //262.144.000
    
    func setLevelAndReturnProgress(_ newLevel: Int, _ firstLevelPoint: Int, _ secondLevelPoint: Int) -> Float {
        let lastSavedPoint = UserDefault.lastPoint.getInt()
        UserDefault.level.set(newLevel)
        UserDefault.needPoint.set(secondLevelPoint-lastSavedPoint)
        return Float(lastSavedPoint-firstLevelPoint)/Float((secondLevelPoint-firstLevelPoint))
    }
    
    func calculateLevel() -> Float {
        let lastSavedPoint = UserDefault.lastPoint.getInt()
        if lastSavedPoint < 0 {
            UserDefault.level.set(0)
            UserDefault.needPoint.set(0-lastSavedPoint)
            return 0
        }
        switch lastSavedPoint {
        case _1..<_2:
            return setLevelAndReturnProgress(1, _1, _2)
            
        case _2..<_3:
            return setLevelAndReturnProgress(2, _2, _3)
            
        case _3..<_4:
            return setLevelAndReturnProgress(3, _3, _4)
            
        case _4..<_5:
            return setLevelAndReturnProgress(4, _4, _5)
            
        case _5..<_6:
            return setLevelAndReturnProgress(5, _5, _6)
            
        case  _6..<_7:
            return setLevelAndReturnProgress(6, _6, _7)
            
        case  _7..<_8:
            return setLevelAndReturnProgress(7,  _7,  _8)
            
        case  _8..<_9:
            return setLevelAndReturnProgress(8,  _8,  _9)
            
        case  _9..<_10:
            return setLevelAndReturnProgress(9,  _9,  _10)
            
        case  _10..<_11:
            return setLevelAndReturnProgress(10,  _10,  _11)
            
        case  _11..<_12:
            return setLevelAndReturnProgress(11,  _11,  _12)
            
        case  _12..<_13:
            return setLevelAndReturnProgress(12,  _12,  _13)
            
        case  _13..<_14:
            return setLevelAndReturnProgress(13,  _13,  _14)
            
        case  _14..<_15:
            return setLevelAndReturnProgress(14,  _14,  _15)
            
        case  _15..<_16:
            return setLevelAndReturnProgress(15,  _15,  _16)
            
        case  _16..<_17:
            return setLevelAndReturnProgress(16,  _16,  _17)
            
        case  _17..<_18:
            return setLevelAndReturnProgress(17,  _17,  _18)
            
        case  _18..<_19:
            return setLevelAndReturnProgress(18,  _18,  _19)
            
        case  _19..<_20:
            return setLevelAndReturnProgress(19,  _19,  _20)
            
        case  _20..<_21:
            return setLevelAndReturnProgress(20,  _20,  _21)
            
        case  _21..<_22:
            return setLevelAndReturnProgress(21,  _21,  _22)
            
        case  _22..<_23:
            return setLevelAndReturnProgress(22,  _22,  _23)
            
        case  _23..<_24:
            return setLevelAndReturnProgress(23,  _23,  _24)
            
        case  _24..<_25:
            return setLevelAndReturnProgress(24,  _24,  _25)
            
        case  _25..<_26:
            return setLevelAndReturnProgress(25,  _25,  _26)
            
        case  _26..<_27:
            return setLevelAndReturnProgress(26,  _26,  _27)
            
        case  _27..<_28:
            return setLevelAndReturnProgress(27,  _27,  _28)
            
        case  _28..<_29:
            return setLevelAndReturnProgress(28,  _28,  _29)
            
        case  _29..<_30:
            return setLevelAndReturnProgress(29,  _29,  _30)
            
        case  _30..<_31:
            return setLevelAndReturnProgress(30,  _30,  _31)
            
        case  _31..<_32:
            return setLevelAndReturnProgress(31,  _31,  _32)
            
        case  _32..<_33:
            return setLevelAndReturnProgress(32,  _32,  _33)
            
        case  _33..<_34:
            return setLevelAndReturnProgress(33,  _33,  _34)
            
        case  _34..<_35:
            return setLevelAndReturnProgress(34,  _34,  _35)
            
        case  _35..<_36:
            return setLevelAndReturnProgress(35,  _35,  _36)
            
        case  _36..<_37:
            return setLevelAndReturnProgress(36,  _36,  _37)
            
        case  _37..<_38:
            return setLevelAndReturnProgress(37,  _37,  _38)
            
        case  _38..<_39:
            return setLevelAndReturnProgress(38,  _38,  _39)
            
        case  _39..<_40:
            return setLevelAndReturnProgress(39,  _39,  _40)
            
        case  _40..<_41:
            return setLevelAndReturnProgress(40,  _40,  _41)
            
        case  _41..<_42:
            return setLevelAndReturnProgress(41,  _41,  _42)
            
        case  _42..<_43:
            return setLevelAndReturnProgress(42,  _42,  _43)
            
        case  _43..<_44:
            return setLevelAndReturnProgress(43,  _43,  _44)
            
        case  _44..<_45:
            return setLevelAndReturnProgress(44,  _44,  _45)
            
        case  _45..<_46:
            return setLevelAndReturnProgress(45,  _45,  _46)
            
        case  _46..<_47:
            return setLevelAndReturnProgress(46,  _46,  _47)
            
        case  _47..<_48:
            return setLevelAndReturnProgress(47,  _47,  _48)
            
        case  _48..<_49:
            return setLevelAndReturnProgress(48,  _48,  _49)
            
        case  _49..<_50:
            return setLevelAndReturnProgress(49,  _49,  _50)
            
        case  _50..<_51:
            return setLevelAndReturnProgress(50,  _50,  _51)
            
        case  _51..<_52:
            return setLevelAndReturnProgress(51,  _51,  _52)
            
        case  _52..<_53:
            return setLevelAndReturnProgress(52,  _52,  _53)
            
        case  _53..<_54:
            return setLevelAndReturnProgress(53,  _53,  _54)
            
        case  _54..<_55:
            return setLevelAndReturnProgress(54,  _54,  _55)
            
        case  _55..<_56:
            return setLevelAndReturnProgress(55,  _55,  _56)
            
        case  _56..<_57:
            return setLevelAndReturnProgress(56,  _56,  _57)
            
        case  _57..<_58:
            return setLevelAndReturnProgress(57,  _57,  _58)
            
        case  _58..<_59:
            return setLevelAndReturnProgress(58,  _58,  _59)
            
        case  _59..<_60:
            return setLevelAndReturnProgress(59,  _59,  _60)
            
        case  _60..<_61:
            return setLevelAndReturnProgress(60,  _60,  _61)
            
        case  _61..<_62:
            return setLevelAndReturnProgress(61,  _61,  _62)
            
        case  _62..<_63:
            return setLevelAndReturnProgress(62,  _62,  _63)
            
        case  _63..<_64:
            return setLevelAndReturnProgress(63,  _63,  _64)
            
        case  _64..<_65:
            return setLevelAndReturnProgress(64,  _64,  _65)
            
        case  _65..<_66:
            return setLevelAndReturnProgress(65,  _65,  _66)
            
        case  _66..<_67:
            return setLevelAndReturnProgress(66,  _66,  _67)
            
        case  _67..<_68:
            return setLevelAndReturnProgress(67,  _67,  _68)
            
        case  _68..<_69:
            return setLevelAndReturnProgress(68,  _68,  _69)
            
        case  _69..<_70:
            return setLevelAndReturnProgress(69,  _69,  _70)
            
        case  _70..<_71:
            return setLevelAndReturnProgress(70,  _70,  _71)
            
        case  _71..<_72:
            return setLevelAndReturnProgress(71,  _71,  _72)
            
        case  _72..<_73:
            return setLevelAndReturnProgress(72,  _72,  _73)
            
        case  _73..<_74:
            return setLevelAndReturnProgress(73,  _73,  _74)
            
        case  _74..<_75:
            return setLevelAndReturnProgress(74,  _74,  _75)
            
        case  _75..<_76:
            return setLevelAndReturnProgress(75,  _75,  _76)
            
        case  _76..<_77:
            return setLevelAndReturnProgress(76,  _76,  _77)
            
        case  _77..<_78:
            return setLevelAndReturnProgress(77,  _77,  _78)
            
        case  _78..<_79:
            return setLevelAndReturnProgress(78,  _78,  _79)
            
        case  _79..<_80:
            return setLevelAndReturnProgress(79,  _79,  _80)
            
        case  _80..<_81:
            return setLevelAndReturnProgress(80,  _80,  _81)
            
        case  _81..<_82:
            return setLevelAndReturnProgress(81,  _81,  _82)
            
        case  _82..<_83:
            return setLevelAndReturnProgress(82,  _82,  _83)
            
        case  _83..<_84:
            return setLevelAndReturnProgress(83,  _83,  _84)
            
        case  _84..<_85:
            return setLevelAndReturnProgress(84,  _84,  _85)
            
        case  _85..<_86:
            return setLevelAndReturnProgress(85,  _85,  _86)
            
        case  _86..<_87:
            return setLevelAndReturnProgress(86,  _86,  _87)
            
        case  _87..<_88:
            return setLevelAndReturnProgress(87,  _87,  _88)
            
        case  _88..<_89:
            return setLevelAndReturnProgress(88,  _88,  _89)
            
        case  _89..<_90:
            return setLevelAndReturnProgress(89,  _89,  _90)
            
        case  _90..<_91:
            return setLevelAndReturnProgress(90,  _90,  _91)
            
        case  _91..<_92:
            return setLevelAndReturnProgress(91,  _91,  _92)
            
        case  _92..<_93:
            return setLevelAndReturnProgress(92,  _92,  _93)
            
        case  _93..<_94:
            return setLevelAndReturnProgress(93,  _93,  _94)
            
        case  _94..<_95:
            return setLevelAndReturnProgress(94,  _94,  _95)
            
        case  _95..<_96:
            return setLevelAndReturnProgress(95,  _95,  _96)
            
        case  _96..<_97:
            return setLevelAndReturnProgress(96,  _96,  _97)
            
        case  _97..<_98:
            return setLevelAndReturnProgress(97,  _97,  _98)
            
        case  _98..<_99:
            return setLevelAndReturnProgress(98,  _98,  _99)
            
        case  _99..<_100:
            return setLevelAndReturnProgress(99,  _99,  _100)
            
        case  _100..<676_000_000:
            return setLevelAndReturnProgress(100,  _100, 676_000_000)
            
        case 676_000_000..<2_147_483_646:
            UserDefault.level.set(676)
            UserDefault.needPoint.set(0)
            return 1.0

        default:
            UserDefault.level.set(0)
            UserDefault.needPoint.set(0-lastSavedPoint)
            return 0.0
        }
    }
    
    func getPrizePoint() -> Int {
        switch UserDefault.level.getInt() {
        case 0..<5:
            return 125
        case 5..<10:
            return 250
        case 10..<15:
            return 500
        case 15..<20:
            return 1_000
        case 20..<25:
            return 2_000
        case 25..<30:
            return 5_000
        case 30..<35:
            return 7_500
        case 35..<40:
            return 15_000
        case 40..<45:
            return 25_000
        case 45..<50:
            return 50_000
        case 50..<55:
            return 100_000
        case 55..<60:
            return 200_000
        case 60..<65:
            return 300_000
        case 65..<70:
            return 500_000
        case 70..<80:
            return 1_000_000
        case 81..<90:
            return 2_500_000
        case 90..<100:
            return 5_000_000
        default: return 676
        }
    }
}
