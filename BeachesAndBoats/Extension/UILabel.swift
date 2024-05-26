//
//  UILabel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

extension UILabel {
    
    public func setMiniTextAttribute(text: String, textPortion: [String]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let attr = [NSAttributedString.Key.font: UIFont(name: "Montserrat", size: 12)!]
        textPortion.forEach {
            let range = (text as NSString).range(of: $0)
            attributedString.addAttributes(attr, range: range)
        }
        return attributedString
    }
    
    public func setBoldAttribute(boldPartOfString: [String], size: CGFloat = 14) {
        let attributedText = NSMutableAttributedString(string: text!)
        boldPartOfString.forEach {
            let range = (text! as NSString).range(of: $0)
            attributedText.addAttribute(NSAttributedString.Key.font, value: Fonts.getFont(name: .SemiBold, size), range: range)
        }
        self.attributedText = attributedText
    }
    
    public func setlinkAttribute(boldPartOfString: [String], size: CGFloat = 14) {
        let attributedText = NSMutableAttributedString(string: text!)
        boldPartOfString.forEach {
            let range = (text! as NSString).range(of: $0)
            attributedText.addAttribute(NSAttributedString.Key.font, value: Fonts.getFont(name: .SemiBold, size), range: range)
//            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.alatRed, range: range)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
        }
        self.attributedText = attributedText
    }
}

