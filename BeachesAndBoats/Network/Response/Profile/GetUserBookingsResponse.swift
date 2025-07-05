//
//  GetUserBookingsResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation


struct GetUserBookingsResponse: Codable{
    let data: UserBookingsData?
}

struct UserBookingsData: Codable{
    let beachHouseBookings: BeachHouseBookings?
    let boatBookings: BoatBookings?
}

// MARK: - BeachHouseBookings
struct BeachHouseBookings: Codable {
    let upcoming, past: [BeachHouseBookingsPast]?
}

// MARK: - BeachHouseBookingsPast
struct BeachHouseBookingsPast: Codable {
    let id, hostID: String
    let beachHouseRoom: BookingsBeachHouseRoom?
    let beachHouse: FavouriteBeachHouse?
    let checkingDate, checkoutDate, checkingTime, checkoutTime: String?
    let noOfPeople: String?//Int?
    let status: String?
    let summary: String?
    let units: String?
    let total: Double? //Int?

    enum CodingKeys: String, CodingKey {
        case id
        case hostID = "host_id"
        case beachHouseRoom = "beach_house_room"
        case beachHouse = "beach_house"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case noOfPeople = "no_of_people"
        case status, summary, units, total
    }
}

// MARK: - BeachHouse


// MARK: - BeachHouseRoom
struct BookingsBeachHouseRoom: Codable {
    let id, name, description: String
    let pricePerNight: Float
    let discountPercent: Int
    let images: [Image]
    let bedTypes: [BookingBedType]
    let noOfOccupant, hasPrivateBathroom: String

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images, bedTypes
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
    }
}

// MARK: - BoatBookings
struct BoatBookings: Codable {
    let upcoming, past: [BoatBookingsPast]?
}

// MARK: - BoatBookingsPast
struct BoatBookingsPast: Codable {
    let boat: FavouriteBoat
    let total: Int
    let summary: String?
    let status: String
    let cruiseLength: Int
    let bookingType: String
    let noOfPeople: String//Int
    let bookingDate, bookingTime, hostID: String
    let boatDestination: String?
    let subCategory: SubCategory

    enum CodingKeys: String, CodingKey {
        case boat, total, summary, status
        case cruiseLength = "cruise_length"
        case bookingType = "booking_type"
        case noOfPeople = "no_of_people"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case hostID = "host_id"
        case boatDestination = "boat_destination"
        case subCategory = "sub_category"
    }
}
