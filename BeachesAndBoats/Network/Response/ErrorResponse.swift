//
//  ErrorResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

//struct ErrorResponse: Codable, Error {
//    let message: String?
//    let status: Bool?
////    let errors: [String: [String]]?
//    let errors: [String]?
//}

struct ErrorResponse: Codable, Error {
    let message: String?
    let status: Bool?
    let errors: ErrorContainer?
    
    // Add default initializer for manual creation
    init(message: String?, status: Bool?, errors: ErrorContainer? = nil) {
        self.message = message
        self.status = status
        self.errors = errors
    }
}

// This enum can handle both error formats
enum ErrorContainer: Codable {
    case list([String])
    case dictionary([String: [String]])

    var allMessages: [String] {
        switch self {
        case .list(let messages):
            return messages
        case .dictionary(let dict):
            return dict.flatMap { $0.value }
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let dict = try? container.decode([String: [String]].self) {
            self = .dictionary(dict)
        } else if let list = try? container.decode([String].self) {
            self = .list(list)
        } else {
            throw DecodingError.typeMismatch(
                ErrorContainer.self,
                DecodingError.Context(codingPath: decoder.codingPath,
                                      debugDescription: "Expected [String] or [String: [String]] for `errors`")
            )
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .list(let messages):
            try container.encode(messages)
        case .dictionary(let dict):
            try container.encode(dict)
        }
    }
}
