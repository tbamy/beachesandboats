//
//  Validator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import Foundation


public enum ValidatorRule {
    case isValidEmail
    case isValidPhoneNumber
    case isValidPassword
    case isEmpty
    case isDigit
    case hasSymbol
    case hasNumber
    case hasUpperCase
    case hasLowerCase
    case isEqualTo
    case isGreaterThan
    case isLessThan
    case isGreaterThanOrEqualTo
    case isLessThanOrEqualTo
    case isLettersOnly
    case doesNotContainSpace
    case containsSubstring
    
    public func execute(_ text: String) -> Bool {
        switch self {
        case .isValidEmail:
            return isValidEmail(text)
        case .isValidPhoneNumber:
            return isValidPhoneNumber(text)
        case .isValidPassword:
            return isValidPassword(text)
        case .isEmpty:
            return isEmpty(text)
        case .isDigit:
            return isValidDigitsOnly(text)
        case .hasSymbol:
            return containsSymbol(text)
        case .hasNumber:
            return containsNumber(text)
        case .hasUpperCase:
            return containsUppercaseLetters(text)
        case .hasLowerCase:
            return containsLowercaseLetters(text)
        case .isLettersOnly:
            return containsLettersOnly(text)
        case .doesNotContainSpace:
            return doesNotContainSpace(text)
        default:
            return false
        }
    }
    
    public func execute<T: Comparable>(_ value1: T, _ value2: T) -> Bool {
        switch self {
        case .isEqualTo:
            return isEqualTo(value1: value1, value2: value2)
        case .isGreaterThan:
            return isGreaterThan(value1: value1, value2: value2)
        case .isGreaterThanOrEqualTo:
            return isGreaterThanorEqualTo(value1: value1, value2: value2)
        case .isLessThan:
            return isLessThan(value1: value1, value2: value2)
        case .isLessThanOrEqualTo:
            return isLessThanOrEqualTo(value1: value1, value2: value2)
        case .containsSubstring:
            return containsSubstring(value1 as! String, value2 as! String)
        default:
            return false
        }
    }
    
    public func isEmpty(_ text: String) -> Bool {
        return text.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }
    
    public func isEqualTo<T: Comparable>(value1: T, value2: T) -> Bool {
        value1 == value2
    }
    
    public func isGreaterThan<T: Comparable>(value1: T, value2: T) -> Bool {
        value1 > value2
    }
    
    public func isLessThan<T: Comparable>(value1: T, value2: T) -> Bool {
        value1 < value2
    }
    
    public func isGreaterThanorEqualTo<T: Comparable>(value1: T, value2: T) -> Bool {
        value1 >= value2
    }
    
    public func isLessThanOrEqualTo<T: Comparable>(value1: T, value2: T) -> Bool {
        value1 <= value2
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^[+]?[0-9]{10,14}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phoneNumber)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        // Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character
        let passwordRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
        let passwordPred = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordPred.evaluate(with: password)
    }
    
    func containsLettersOnly(_ inputString: String) -> Bool {
        let lettersOnlyRegEx = "^[a-zA-Z]*$"
        let lettersOnlyPred = NSPredicate(format: "SELF MATCHES %@", lettersOnlyRegEx)
        return lettersOnlyPred.evaluate(with: inputString)
    }
    
    public func isValidDigitsOnly(_ string: String) -> Bool {
        let digitsOnlyRegEx = "^[0-9]+$"
        let digitsOnlyPred = NSPredicate(format: "SELF MATCHES %@", digitsOnlyRegEx)
        return digitsOnlyPred.evaluate(with: string)
    }
    
    public func containsSymbol(_ string: String) -> Bool {
        let symbolsRegEx = ".*[^a-zA-Z0-9\\s].*"
        let symbolsPred = NSPredicate(format: "SELF MATCHES %@", symbolsRegEx)
        return symbolsPred.evaluate(with: string)
    }
    
    public func containsNumber(_ string: String) -> Bool {
        let numberRegEx = ".*\\d+.*"
        let numberPred = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        return numberPred.evaluate(with: string)
    }
    
    public func containsUppercaseLetters(_ string: String) -> Bool {
        let uppercaseLettersRegEx = ".*[A-Z]+.*"
        let uppercaseLettersPred = NSPredicate(format: "SELF MATCHES %@", uppercaseLettersRegEx)
        return uppercaseLettersPred.evaluate(with: string)
    }
    
    public func containsLowercaseLetters(_ string: String) -> Bool {
        let lowercaseLettersRegEx = ".*[a-z]+.*"
        let lowercaseLettersPred = NSPredicate(format: "SELF MATCHES %@", lowercaseLettersRegEx)
        return lowercaseLettersPred.evaluate(with: string)
    }
    
    public func doesNotContainSpace(_ string: String) -> Bool {
        return !string.contains(" ")
    }
    
    public func containsSubstring(_ text: String, _ substring: String) -> Bool {
        return text.contains(substring)
    }
            
}

public class Validator {
    var checks: [FieldChecker]
    var isValid: Bool = true
    
    public init(checks: [FieldChecker]) {
        self.checks = checks
    }
    
    public func validate() -> Bool {
        var errorFields: [InputField] = []
        checks.forEach { check in
            check.fields.forEach { field in
                check.rule.forEach {
                    if !$0.rule.execute(field.text), !errorFields.contains(field) {
                        field.error = $0.message
                        isValid = false
                        errorFields.append(field)
                    } else if !errorFields.contains(field) {
                        field.error = ""
                    }
                }
            }
        }
        return isValid
     }
    
    public static func clearFieldErrors(fields: [InputField]){
        for field in fields {
            field.error = ""
        }
    }
}


public class SingleValidator {
    var field: InputField
    var rules: [Rule]

    public init(field: InputField, rules: [Rule]) {
        self.field = field
        self.rules = rules
    }

    public func validate() -> Bool {
        field.error = ""
        rules.forEach {
            if !$0.rule.execute(field.text), field.error.isEmpty {
                field.error = ($0.message)
            }
        }
        return field.error.isEmpty
     }
}


public class RelationalSingleValidator {
    var field: InputField
    var rules: [Rule]
    
    public init(field: InputField, rules: [Rule]) {
        self.field = field
        self.rules = rules
    }
    
    public func validate<T: Comparable>(v1: T, v2: T) -> Bool {
        field.error = ""
        rules.forEach {
            switch $0.rule {
            case .isGreaterThan, .isLessThan, .isLessThanOrEqualTo, .isGreaterThanOrEqualTo, .isEqualTo:
                if !$0.rule.execute(v1, v2), field.error.isEmpty {
                    field.error = ($0.message)
                }
            default:
                if !$0.rule.execute(field.text), field.error.isEmpty {
                    field.error = ($0.message)
                }
            }
        }
        return field.error.isEmpty
     }
}

public struct FieldChecker {
    var fields: [InputField]
    var rule: [Rule]
    
    public init(fields: [InputField], rule: [Rule]) {
        self.fields = fields
        self.rule = rule
    }
}



public struct Rule {
    public var rule: ValidatorRule
    public var message: String
    
    public init(_ rule: ValidatorRule, _ message: String) {
        self.rule = rule
        self.message = message
    }
}

