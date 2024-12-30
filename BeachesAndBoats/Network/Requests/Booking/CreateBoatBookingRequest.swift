//
//  CreateBoatBookingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

struct CreateBoatBookingRequest: Codable {
    let boatId: String
    let subCategoryId: String
    let userId: String
    let bookingDate: String
    let bookingTime: String
    let bookingType: String
    let numberOfPeople: Int
    let destinationId: String
    let cruiseLength: Int

    enum CodingKeys: String, CodingKey {
        case boatId = "boat_id"
        case subCategoryId = "sub_category_id"
        case userId = "user_id"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case bookingType = "booking_type"
        case numberOfPeople = "no_of_people"
        case destinationId = "destination_id"
        case cruiseLength = "cruise_length"
    }
}

