//
//  SendChatResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

struct SendChatResponse: Codable{
    let data: SendChatResponseData?
}

// MARK: - DataClass
struct SendChatResponseData: Codable {
    let id, user1_ID, user2_ID, bookingID: String
    let propertyType, lastMessage: String

    enum CodingKeys: String, CodingKey {
        case id
        case user1_ID = "user_1_id"
        case user2_ID = "user_2_id"
        case bookingID = "booking_id"
        case propertyType = "property_type"
        case lastMessage = "last_message"
    }
}
