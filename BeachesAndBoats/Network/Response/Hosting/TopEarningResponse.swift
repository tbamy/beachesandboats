//
//  TopEarningResponse.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import Foundation

struct TopEarningResponse: Codable {
    let status: Bool
    let message: String
    let data: EarningsData?
    let errors: [String]?
}

struct EarningsData: Codable {
   
    let userEarnings: [String: [String: Decimal]] // Year -> Month -> Earnings
    let topEarners: [String: TopEarner]
    
    enum CodingKeys: String, CodingKey {
        case userEarnings = "user_earnings"
        case topEarners = "top_earners"
    }
    
    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            userEarnings = (try? container.decode([String: [String: Decimal]].self, forKey: .userEarnings)) ?? [:]
            topEarners = (try? container.decode([String: TopEarner].self, forKey: .userEarnings)) ?? [:]
        }
}

struct TopEarner: Codable {
    let totalEarnings: Int
    let propertyType: String
    let beachHouse: BeachHouseData?
    let boat: String?
    
    enum CodingKeys: String, CodingKey {
        case totalEarnings = "total_earnings"
        case propertyType = "property_type"
        case beachHouse, boat
    }
}

struct BeachHouseData: Codable {
    let id: String?
    let name: String?
    let description: String?
    let aboutOwner: String?
    let listingPrice: Decimal?
    let discountPercent: Int
    let checkInFrom: String
    let checkInTo: String
    let checkOutFrom: String
    let checkOutTo: String
    let pricePerNight: Decimal
    let bookingType: String
    let category: Category
    let subCategory: SubCategory
    let owner: OwnerDetails
    let amenities: [Amenity]
    let languages: [Language]
    let locations: Location
    let availabilities: Availability
    let houseRules: [HouseRuleDetails]
    let rooms: [RoomDetails]
    let userReviewed: Bool
    let rating: Int
    let userFavourite: Bool
    let reviews: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case checkInFrom = "check_in_from"
        case checkInTo = "check_in_to"
        case checkOutFrom = "check_out_from"
        case checkOutTo = "check_out_to"
        case pricePerNight = "price_per_night"
        case bookingType = "booking_type"
        case category, subCategory = "sub_category", owner, amenities, languages, locations, availabilities, houseRules, rooms
        case userReviewed = "userReviewed"
        case rating
        case userFavourite = "userFavourite"
        case reviews
    }
}

struct OwnerDetails: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case id, firstName = "first_name", lastName = "last_name", email, phoneCode = "phone_code", phoneNumber = "phone_number"
    }
}

struct HouseRuleDetails: Codable {
    let name: String
    let description: String?
}

struct RoomDetails: Codable {
    let id: String
    let name: String
    let description: String
    let pricePerNight: String
    let discountPercent: String
    let images: [String]
    let bedTypes: [BedTypeData]
    let noOfOccupant: Int
    let hasPrivateBathroom: Int
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, pricePerNight = "price_per_night", discountPercent = "discount_percent", images, bedTypes = "bedTypes", noOfOccupant = "no_of_occupant", hasPrivateBathroom = "has_private_bathroom"
    }
}

struct BedTypeData: Codable {
    let id: String
    let name: String
    let description: String
    let quantity: Int
}

