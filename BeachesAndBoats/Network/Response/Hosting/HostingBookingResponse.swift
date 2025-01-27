//
//  HostingBookingResponse.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 30/12/2024.
//

import Foundation

struct HostingBookingResponse: Codable {
    let status: Bool?
    let message: String?
    let data: DataClass?
    let errors: String?
}

struct DataClass: Codable {
    let beachHouseReservations: BeachHouseReservations?
    let boatReservations: BoatReservations?
    let serviceReservations: ServiceReservations?
}

struct BeachHouseReservations: Codable {
    let upcomingReservations, currentReservations: [BeachHouseReservationsCurrentReservation]?
    let cancelledReservations: [BeachHouseReservationsCurrentReservation]?//[String]?

    enum CodingKeys: String, CodingKey {
        case upcomingReservations = "upcoming_reservations"
        case currentReservations = "current_reservations"
        case cancelledReservations = "cancelled_reservations"
    }
}

struct BeachHouseReservationsCurrentReservation: Codable {
    let id: String?
    let user: User?
    let beachHouseRoom: BeachHouseRoom?
    let beachHouse: BeachHouseDetails?
    let checkingDate, checkoutDate, checkingTime, checkoutTime: String?
    let noOfPeople: Int?
    let status: String?
    let summary: String?
    let units, total: Int?

    enum CodingKeys: String, CodingKey {
        case id, user
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

//struct BeachHouseRoom: Codable {
//    let id, name, description: String?
//    let pricePerNight, discountPercent: String?
//    let images: [Image]?
//    let bedTypes: [BedTypeDetails]?
//    let noOfOccupant: Int?
//    let hasPrivateBathroom: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case pricePerNight = "price_per_night"
//        case discountPercent = "discount_percent"
//        case images, bedTypes
//        case noOfOccupant = "no_of_occupant"
//        case hasPrivateBathroom = "has_private_bathroom"
//    }
//}

struct BedTypeDetails: Codable {
    let id, name, description: String?
    let quantity: Int?
}

struct BeachHouseDetails: Codable {
    let id, name, description, aboutOwner: String?
    let listingPrice, discountPercent: Int?
    let image: String?
    let locations: Locations?
    let availabilities: Availabilities?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case image, locations, availabilities, rating
    }
}

struct Locations: Codable {
    let country, state, streetName, city: String?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case country, state
        case streetName = "street_name"
        case city, latitude, longitude
    }
}

struct Availabilities: Codable {
    let availableFrom, availableTo: String?

    enum CodingKeys: String, CodingKey {
        case availableFrom = "available_from"
        case availableTo = "available_to"
    }
}

struct Image: Codable {
    let url: String?
}

struct BoatReservations: Codable {
    let upcomingReservations, currentReservations: [BoatReservationsCurrentReservation]?
    let cancelledReservations: [String]?

    enum CodingKeys: String, CodingKey {
        case upcomingReservations = "upcoming_reservations"
        case currentReservations = "current_reservations"
        case cancelledReservations = "cancelled_reservations"
    }
}

struct BoatReservationsCurrentReservation: Codable {
    let boat: Boat?
    let total: Int?
    let summary: String?
    let status: String?
    let cruiseLength: Int?
    let bookingType: String?
    let noOfPeople: Int?
    let bookingDate, bookingTime: String?
    let user: User?
    let boatDestination: String?
    let subCategory: SubCategory?

    enum CodingKeys: String, CodingKey {
        case boat, total, summary, status
        case cruiseLength = "cruise_length"
        case bookingType = "booking_type"
        case noOfPeople = "no_of_people"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case user
        case boatDestination = "boat_destination"
        case subCategory = "sub_category"
    }
}

struct Boat: Codable {
    let id, name, description: String?
    let locations: Locations?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [DestinationDetails]?
    let rating: Int?
}

struct DestinationDetails: Codable {
    let id, name, price: String?
}

struct ServiceReservations: Codable {
    let upcomingBookings: [String]?
    let pastBookings: [PastBookingDetails]?

    enum CodingKeys: String, CodingKey {
        case upcomingBookings = "upcoming_bookings"
        case pastBookings = "past_bookings"
    }
}

struct PastBookingDetails: Codable {
    let hostInfo: HostInfo?
    let serviceProvider: ServiceProvider?
    let bookingDate: String?
    let amount: Decimal?
    let total: Decimal?
    let status: String?
    let agreementDescription: String?
    let boatBooking: String?
    let beachHouseBooking: BeachHouseBookingDetails?
    let bookingableType: String?
}

struct BeachHouseBookingDetails: Codable {
    let id: String?
    let user: User?
    let beachHouseRoom: BeachHouseRoom?
    let beachHouse: BeachHouseDetails?
    let checkingDate: String?
    let checkoutDate: String?
    let checkingTime: String?
    let checkoutTime: String?
    let noOfPeople: Int?
    let status: String?
    let summary: String?
    let units: Int?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case id, user
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
