//
//  GeneralFormatter.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import Foundation

public class GeneralFormatter{
    
    public static func moneyStringToDouble(amountString: String, currency: String) -> Double {
        let comma = ","
        
        let cleanAmount = amountString
            .replacingOccurrences(of: currency, with: "")
            .replacingOccurrences(of: comma, with: "")
        
        if let amount = Double(cleanAmount) {
            return amount
        }
        else{
            return 0
        }
    }
    
    public static func moneyToWords(amount: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        return (formatter.string(for: amount) ?? "") + " naira only"
    }
}

