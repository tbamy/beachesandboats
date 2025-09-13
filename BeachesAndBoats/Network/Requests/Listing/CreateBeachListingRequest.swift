//
//  CreateBeachListing.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

struct CreateBeachListingRequest: Codable {
    var name: String?
    var description: String?
    var aboutOwner: String?
    var overnightCheckIn: String?
    var overnightCheckOut: String?
    var dayCheckIn: String?
    var dayCheckOut: String?
    var categoryId: String?
    var subCategoryId: String?
    var bookingType: String?
    
    var locationName: String?
    var jettyLocation: String?
    var additionalHouseRules: String?
    var isPrivateStay: Int
    
    var availableFrom: String?
    var availableTo: String?
    var amenities: [String]?
    var languages: [String]?
    var houseRules: [String]?
    var rooms: [Room]?
    var roleType: String?
    var listingPrice: Float?
    var discountPercent: Int?
    var pricePerDay: Float?
    var dayDiscountPercent: Int?
    
    var noOfRooms : Int?
    var noOfGuests : Int?
    var noOfBeds : Int?
    var noOfBathrooms : Int?
    var images: [Data]?
    

    
    enum CodingKeys: String, CodingKey {
        case name, description
        case aboutOwner = "about_owner"
        case overnightCheckIn = "overnight_check_in"
        case overnightCheckOut = "overnight_check_out"
        case dayCheckIn = "day_check_in"
        case dayCheckOut = "day_check_out"
        case categoryId = "category_id"
        case subCategoryId = "sub_category_id"
        case bookingType = "booking_type"
        case locationName = "location_name"
        case jettyLocation = "jetty_location"
        case additionalHouseRules = "additional_house_rules"
        case isPrivateStay = "is_private_stay"
        case availableFrom = "available_from"
        case availableTo = "available_to"
        case amenities, languages
        case houseRules = "houserules"
        case rooms
        case roleType = "role_type"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case noOfRooms = "no_of_rooms"
        case noOfGuests = "no_of_guests"
        case noOfBeds = "no_of_beds"
        case noOfBathrooms = "no_of_bathrooms"
    }
}

struct Room: Codable {
    var id: String?
    var name: String?
    var description: String?
    var quantity: Int?
    var roomAmenities: [String]?
    var pricePerNight: Float?
    var discountPercent: Int?
    var pricePerDay: Float?
    var dayDiscountPercent: Int?
    var bedTypes: [BedType]?
    var hasPrivateBathroom: Int?
    var noOfOccupant: Int?
    var images: [Data]?
    
    enum CodingKeys: String, CodingKey {
        case name, description, quantity
        case roomAmenities = "room_amenities"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case bedTypes = "bedTypes"
        case hasPrivateBathroom = "has_private_bathroom"
        case noOfOccupant = "no_of_occupant"
        case images
    }
    
    
}

//struct BedType: Codable {
//    var id: String
//    var quantity: Int
//}
