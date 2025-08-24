//
//  Double.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/07/2025.
//

import Foundation

extension Double {
    func toAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
//        formatter.groupingSeparator = ","
        
        if let formatted = formatter.string(from: NSNumber(value: self)) {
            return formatted
        }

        return nil
    }
}

extension Float {
    func toAmount() -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
//        formatter.groupingSeparator = ","
        
        if let formatted = formatter.string(from: NSNumber(value: self)) {
            return formatted
        }

        return nil
    }
}
