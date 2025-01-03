//
//  BigMoneyInputField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import Foundation
import UIKit

class BigMoneyInputField: InputField {

public var currency: String = "₦"
public var amountChanged: () -> Void = {}

@IBInspectable public var currencySymbol: String?{
    set{
        currency = newValue ?? "₦"
    }get{
        return currency
    }
}

override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
}

required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
}

override func setup() {
    super.setup()
    textField.keyboardType = .decimalPad
    textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    textField.textAlignment = .left
//    textField.backgroundColor = .white
}

    @objc func editingChanged() {
        if let text = textField.text {
            textField.text = formatNumber(text)
            if let amount = getIntValue() {
                amountChanged()
            }
        }
    }


public override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    error = ""
    // Check if the input is a valid number (digits, decimal point, or backspace)
    let allowedCharacterSet = CharacterSet(charactersIn: "0123456789.").union(CharacterSet(charactersIn: ""))
    let enteredCharacterSet = CharacterSet(charactersIn: string)
    let isNumber = allowedCharacterSet.isSuperset(of: enteredCharacterSet)
    
    if isNumber {
        // Check if the text already contains a decimal point
        let currentText = textField.text ?? ""
        let isExistingDecimalPoint = currentText.contains(".")
        
        if string == "." && isExistingDecimalPoint {
            // If the entered character is a decimal point and there is already one, don't allow it
            return false
        } else {
            // If the entered character is a digit, backspace, or decimal point (and there isn't one), allow it
            
            return true
        }
    } else {
        // If the entered character is not a valid number character, don't allow it
        return false
    }
}

func formatNumber(_ number: String) -> String {
    
    // Remove commas before formatting the number with comma separators and limiting decimal places to two
    var numberWithoutCommas = number.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: currency, with: "")
    
    // Format the number with comma separators and limit decimal places to two
    if numberWithoutCommas.last == "." {
        // Remove the trailing decimal point and add it back after formatting
        numberWithoutCommas.removeLast()
        if let formattedNumber = Formatter.numberWithCommasAndTwoDecimalPlaces(numberWithoutCommas, currency) {
            return formattedNumber + "."
        }
    } else {
        if let formattedNumber = Formatter.numberWithCommasAndTwoDecimalPlaces(numberWithoutCommas, currency) {
            return formattedNumber
        }
    }
    return number
}


}

struct Formatter {
static func numberWithCommasAndTwoDecimalPlaces(_ number: String,_ currency: String) -> String? {
    let components = number.components(separatedBy: ".")
    guard components.count <= 2 else { return number }
    
    let integerPart = components.first ?? "0"
    let decimalPart = components.count == 2 ? components[1] : ""
    
    // Ensure at most two digits in the decimal part
    let truncatedDecimalPart = String(decimalPart.prefix(2))
    
    var formattedNumber = addCommas(to: integerPart)
    if !truncatedDecimalPart.isEmpty {
        formattedNumber += "." + truncatedDecimalPart
    }
    
    if formattedNumber.isEmpty{
        return ""
    } else {
        return currency + formattedNumber
    }
    
}

private static func addCommas(to number: String) -> String {
    guard let integerValue = Int(number) else { return number }
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .decimal
    return numberFormatter.string(from: NSNumber(value: integerValue)) ?? number
}

}


extension BigMoneyInputField{
    public func getDoubleValue() -> Double? {
        guard let text = textField.text else { return nil }
        return formattedStringToDouble(text, currencySymbol: currency)
    }

    func formattedStringToDouble(_ formattedString: String, currencySymbol: String) -> Double? {
        let stringWithoutCurrency = formattedString.replacingOccurrences(of: currencySymbol, with: "")
        let stringWithoutCommas = stringWithoutCurrency.replacingOccurrences(of: ",", with: "")
        let trimmedString = stringWithoutCommas.trimmingCharacters(in: .whitespacesAndNewlines)
        return Double(trimmedString)
    }
    
    func formattedStringToInt(_ formattedString: String, currencySymbol: String) -> Int? {
        let stringWithoutCurrency = formattedString.replacingOccurrences(of: currencySymbol, with: "")
        let stringWithoutCommas = stringWithoutCurrency.replacingOccurrences(of: ",", with: "")
        let trimmedString = stringWithoutCommas.trimmingCharacters(in: .whitespacesAndNewlines)
        return Int(trimmedString)
    }
    
    public func getIntValue() -> Int? {
        guard let text = textField.text else { return nil }
        return formattedStringToInt(text, currencySymbol: currency)
    }

}
