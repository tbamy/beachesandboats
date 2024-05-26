//
//  String.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

extension String {
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
    
    
}

