//
//  DiscountField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import Foundation
import UIKit

class DiscountField: InputField {
    
    private let percentageSymbol = "%"
    
    override func setup() {
        super.setup()
//        textField.heightAnchor.constraint(equalToConstant: 70).isActive = true
        textField.font = UIFont.systemFont(ofSize: 40, weight: .medium)
        textField.textAlignment = .left
        textField.backgroundColor = .white
        
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        var cleanText = updatedText.replacingOccurrences(of: percentageSymbol, with: "")
        
        if !cleanText.isEmpty {
            cleanText = percentageSymbol + cleanText
        }
        
        let attributedText = NSMutableAttributedString(string: cleanText)
        let percentageRange = (cleanText as NSString).range(of: percentageSymbol)
        
        // Set color for the percentage symbol
        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: percentageRange) // Change to any color you prefer
        
        // Set the attributed text to the textField
        textField.attributedText = attributedText
                
        
        textChanged(textField, range, string)
        onTextChanged?(cleanText)
        
        return false
    }
    
    public func getDoubleValue() -> Double? {
        guard let text = textField.text else { return nil }
        
        // Remove the percentage symbol and any whitespace
        let numericText = text.replacingOccurrences(of: percentageSymbol, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert the remaining text to Double
        return Double(numericText)
    }

    public func getIntValue() -> Int? {
        guard let text = textField.text else { return nil }
        
        // Remove the percentage symbol and any whitespace
        let numericText = text.replacingOccurrences(of: percentageSymbol, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert the remaining text to Double
        return Int(numericText)
    }

}

