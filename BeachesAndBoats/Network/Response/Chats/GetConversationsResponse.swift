//
//  GetConversationsResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

struct GetConversationsResponse: Codable{
    let data: GetConversationsData?
}

// MARK: - Datum
struct GetConversationsData: Codable {
    let id, user1_ID, user2_ID: String
    let bookingID, propertyType: String?
    let lastMessage: String?
    let otherUser: OtherUser
    let unreadMessages: Int

    enum CodingKeys: String, CodingKey {
        case id
        case user1_ID = "user_1_id"
        case user2_ID = "user_2_id"
        case bookingID = "booking_id"
        case propertyType = "property_type"
        case lastMessage = "last_message"
        case otherUser = "other_user"
        case unreadMessages = "unread_messages"
    }
}

// MARK: - OtherUser
struct OtherUser: Codable {
    let id, firstName, lastName, email: String
    let phoneCode, phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
    }
}
