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
    public var amountChanged: () -> Void = {}
    
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

        // Clean text (remove %)
        var cleanText = updatedText.replacingOccurrences(of: percentageSymbol, with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Prevent more than 3 digits
        if cleanText.count > 3 { return false }

        // If not empty, check for number and ensure it's <= 100
        if let numericValue = Int(cleanText), numericValue > 100 {
            return false
        }

        // Re-add percentage symbol for display
        if !cleanText.isEmpty {
            cleanText = percentageSymbol + cleanText
        }

        let attributedText = NSMutableAttributedString(string: cleanText)
        let percentageRange = (cleanText as NSString).range(of: percentageSymbol)

        attributedText.addAttribute(.foregroundColor, value: UIColor.gray, range: percentageRange)
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
    
    public func getFloatValue() -> Float? {
        guard let text = textField.text else { return nil }
        
        // Remove the percentage symbol and any whitespace
        let numericText = text.replacingOccurrences(of: percentageSymbol, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert the remaining text to Double
        return Float(numericText)
    }

    public func getIntValue() -> Int? {
        guard let text = textField.text else { return nil }
        
        // Remove the percentage symbol and any whitespace
        let numericText = text.replacingOccurrences(of: percentageSymbol, with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Convert the remaining text to Double
        return Int(numericText)
    }

}

