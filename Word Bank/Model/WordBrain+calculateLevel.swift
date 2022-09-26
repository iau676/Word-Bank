//
//  WordBrain+calculateLevel.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 28.07.2022.
//

import Foundation

extension WordBrain {
    
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
        case levelPoints._1..<levelPoints._2:
            return setLevelAndReturnProgress(1, levelPoints._1, levelPoints._2)
            
        case levelPoints._2..<levelPoints._3:
            return setLevelAndReturnProgress(2, levelPoints._2, levelPoints._3)
            
        case levelPoints._3..<levelPoints._4:
            return setLevelAndReturnProgress(3, levelPoints._3, levelPoints._4)
            
        case levelPoints._4..<levelPoints._5:
            return setLevelAndReturnProgress(4, levelPoints._4, levelPoints._5)
            
        case levelPoints._5..<levelPoints._6:
            return setLevelAndReturnProgress(5, levelPoints._5, levelPoints._6)
            
        case levelPoints._6..<levelPoints._7:
            return setLevelAndReturnProgress(6, levelPoints._6, levelPoints._7)
            
        case levelPoints._7..<levelPoints._8:
            return setLevelAndReturnProgress(7, levelPoints._7, levelPoints._8)
            
        case levelPoints._8..<levelPoints._9:
            return setLevelAndReturnProgress(8, levelPoints._8, levelPoints._9)
            
        case levelPoints._9..<levelPoints._10:
            return setLevelAndReturnProgress(9, levelPoints._9, levelPoints._10)
            
        case levelPoints._10..<levelPoints._11:
            return setLevelAndReturnProgress(10, levelPoints._10, levelPoints._11)
            
        case levelPoints._11..<levelPoints._12:
            return setLevelAndReturnProgress(11, levelPoints._11, levelPoints._12)
            
        case levelPoints._12..<levelPoints._13:
            return setLevelAndReturnProgress(12, levelPoints._12, levelPoints._13)
            
        case levelPoints._13..<levelPoints._14:
            return setLevelAndReturnProgress(13, levelPoints._13, levelPoints._14)
            
        case levelPoints._14..<levelPoints._15:
            return setLevelAndReturnProgress(14, levelPoints._14, levelPoints._15)
            
        case levelPoints._15..<levelPoints._16:
            return setLevelAndReturnProgress(15, levelPoints._15, levelPoints._16)
            
        case levelPoints._16..<levelPoints._17:
            return setLevelAndReturnProgress(16, levelPoints._16, levelPoints._17)
            
        case levelPoints._17..<levelPoints._18:
            return setLevelAndReturnProgress(17, levelPoints._17, levelPoints._18)
            
        case levelPoints._18..<levelPoints._19:
            return setLevelAndReturnProgress(18, levelPoints._18, levelPoints._19)
            
        case levelPoints._19..<levelPoints._20:
            return setLevelAndReturnProgress(19, levelPoints._19, levelPoints._20)
            
        case levelPoints._20..<levelPoints._21:
            return setLevelAndReturnProgress(20, levelPoints._20, levelPoints._21)
            
        case levelPoints._21..<levelPoints._22:
            return setLevelAndReturnProgress(21, levelPoints._21, levelPoints._22)
            
        case levelPoints._22..<levelPoints._23:
            return setLevelAndReturnProgress(22, levelPoints._22, levelPoints._23)
            
        case levelPoints._23..<levelPoints._24:
            return setLevelAndReturnProgress(23, levelPoints._23, levelPoints._24)
            
        case levelPoints._24..<levelPoints._25:
            return setLevelAndReturnProgress(24, levelPoints._24, levelPoints._25)
            
        case levelPoints._25..<levelPoints._26:
            return setLevelAndReturnProgress(25, levelPoints._25, levelPoints._26)
            
        case levelPoints._26..<levelPoints._27:
            return setLevelAndReturnProgress(26, levelPoints._26, levelPoints._27)
            
        case levelPoints._27..<levelPoints._28:
            return setLevelAndReturnProgress(27, levelPoints._27, levelPoints._28)
            
        case levelPoints._28..<levelPoints._29:
            return setLevelAndReturnProgress(28, levelPoints._28, levelPoints._29)
            
        case levelPoints._29..<levelPoints._30:
            return setLevelAndReturnProgress(29, levelPoints._29, levelPoints._30)
            
        case levelPoints._30..<levelPoints._31:
            return setLevelAndReturnProgress(30, levelPoints._30, levelPoints._31)
            
        case levelPoints._31..<levelPoints._32:
            return setLevelAndReturnProgress(31, levelPoints._31, levelPoints._32)
            
        case levelPoints._32..<levelPoints._33:
            return setLevelAndReturnProgress(32, levelPoints._32, levelPoints._33)
            
        case levelPoints._33..<levelPoints._34:
            return setLevelAndReturnProgress(33, levelPoints._33, levelPoints._34)
            
        case levelPoints._34..<levelPoints._35:
            return setLevelAndReturnProgress(34, levelPoints._34, levelPoints._35)
            
        case levelPoints._35..<levelPoints._36:
            return setLevelAndReturnProgress(35, levelPoints._35, levelPoints._36)
            
        case levelPoints._36..<levelPoints._37:
            return setLevelAndReturnProgress(36, levelPoints._36, levelPoints._37)
            
        case levelPoints._37..<levelPoints._38:
            return setLevelAndReturnProgress(37, levelPoints._37, levelPoints._38)
            
        case levelPoints._38..<levelPoints._39:
            return setLevelAndReturnProgress(38, levelPoints._38, levelPoints._39)
            
        case levelPoints._39..<levelPoints._40:
            return setLevelAndReturnProgress(39, levelPoints._39, levelPoints._40)
            
        case levelPoints._40..<levelPoints._41:
            return setLevelAndReturnProgress(40, levelPoints._40, levelPoints._41)
            
        case levelPoints._41..<levelPoints._42:
            return setLevelAndReturnProgress(41, levelPoints._41, levelPoints._42)
            
        case levelPoints._42..<levelPoints._43:
            return setLevelAndReturnProgress(42, levelPoints._42, levelPoints._43)
            
        case levelPoints._43..<levelPoints._44:
            return setLevelAndReturnProgress(43, levelPoints._43, levelPoints._44)
            
        case levelPoints._44..<levelPoints._45:
            return setLevelAndReturnProgress(44, levelPoints._44, levelPoints._45)
            
        case levelPoints._45..<levelPoints._46:
            return setLevelAndReturnProgress(45, levelPoints._45, levelPoints._46)
            
        case levelPoints._46..<levelPoints._47:
            return setLevelAndReturnProgress(46, levelPoints._46, levelPoints._47)
            
        case levelPoints._47..<levelPoints._48:
            return setLevelAndReturnProgress(47, levelPoints._47, levelPoints._48)
            
        case levelPoints._48..<levelPoints._49:
            return setLevelAndReturnProgress(48, levelPoints._48, levelPoints._49)
            
        case levelPoints._49..<levelPoints._50:
            return setLevelAndReturnProgress(49, levelPoints._49, levelPoints._50)
            
        case levelPoints._50..<levelPoints._51:
            return setLevelAndReturnProgress(50, levelPoints._50, levelPoints._51)
            
        case levelPoints._51..<levelPoints._52:
            return setLevelAndReturnProgress(51, levelPoints._51, levelPoints._52)
            
        case levelPoints._52..<levelPoints._53:
            return setLevelAndReturnProgress(52, levelPoints._52, levelPoints._53)
            
        case levelPoints._53..<levelPoints._54:
            return setLevelAndReturnProgress(53, levelPoints._53, levelPoints._54)
            
        case levelPoints._54..<levelPoints._55:
            return setLevelAndReturnProgress(54, levelPoints._54, levelPoints._55)
            
        case levelPoints._55..<levelPoints._56:
            return setLevelAndReturnProgress(55, levelPoints._55, levelPoints._56)
            
        case levelPoints._56..<levelPoints._57:
            return setLevelAndReturnProgress(56, levelPoints._56, levelPoints._57)
            
        case levelPoints._57..<levelPoints._58:
            return setLevelAndReturnProgress(57, levelPoints._57, levelPoints._58)
            
        case levelPoints._58..<levelPoints._59:
            return setLevelAndReturnProgress(58, levelPoints._58, levelPoints._59)
            
        case levelPoints._59..<levelPoints._60:
            return setLevelAndReturnProgress(59, levelPoints._59, levelPoints._60)
            
        case levelPoints._60..<levelPoints._61:
            return setLevelAndReturnProgress(60, levelPoints._60, levelPoints._61)
            
        case levelPoints._61..<levelPoints._62:
            return setLevelAndReturnProgress(61, levelPoints._61, levelPoints._62)
            
        case levelPoints._62..<levelPoints._63:
            return setLevelAndReturnProgress(62, levelPoints._62, levelPoints._63)
            
        case levelPoints._63..<levelPoints._64:
            return setLevelAndReturnProgress(63, levelPoints._63, levelPoints._64)
            
        case levelPoints._64..<levelPoints._65:
            return setLevelAndReturnProgress(64, levelPoints._64, levelPoints._65)
            
        case levelPoints._65..<levelPoints._66:
            return setLevelAndReturnProgress(65, levelPoints._65, levelPoints._66)
            
        case levelPoints._66..<levelPoints._67:
            return setLevelAndReturnProgress(66, levelPoints._66, levelPoints._67)
            
        case levelPoints._67..<levelPoints._68:
            return setLevelAndReturnProgress(67, levelPoints._67, levelPoints._68)
            
        case levelPoints._68..<levelPoints._69:
            return setLevelAndReturnProgress(68, levelPoints._68, levelPoints._69)
            
        case levelPoints._69..<levelPoints._70:
            return setLevelAndReturnProgress(69, levelPoints._69, levelPoints._70)
            
        case levelPoints._70..<levelPoints._71:
            return setLevelAndReturnProgress(70, levelPoints._70, levelPoints._71)
            
        case levelPoints._71..<levelPoints._72:
            return setLevelAndReturnProgress(71, levelPoints._71, levelPoints._72)
            
        case levelPoints._72..<levelPoints._73:
            return setLevelAndReturnProgress(72, levelPoints._72, levelPoints._73)
            
        case levelPoints._73..<levelPoints._74:
            return setLevelAndReturnProgress(73, levelPoints._73, levelPoints._74)
            
        case levelPoints._74..<levelPoints._75:
            return setLevelAndReturnProgress(74, levelPoints._74, levelPoints._75)
            
        case levelPoints._75..<levelPoints._76:
            return setLevelAndReturnProgress(75, levelPoints._75, levelPoints._76)
            
        case levelPoints._76..<levelPoints._77:
            return setLevelAndReturnProgress(76, levelPoints._76, levelPoints._77)
            
        case levelPoints._77..<levelPoints._78:
            return setLevelAndReturnProgress(77, levelPoints._77, levelPoints._78)
            
        case levelPoints._78..<levelPoints._79:
            return setLevelAndReturnProgress(78, levelPoints._78, levelPoints._79)
            
        case levelPoints._79..<levelPoints._80:
            return setLevelAndReturnProgress(79, levelPoints._79, levelPoints._80)
            
        case levelPoints._80..<levelPoints._81:
            return setLevelAndReturnProgress(80, levelPoints._80, levelPoints._81)
            
        case levelPoints._81..<levelPoints._82:
            return setLevelAndReturnProgress(81, levelPoints._81, levelPoints._82)
            
        case levelPoints._82..<levelPoints._83:
            return setLevelAndReturnProgress(82, levelPoints._82, levelPoints._83)
            
        case levelPoints._83..<levelPoints._84:
            return setLevelAndReturnProgress(83, levelPoints._83, levelPoints._84)
            
        case levelPoints._84..<levelPoints._85:
            return setLevelAndReturnProgress(84, levelPoints._84, levelPoints._85)
            
        case levelPoints._85..<levelPoints._86:
            return setLevelAndReturnProgress(85, levelPoints._85, levelPoints._86)
            
        case levelPoints._86..<levelPoints._87:
            return setLevelAndReturnProgress(86, levelPoints._86, levelPoints._87)
            
        case levelPoints._87..<levelPoints._88:
            return setLevelAndReturnProgress(87, levelPoints._87, levelPoints._88)
            
        case levelPoints._88..<levelPoints._89:
            return setLevelAndReturnProgress(88, levelPoints._88, levelPoints._89)
            
        case levelPoints._89..<levelPoints._90:
            return setLevelAndReturnProgress(89, levelPoints._89, levelPoints._90)
            
        case levelPoints._90..<levelPoints._91:
            return setLevelAndReturnProgress(90, levelPoints._90, levelPoints._91)
            
        case levelPoints._91..<levelPoints._92:
            return setLevelAndReturnProgress(91, levelPoints._91, levelPoints._92)
            
        case levelPoints._92..<levelPoints._93:
            return setLevelAndReturnProgress(92, levelPoints._92, levelPoints._93)
            
        case levelPoints._93..<levelPoints._94:
            return setLevelAndReturnProgress(93, levelPoints._93, levelPoints._94)
            
        case levelPoints._94..<levelPoints._95:
            return setLevelAndReturnProgress(94, levelPoints._94, levelPoints._95)
            
        case levelPoints._95..<levelPoints._96:
            return setLevelAndReturnProgress(95, levelPoints._95, levelPoints._96)
            
        case levelPoints._96..<levelPoints._97:
            return setLevelAndReturnProgress(96, levelPoints._96, levelPoints._97)
            
        case levelPoints._97..<levelPoints._98:
            return setLevelAndReturnProgress(97, levelPoints._97, levelPoints._98)
            
        case levelPoints._98..<levelPoints._99:
            return setLevelAndReturnProgress(98, levelPoints._98, levelPoints._99)
            
        case levelPoints._99..<levelPoints._100:
            return setLevelAndReturnProgress(99, levelPoints._99, levelPoints._100)
            
        case levelPoints._100..<676_000_000:
            return setLevelAndReturnProgress(100, levelPoints._100, 676_000_000)
            
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
}
