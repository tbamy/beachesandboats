//
//  CreateBeachListing.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

struct CreateBeachListingRequest: Codable {
    var name: String
    var description: String
    var aboutOwner: String
    var checkInFrom: String
    var checkInTo: String
    var checkOutFrom: String
    var checkOutTo: String
    var categoryId: String
    var subCategoryId: String
    var bookingType: String?
    var country: String
    var state: String
    var streetName: String
    var city: String
    var latitude: Double?
    var longitude: Double?
    var availableFrom: String
    var availableTo: String
    var amenities: [String]
    var languages: [String]
    var houseRules: [String]
    var rooms: [Room]
    var roleType: String
    var listingPrice: Float
    var discountPercent: Int

    
    enum CodingKeys: String, CodingKey {
        case name, description
        case aboutOwner = "about_owner"
        case checkInFrom = "check_in_from"
        case checkInTo = "check_in_to"
        case checkOutFrom = "check_out_from"
        case checkOutTo = "check_out_to"
        case categoryId = "category_id"
        case subCategoryId = "sub_category_id"
        case bookingType = "booking_type"
        case country, state, streetName, city, latitude, longitude
        case availableFrom = "available_from"
        case availableTo = "available_to"
        case amenities, languages
        case houseRules = "houserules"
        case rooms
        case roleType = "role_type"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
    }
}

struct Room: Codable {
    var name: String
    var description: String
    var quantity: Int
    var roomAmenities: [String]
    var pricePerNight: Float
    var discountPercent: Int
    var bedTypes: [BedType]
    var hasPrivateBathroom: Int
    var noOfOccupant: Int
    var images: [Data]?
    
    enum CodingKeys: String, CodingKey {
        case name, description, quantity
        case roomAmenities = "room_amenities"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case bedTypes = "bedTypes"
        case hasPrivateBathroom = "has_private_bathroom"
        case noOfOccupant = "no_of_occupant"
        case images
    }
    
    
}

struct BedType: Codable {
    var id: String
    var quantity: Int
}
