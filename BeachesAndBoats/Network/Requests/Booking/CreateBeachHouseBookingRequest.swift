//
//  CreateBeachHouseBookingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

struct CreateBeachHouseBookingRequest: Codable {
    var userId: String
    var beachHouseRoomId: String
    var checkingDate: String
    var checkoutDate: String
    var checkingTime: String
    var checkoutTime: String
    var numberOfPeople: Int
    var amount: Float
    var units: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case beachHouseRoomId = "beach_house_room_id"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case numberOfPeople = "no_of_people"
        case amount
        case units
    }
}

