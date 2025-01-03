//
//  NetworkUtility.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import Foundation
class NetworkUtility {
    static func toParameter<T: Codable>(_ structInstance: T?) -> [String: Any] {
        var dictionary = [String: Any]()
        
        if let structInstance = structInstance {
            let mirror = Mirror(reflecting: structInstance)
            for case let (label?, value) in mirror.children {
                // Check if the value is an Optional and unwrap it if possible
                if let unwrappedValue = unwrapOptional(value) {
                    dictionary[label] = unwrappedValue
                } else {
                    dictionary[label] = value
                }
            }
        }
        
        return dictionary
    }
    
    // Helper function to unwrap Optional values
    private static func unwrapOptional(_ value: Any) -> Any? {
        let mirror = Mirror(reflecting: value)
        if mirror.displayStyle == .optional {
            return mirror.children.first?.value
        }
        return value
    }
}
