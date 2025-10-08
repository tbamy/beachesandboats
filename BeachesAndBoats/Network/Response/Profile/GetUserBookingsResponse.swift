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
    let hostFirstName, hostLastName: String?
    let beachHouseRoom: BookingsBeachHouseRoom?
    let beachHouse: BookingsBeachHouse?
    let checkingDate, checkoutDate, checkingTime, checkoutTime: String?
    let noOfPeople: Int?
    let status: String?
    let summary: String?
    let units: Int?
    let total: Float? //Int?
    let adminCharge: Float?
    let noOfNights: Int?
    let bookingType: String?
    let propertyBookingType: String?
    let unitPrice: Float?

    enum CodingKeys: String, CodingKey {
        case id
        case hostID = "host_id"
        case hostFirstName = "host_first_name"
        case hostLastName = "host_last_name"
        case beachHouseRoom = "beach_house_room"
        case beachHouse = "beach_house"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case noOfPeople = "no_of_people"
        case status, summary, units, total
        case adminCharge = "admin_charge"
        case noOfNights  = "no_of_nights"
        case bookingType = "booking_type"
        case propertyBookingType = "property_booking_type"
        case unitPrice = "unit_price"
    }
}

// MARK: - BeachHouse

struct BookingsBeachHouse: Codable {
    let id, name, description, aboutOwner: String?
    let listingPrice, discountPercent, pricePerDay, actualPricePerDay, actualPricePerNight: Float?
    let image: String?
    let locations: Location?
    let availabilities: Availabilities?
    let rating: Double?
    let bookingType: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case image, locations, availabilities, rating
        case bookingType = "booking_type"
        case pricePerDay = "price_per_day"
        case actualPricePerDay = "actual_price_per_day"
        case actualPricePerNight = "actual_price_per_night"
    }
}


// MARK: - BeachHouseRoom
struct BookingsBeachHouseRoom: Codable {
    let id, name, description: String?
    let pricePerNight:  Float?
    let discountPercent: Float?
    let pricePerDay:  Float?
    let dayDiscountPercent: Float?
    let images: [Image]?
    let bedTypes: [BookingBedType]?
    let noOfOccupant, hasPrivateBathroom: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
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
    let bookingId: String
    let boat: FavouriteBoat
    let total: Float
    let summary: String?
    let status: String
    let cruiseLength: Int
    let bookingType: String
    let noOfPeople: Int
    let bookingDate, bookingTime, hostID: String
    let boatDestination: Destinations?
    let subCategory: SubCategory

    enum CodingKeys: String, CodingKey {
        case boat, total, summary, status
        case bookingId = "booking_id"
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
