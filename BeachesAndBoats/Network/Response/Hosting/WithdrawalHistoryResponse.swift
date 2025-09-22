//
//  WithdrawalHistoryResponse.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import Foundation


//struct WithdrawalResponse: Codable {
//    let status: Bool?
//    let message: String?
//    let data: [String: [WithdrawalDetail]]? 
//    let errors: String?
//}
//
//struct WithdrawalDetail: Codable {
//    let id: String?
//    let amount: Decimal?
//    let status: String?
//    let createdAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case amount
//        case status
//        case createdAt = "created_at"
//    }
//}

struct WithdrawalResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [String: [WithdrawalDetail]]?
    let errors: String?

    enum CodingKeys: String, CodingKey {
        case status, message, data, errors
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decodeIfPresent(Bool.self, forKey: .status)
        message = try container.decodeIfPresent(String.self, forKey: .message)
        errors = try container.decodeIfPresent(String.self, forKey: .errors)

        // Try decoding data as a dictionary first
        if let dataDict = try? container.decodeIfPresent([String: [WithdrawalDetail]].self, forKey: .data) {
            data = dataDict
        }
        // If dictionary decoding fails, try decoding as an empty array
        else if let dataArray = try? container.decodeIfPresent([WithdrawalDetail].self, forKey: .data), dataArray.isEmpty {
            data = [:] // Map empty array to empty dictionary
        } else {
            data = nil // Handle any other case
        }
    }
}

struct WithdrawalDetail: Codable {
    let id: String?
    let amount: Decimal?
    let status: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case status
        case createdAt = "created_at"
    }
}
