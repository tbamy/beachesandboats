//
//  CreateBoatBookingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

struct CreateBoatBookingRequest: Codable {
    var boatId: String
//    let subCategoryId: String
    var userId: String
    var bookingDate: String
    var bookingTime: String
    var bookingType: String
    var numberOfPeople: Int
    var destinationId: String
    var cruiseLength: Int

    enum CodingKeys: String, CodingKey {
        case boatId = "boat_id"
//        case subCategoryId = "sub_category_id"
        case userId = "user_id"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case bookingType = "booking_type"
        case numberOfPeople = "no_of_people"
        case destinationId = "destination_id"
        case cruiseLength = "cruise_length"
    }
}

