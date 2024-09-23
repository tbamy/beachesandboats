//
//  String.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

extension String {
    public static func toReadableDate(date: Date) -> String {
        let readableDateFormatter = DateFormatter()
        readableDateFormatter.dateFormat = "dd/MM/yyyy"
        readableDateFormatter.timeZone = TimeZone.current
        return readableDateFormatter.string(from: date)
    }
    
    public func toDecimal() -> Decimal? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .decimal

        if let number = formatter.number(from: self) {
            let decimal = number.decimalValue
            return decimal
        }
        
        return nil
    }
    
    var containsSpecialCharacter: Bool {
          let regex = ".*[^A-Za-z0-9].*"
          let testString = NSPredicate(format:"SELF MATCHES %@", regex)
          return testString.evaluate(with: self)
       }
    
    public func toReadableDate(date: Date) -> String {
        let readableDateFormatter = DateFormatter()
        readableDateFormatter.dateStyle = .short
        return readableDateFormatter.string(from: date)
    }
    
    public func toReadableDate() -> String? {
        if let date = fromBackendDateString() {
            let readableDateFormatter = DateFormatter()
            readableDateFormatter.dateStyle = .short
            return readableDateFormatter.string(from: date)
        }
        return nil
    }
    
    func fromBackendDateString() -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: self)
    }
    
    public func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }
    
    public func encode<T: Decodable>() -> T? {
        if let data = self.data(using: .utf8) {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    public func convertFromBackendDate(from newDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // New format

        if let date = dateFormatter.date(from: newDateString) {
            dateFormatter.dateFormat = "dd/MM/yyyy" // Old format
            let oldDateString = dateFormatter.string(from: date)
            return oldDateString
        }
        return nil // Return nil if conversion fails
    }
    
    public func convertFromBackendDate(from newDateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // Backend format (input)
        return dateFormatter.date(from: newDateString)
    }

    
    public func convertToBackendDate(from oldDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy" // Old format

        if let date = dateFormatter.date(from: oldDateString) {
            dateFormatter.dateFormat = "yyyy-MM-dd" // New format
            let newDateString = dateFormatter.string(from: date)
            return newDateString
        }
        return nil // Return nil if conversion fails
    }


}
