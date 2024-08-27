//
//  String+Extensions.swift
//  Kelime Kumbaram
//
//  Created by ibrahim uysal on 24.07.2022.
//

import UIKit

extension String {

    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
    
    func strikeThrough() -> NSAttributedString {
      let attributeString = NSMutableAttributedString(string: self)
      attributeString.addAttribute(
        NSAttributedString.Key.strikethroughStyle,
        value: 1,
        range: NSRange(location: 0, length: attributeString.length))

        return attributeString
    }
    
    func replace(_ index: Int, _ newChar: String) -> String {
        let nchar: Character = newChar[0]
        var chars = Array(self)     // gets an array of characters
        chars[index] = nchar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }

    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    
    func strikeUserAnswerAndGetCorrect(_ trueAnswer: String) -> NSMutableAttributedString {
        let boldFontAttributes = [NSAttributedString.Key.font: Fonts.AvenirNextMedium15]
        
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        
        let partOne = NSMutableAttributedString(string: "Your answer:\n", attributes: normalFontAttributes)
        
        let partTwo = self.strikeThrough()
        
        let partThree = NSMutableAttributedString(string: "\nCorrect answer: \n", attributes: normalFontAttributes)
        
        let partFour = NSMutableAttributedString(string: trueAnswer, attributes: boldFontAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()
            
        combination.append(partOne)
        combination.append(partTwo)
        combination.append(partThree)
        combination.append(partFour)
        
        return combination
    }
}
