//
//  StartConversationResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

struct StartConversationResponse: Codable{
    let data: StartConversationData?
}

// MARK: - DataClass
struct StartConversationData: Codable {
    let id, user1_ID, user2_ID: String
    let bookingID: String?
    let propertyType: String?
    let lastMessage: String?
    let beachHouseBooking: BeachHouseBooking?
    let boatBooking: BoatBooking?

    enum CodingKeys: String, CodingKey {
        case id
        case user1_ID = "user_1_id"
        case user2_ID = "user_2_id"
        case bookingID = "booking_id"
        case propertyType = "property_type"
        case lastMessage = "last_message"
        case beachHouseBooking = "beach_house_booking"
        case boatBooking = "boat_booking"
    }
}
