//
//  WordBrain+calculateLevel.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 28.07.2022.
//

import Foundation

extension WordBrain {
    
    
    
    
    func calculateLevel() -> Float {
        let lastSavedPoint = lastPoint.getInt()
        switch lastSavedPoint {
        case levelPoints._1..<levelPoints._2: //500
            level.set(1)
            needPoint.set(levelPoints._2-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._1)/Float((500-levelPoints._1))
        case levelPoints._2..<levelPoints._3: //600
            level.set(2)
            needPoint.set(levelPoints._3-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._2)/Float(levelPoints._3-levelPoints._2)
            
        case levelPoints._3..<levelPoints._4: //700
            level.set(3)
            needPoint.set(levelPoints._4-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._3)/Float(levelPoints._4-levelPoints._3)
            
        case levelPoints._4..<levelPoints._5: //800
            level.set(4)
            needPoint.set(levelPoints._5-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._4)/Float(levelPoints._5-levelPoints._4)
            
        case levelPoints._5..<levelPoints._6: //900
            level.set(5)
            needPoint.set(levelPoints._6-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._5)/Float(levelPoints._6-levelPoints._5)
            
        case levelPoints._6..<levelPoints._7: //1000
            level.set(6)
            needPoint.set(levelPoints._7-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._6)/Float(levelPoints._7-levelPoints._6)
            
        case levelPoints._7..<levelPoints._8: //1200
            level.set(7)
            needPoint.set(levelPoints._8-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._7)/Float(levelPoints._8-levelPoints._7)
            
        case levelPoints._8..<levelPoints._9: //1400
            level.set(8)
            needPoint.set(levelPoints._9-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._8)/Float(7_100-levelPoints._8)
            
        case levelPoints._9..<levelPoints._10: //1600
            level.set(9)
            needPoint.set(levelPoints._10-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._9)/Float(levelPoints._10-levelPoints._9)
            
        case levelPoints._10..<levelPoints._11: //1800
            level.set(10)
            needPoint.set(levelPoints._11-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._10)/Float(levelPoints._11-levelPoints._10)
            
        case levelPoints._11..<levelPoints._12: //2000
            level.set(11)
            needPoint.set(levelPoints._12-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._11)/Float(levelPoints._12-levelPoints._11)
            
        case levelPoints._12..<levelPoints._13: //2500
            level.set(12)
            needPoint.set(levelPoints._13-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._12)/Float(levelPoints._13-levelPoints._12)
            
        case levelPoints._13..<levelPoints._14: //3000
            level.set(13)
            needPoint.set(levelPoints._14-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._13)/Float(levelPoints._14-levelPoints._13)
            
        case levelPoints._14..<levelPoints._15: //3500
            level.set(14)
            needPoint.set(levelPoints._15-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._14)/Float(levelPoints._15-levelPoints._14)
            
        case levelPoints._15..<levelPoints._16: //4500
            level.set(15)
            needPoint.set(levelPoints._16-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._15)/Float(levelPoints._16-levelPoints._15)
            
        case levelPoints._16..<levelPoints._17: //6000
            level.set(16)
            needPoint.set(levelPoints._17-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._16)/Float(levelPoints._17-levelPoints._16)
            
        case levelPoints._17..<levelPoints._18: //8000
            level.set(17)
            needPoint.set(levelPoints._18-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._17)/Float(levelPoints._18-levelPoints._17)
            
        case levelPoints._18..<levelPoints._19: //10000
            level.set(18)
            needPoint.set(levelPoints._19-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._18)/Float(levelPoints._19-levelPoints._18)
            
        case levelPoints._19..<levelPoints._20: //12000
            level.set(19)
            needPoint.set(levelPoints._20-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._19)/Float(levelPoints._20-levelPoints._19)
            
        case levelPoints._20..<levelPoints._21: //15000
            level.set(20)
            needPoint.set(levelPoints._21-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._20)/Float(levelPoints._21-levelPoints._20)
            
        case levelPoints._21..<levelPoints._22: //20000
            level.set(21)
            needPoint.set(levelPoints._22-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._21)/Float(levelPoints._22-levelPoints._21)
            
        case levelPoints._22..<levelPoints._23: //23000
            level.set(22)
            needPoint.set(levelPoints._23-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._22)/Float(levelPoints._23-levelPoints._22)
            
        case levelPoints._23..<levelPoints._24: //25000
            level.set(23)
            needPoint.set(levelPoints._24-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._23)/Float(levelPoints._24-levelPoints._23)
            
        case levelPoints._24..<levelPoints._25: //30000
            level.set(24)
            needPoint.set(levelPoints._25-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._24)/Float(levelPoints._25-levelPoints._24)
            
        case levelPoints._25..<levelPoints._26: //35000
            level.set(25)
            needPoint.set(levelPoints._26-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._25)/Float(levelPoints._26-levelPoints._25)
            
        case levelPoints._26..<levelPoints._27: //40000
            level.set(26)
            needPoint.set(levelPoints._27-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._26)/Float(levelPoints._27-levelPoints._26)
            
        case levelPoints._27..<levelPoints._28: //50000
            level.set(27)
            needPoint.set(levelPoints._28-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._27)/Float(levelPoints._28-levelPoints._27)
            
        case levelPoints._28..<levelPoints._29: //50000
            level.set(28)
            needPoint.set(levelPoints._29-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._28)/Float(levelPoints._29-levelPoints._28)
            
        case levelPoints._29..<levelPoints._30: //50000
            level.set(29)
            needPoint.set(levelPoints._30-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._29)/Float(levelPoints._30-levelPoints._29)
            
        case levelPoints._30..<levelPoints._31: //100000
            level.set(30)
            needPoint.set(levelPoints._31-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._30)/Float(levelPoints._31-levelPoints._30)
            
        case levelPoints._31..<levelPoints._32: //100000
            level.set(31)
            needPoint.set(levelPoints._32-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._31)/Float(levelPoints._32-levelPoints._31)
            
        case levelPoints._32..<levelPoints._33: //100000
            level.set(32)
            needPoint.set(levelPoints._33-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._32)/Float(levelPoints._33-levelPoints._32)
            
        case levelPoints._33..<levelPoints._34: //100000
            level.set(33)
            needPoint.set(levelPoints._34-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._33)/Float(levelPoints._34-levelPoints._33)
            
        case levelPoints._34..<levelPoints._35: //100000
            level.set(34)
            needPoint.set(levelPoints._35-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._34)/Float(levelPoints._35-levelPoints._34)
            
        case levelPoints._35..<levelPoints._36: //100000
            level.set(35)
            needPoint.set(levelPoints._36-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._35)/Float(levelPoints._36-levelPoints._35)
            
        case levelPoints._36..<levelPoints._37: //200000
            level.set(36)
            needPoint.set(levelPoints._37-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._36)/Float(levelPoints._37-levelPoints._36)
            
        case levelPoints._37..<levelPoints._38: //200000
            level.set(37)
            needPoint.set(levelPoints._38-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._37)/Float(levelPoints._38-levelPoints._37)
            
        case levelPoints._38..<levelPoints._39: //200000
            level.set(38)
            needPoint.set(levelPoints._39-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._38)/Float(levelPoints._39-levelPoints._38)
            
        case levelPoints._39..<levelPoints._40: //200000
            level.set(39)
            needPoint.set(levelPoints._40-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._39)/Float(2_000_000-levelPoints._39)
            
        case levelPoints._40..<levelPoints._41: //300000 //2million
            level.set(40)
            needPoint.set(levelPoints._41-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._40)/Float(levelPoints._41-levelPoints._40)
            
        case levelPoints._41..<levelPoints._42: //300000
            level.set(41)
            needPoint.set(levelPoints._42-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._41)/Float(levelPoints._42-levelPoints._41)
            
        case levelPoints._42..<levelPoints._43: //300000
            level.set(42)
            needPoint.set(levelPoints._43-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._42)/Float(2_900_000-levelPoints._42)
            
        case levelPoints._43..<levelPoints._44: //300000
            level.set(43)
            needPoint.set(levelPoints._44-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._43)/Float(levelPoints._44-levelPoints._43)
            
        case levelPoints._44..<levelPoints._45: //300000
            level.set(44)
            needPoint.set(levelPoints._45-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._44)/Float(levelPoints._45-levelPoints._44)
            
        case levelPoints._45..<levelPoints._46: //300000
            level.set(45)
            needPoint.set(levelPoints._46-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._45)/Float(levelPoints._46-levelPoints._45)
            
        case levelPoints._46..<levelPoints._47: //300000
            level.set(46)
            needPoint.set(levelPoints._47-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._46)/Float(levelPoints._47-levelPoints._46)
            
        case levelPoints._47..<levelPoints._48: //400000
            level.set(47)
            needPoint.set(levelPoints._48-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._47)/Float(levelPoints._48-levelPoints._47)
            
        case levelPoints._48..<levelPoints._49: //400000
            level.set(48)
            needPoint.set(levelPoints._49-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._48)/Float(levelPoints._49-levelPoints._48)
            
        case levelPoints._49..<levelPoints._50: //400000
            level.set(49)
            needPoint.set(levelPoints._50-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._49)/Float(levelPoints._50-levelPoints._49)
            
        case levelPoints._50..<levelPoints._51: //400000
            level.set(50)
            needPoint.set(levelPoints._51-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._50)/Float(levelPoints._51-levelPoints._50)
            
        case levelPoints._51..<levelPoints._52: //500000
            level.set(51)
            needPoint.set(levelPoints._52-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._51)/Float(levelPoints._52-levelPoints._51)
            
        case levelPoints._52..<levelPoints._53: //500000
            level.set(52)
            needPoint.set(levelPoints._53-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._52)/Float(levelPoints._53-levelPoints._52)
            
        case levelPoints._53..<levelPoints._54: //500000
            level.set(53)
            needPoint.set(levelPoints._54-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._53)/Float(levelPoints._54-levelPoints._53)
            
        case levelPoints._54..<levelPoints._55: //500000
            level.set(54)
            needPoint.set(levelPoints._55-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._54)/Float(levelPoints._55-levelPoints._54)
            
        case levelPoints._55..<levelPoints._56: //500000
            level.set(55)
            needPoint.set(levelPoints._56-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._55)/Float(levelPoints._56-levelPoints._55)
            
        case levelPoints._56..<levelPoints._57: //500000
            level.set(56)
            needPoint.set(levelPoints._57-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._56)/Float(levelPoints._57-levelPoints._56)
            
        case levelPoints._57..<levelPoints._58: //500000
            level.set(57)
            needPoint.set(levelPoints._58-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._57)/Float(levelPoints._58-levelPoints._57)
            
        case levelPoints._58..<levelPoints._59: //500000
            level.set(58)
            needPoint.set(levelPoints._59-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._58)/Float(levelPoints._59-levelPoints._58)
            
        case levelPoints._59..<levelPoints._60: //500000
            level.set(59)
            needPoint.set(levelPoints._60-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._59)/Float(levelPoints._60-levelPoints._59)
            
        case levelPoints._60..<levelPoints._61: //600000
            level.set(60)
            needPoint.set(levelPoints._61-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._60)/Float(levelPoints._61-levelPoints._60)
            
        case levelPoints._61..<levelPoints._62: //1000000
            level.set(61)
            needPoint.set(levelPoints._62-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._61)/Float(levelPoints._62-levelPoints._61)
            
        case levelPoints._62..<levelPoints._63: //1000000
            level.set(62)
            needPoint.set(levelPoints._63-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._62)/Float(levelPoints._63-levelPoints._62)
            
        case levelPoints._63..<levelPoints._64: //1000000
            level.set(63)
            needPoint.set(levelPoints._64-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._63)/Float(levelPoints._64-levelPoints._63)
            
        case levelPoints._64..<levelPoints._65: //1000000
            level.set(64)
            needPoint.set(levelPoints._65-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._64)/Float(levelPoints._65-levelPoints._64)
            
        case levelPoints._65..<levelPoints._66: //1000000
            level.set(65)
            needPoint.set(levelPoints._66-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._65)/Float(levelPoints._66-levelPoints._65)
            
        case levelPoints._66..<levelPoints._67: //1000000
            level.set(66)
            needPoint.set(levelPoints._67-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._66)/Float(levelPoints._67-levelPoints._66)
            
        case levelPoints._67..<levelPoints._68: //1000000
            level.set(67)
            needPoint.set(levelPoints._68-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._67)/Float(levelPoints._68-levelPoints._67)
            
        case levelPoints._68..<levelPoints._69: //1000000
            level.set(68)
            needPoint.set(levelPoints._69-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._68)/Float(levelPoints._69-levelPoints._68)
            
        case levelPoints._69..<levelPoints._70: //1000000
            level.set(69)
            needPoint.set(levelPoints._70-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._69)/Float(levelPoints._70-levelPoints._69)
            
        case levelPoints._70..<levelPoints._71: //2000000 //20million
            level.set(70)
            needPoint.set(levelPoints._71-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._70)/Float(levelPoints._71-levelPoints._70)
            
        case levelPoints._71..<levelPoints._72: //2000000
            level.set(71)
            needPoint.set(levelPoints._72-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._71)/Float(levelPoints._72-levelPoints._71)
            
        case levelPoints._72..<levelPoints._73: //2000000
            level.set(72)
            needPoint.set(levelPoints._73-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._72)/Float(levelPoints._73-levelPoints._72)
            
        case levelPoints._73..<levelPoints._74: //2000000
            level.set(73)
            needPoint.set(levelPoints._74-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._73)/Float(levelPoints._74-levelPoints._73)
            
        case levelPoints._74..<levelPoints._75: //2000000
            level.set(74)
            needPoint.set(levelPoints._75-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._74)/Float(levelPoints._75-levelPoints._74)
            
        case levelPoints._75..<levelPoints._76: //2000000
            level.set(75)
            needPoint.set(levelPoints._76-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._75)/Float(levelPoints._76-levelPoints._75)
            
        case levelPoints._76..<levelPoints._77: //2000000
            level.set(76)
            needPoint.set(levelPoints._77-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._76)/Float(levelPoints._77-levelPoints._76)
            
        case levelPoints._77..<levelPoints._78: //2000000
            level.set(77)
            needPoint.set(levelPoints._78-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._77)/Float(levelPoints._78-levelPoints._77)
            
        case levelPoints._78..<levelPoints._79: //2000000
            level.set(78)
            needPoint.set(levelPoints._79-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._78)/Float(levelPoints._79-levelPoints._78)
            
        case levelPoints._79..<levelPoints._80: //2000000
            level.set(79)
            needPoint.set(levelPoints._80-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._79)/Float(levelPoints._80-levelPoints._79)
            
        case levelPoints._80..<levelPoints._81: //2000000
            level.set(80)
            needPoint.set(levelPoints._81-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._80)/Float(levelPoints._81-levelPoints._80)
            
        case levelPoints._81..<levelPoints._82: //2000000
            level.set(81)
            needPoint.set(levelPoints._82-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._81)/Float(levelPoints._82-levelPoints._81)
            
        case levelPoints._82..<levelPoints._83: //2000000
            level.set(82)
            needPoint.set(levelPoints._83-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._82)/Float(levelPoints._83-levelPoints._82)
            
        case levelPoints._83..<levelPoints._84: //2000000
            level.set(83)
            needPoint.set(levelPoints._84-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._83)/Float(levelPoints._84-levelPoints._83)
            
        case levelPoints._84..<levelPoints._85: //1000000
            level.set(84)
            needPoint.set(levelPoints._85-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._84)/Float(levelPoints._85-levelPoints._84)
            
        case levelPoints._85..<levelPoints._86: //1000000
            level.set(85)
            needPoint.set(levelPoints._86-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._85)/Float(levelPoints._86-levelPoints._85)
            
        case levelPoints._86..<levelPoints._87: //2000000
            level.set(86)
            needPoint.set(levelPoints._87-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._86)/Float(levelPoints._87-levelPoints._86)
            
        case levelPoints._87..<levelPoints._88: //2000000
            level.set(87)
            needPoint.set(levelPoints._88-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._87)/Float(levelPoints._88-levelPoints._87)
            
        case levelPoints._88..<levelPoints._89: //2000000
            level.set(88)
            needPoint.set(levelPoints._89-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._88)/Float(levelPoints._89-levelPoints._88)
            
        case levelPoints._89..<levelPoints._90: //2000000
            level.set(89)
            needPoint.set(levelPoints._90-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._89)/Float(levelPoints._90-levelPoints._89)
            
        case levelPoints._90..<levelPoints._91: //2000000
            level.set(90)
            needPoint.set(levelPoints._91-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._90)/Float(levelPoints._91-levelPoints._90)
            
        case levelPoints._91..<levelPoints._92: //4000000
            level.set(91)
            needPoint.set(levelPoints._92-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._91)/Float(levelPoints._92-levelPoints._91)
            
        case levelPoints._92..<levelPoints._93: //4000000
            level.set(92)
            needPoint.set(levelPoints._93-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._92)/Float(levelPoints._93-levelPoints._92)
            
        case levelPoints._93..<levelPoints._94: //4000000
            level.set(93)
            needPoint.set(levelPoints._94-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._93)/Float(levelPoints._94-levelPoints._93)
            
        case levelPoints._94..<levelPoints._95: //4000000
            level.set(94)
            needPoint.set(levelPoints._95-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._94)/Float(levelPoints._95-levelPoints._94)
            
        case levelPoints._95..<levelPoints._96: //4000000
            level.set(95)
            needPoint.set(levelPoints._96-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._95)/Float(levelPoints._96-levelPoints._95)
            
        case levelPoints._96..<levelPoints._97: //5000000
            level.set(96)
            needPoint.set(levelPoints._97-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._96)/Float(levelPoints._97-levelPoints._96)
            
        case levelPoints._97..<levelPoints._98: //5000000
            level.set(97)
            needPoint.set(levelPoints._98-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._97)/Float(levelPoints._98-levelPoints._97)
            
        case levelPoints._98..<levelPoints._99: //5000000
            level.set(98)
            needPoint.set(levelPoints._99-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._98)/Float(levelPoints._99-levelPoints._98)
            
        case levelPoints._99..<levelPoints._100: //5000000
            level.set(99)
            needPoint.set(levelPoints._100-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._99)/Float(levelPoints._100-levelPoints._99)
            
        case levelPoints._100..<676_000_000:
            level.set(100)
            needPoint.set(676_000_000-lastSavedPoint)
            return Float(lastSavedPoint-levelPoints._100)/Float(676_000_000-levelPoints._100)
            
        case 676_000_000..<2_147_483_646:
            level.set(676)
            needPoint.set(0)
            return 1.0

        default:
            level.set(0)
            needPoint.set(0-lastSavedPoint)
            return 1.0
            
        }
    }
}
