//
//  String.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

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
    
    func convertFromBackendDateString() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        formatter.locale = Locale(identifier: "en_US_POSIX") 
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
    
    public func convertToShortDateFormat(from inputFormat: String = "MM/dd/yy") -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputFormat
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "E, MMM dd"
            return outputDateFormatter.string(from: date)
        }
        return nil
    }
    
    public func convertToShorterDateFormat(from inputFormat: String = "MM/dd/yy") -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputFormat
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MMM dd"
            return outputDateFormatter.string(from: date)
        }
        return nil
    }
    
    func toBackendDate2(from inputFormat: String = "MM/dd/yyyy", to outputFormat: String = "yyyy-MM-dd") -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputFormat
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputFormat
            return outputDateFormatter.string(from: date)
        }
        return nil // Return nil if the conversion fails
    }
    
    func toBackendDate(from inputFormat: String = "dd/MM/yyyy", to outputFormat: String = "MM/dd/yyyy") -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = inputFormat
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = outputFormat
            return outputDateFormatter.string(from: date)
        }
        return nil // Return nil if the conversion fails
    }
    
    func toBackendTime() -> String? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "HH:mm:ss"
        inputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = inputDateFormatter.date(from: self) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "HH:mm"
            outputDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputDateFormatter.string(from: date)
        }
        return nil
    }

    func fromBackendTime() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: self)
    }


    @MainActor
    public func loadImage(into imageView: UIImageView, placeholder: String = "dummy") {
        guard !self.isEmpty,
              let url = URL(string: self.replacingOccurrences(of: "http://", with: "https://")) else {
            imageView.image = UIImage(named: placeholder)
            return
        }
        
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: placeholder))
    }

    func toAmount() -> String? {
        // Try to convert the string to a Double
        guard let value = Double(self) else { return nil }

        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        // Uncomment this if you want a custom grouping separator
        // formatter.groupingSeparator = ","

        return formatter.string(from: NSNumber(value: value))
    }
    
    public func separateDateAndTime() -> (date: String, time: String)? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"

        guard let date = formatter.date(from: self) else {
            return nil
        }

        formatter.dateFormat = "MM/dd/yyyy"
        let dateString = formatter.string(from: date)

        formatter.dateFormat = "hh:mm a"
        let timeString = formatter.string(from: date)

        return (date: dateString, time: timeString)
    }


}
