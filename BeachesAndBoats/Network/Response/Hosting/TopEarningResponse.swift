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
   
    let userEarnings: [String: [String: Decimal]]? // Year -> Month -> Earnings
    let topEarners: [String: TopEarner]?
    
    enum CodingKeys: String, CodingKey {
        case userEarnings = "user_earnings"
        case topEarners = "top_earners"
    }

    init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            // Handle userEarnings: try dictionary first, then array
            if let userEarningsDict = try? container.decodeIfPresent([String: [String: Decimal]].self, forKey: .userEarnings) {
                userEarnings = userEarningsDict
            } else if (try? container.decodeIfPresent([String].self, forKey: .userEarnings)) != nil {
                userEarnings = [:] // Map empty array to empty dictionary
            } else {
                userEarnings = nil
            }

            // Handle topEarners: try dictionary first, then array
            if let topEarnersDict = try? container.decodeIfPresent([String: TopEarner].self, forKey: .topEarners) {
                topEarners = topEarnersDict
            } else if (try? container.decodeIfPresent([String].self, forKey: .topEarners)) != nil {
                topEarners = [:] // Map empty array to empty dictionary
            } else {
                topEarners = nil
            }
        }
}

struct TopEarner: Codable {
    let totalEarnings: Decimal?
    let propertyType: String?
    let beachHouse: BeachHouseData?
    let boat: BoatEarningData?
    
    enum CodingKeys: String, CodingKey {
        case totalEarnings = "total_earnings"
        case propertyType = "property_type"
        case beachHouse, boat
    }
}

struct BoatEarningData: Codable {
    let id, name, description, aboutOwner: String?
    let noOfPassengers: Int?
    let category, subCategory: Category?
    let locations: Location?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [Destination]?
    let userReviewed: Bool?
    let rating: Int?
    let userFavourite: Bool?
//    let additionalHouseRules: JSONNull?
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let houseRules: [Category]?
//    let reviews: [Review]

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case noOfPassengers = "no_of_passengers"
        case category
        case subCategory = "sub_category"
        case locations, availabilities, images, destinations, userReviewed, rating, userFavourite
//        case additionalHouseRules = "additional_house_rules"
        case owner, amenities, languages, houseRules
    }
}

struct BeachHouseData: Codable {
    let id: String?
    let name: String?
    let description: String?
//    let aboutOwner: String?
//    let listingPrice: Decimal?
//    let discountPercent: Decimal
//    var overnightCheckIn: String?
//    var overnightCheckOut: String?
//    var dayCheckIn: String?
//    var dayCheckOut: String?
//    let pricePerNight: Decimal
//    let bookingType: String
//    let category: Category
//    let subCategory: SubCategory
//    let owner: OwnerDetails
//    let amenities: [Amenity]
//    let languages: [Language]
    let locations: Location?
//    let availabilities: Availability
//    let houseRules: [HouseRuleDetails]
    let rooms: [RoomDetails]
    let images: [Image]
//    let userReviewed: Bool
//    let rating: Int
//    let userFavourite: Bool
//    let reviews: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
//        case aboutOwner = "about_owner"
//        case listingPrice = "listing_price"
//        case discountPercent = "discount_percent"
//        case overnightCheckIn = "overnight_check_in"
//        case overnightCheckOut = "overnight_check_out"
//        case dayCheckIn = "day_check_in"
//        case dayCheckOut = "day_check_out"
//        case pricePerNight = "price_per_night"
//        case bookingType = "booking_type"
        case locations, rooms, images
//        case userReviewed = "userReviewed"
//        case rating
//        case userFavourite = "userFavourite"
//        case reviews
    }
}

//struct OwnerDetails: Codable {
//    let id: String
//    let firstName: String
//    let lastName: String
//    let email: String
//    let phoneCode: String
//    let phoneNumber: String
//    
//    enum CodingKeys: String, CodingKey {
//        case id, firstName = "first_name", lastName = "last_name", email, phoneCode = "phone_code", phoneNumber = "phone_number"
//    }
//}

//struct HouseRuleDetails: Codable {
//    let name: String
//    let description: String?
//}
//
struct RoomDetails: Codable {
    let id: String
    let name: String
    let description: String
//    let pricePerNight: String
//    let discountPercent: String
    let images: [Image]?
//    let bedTypes: [BedTypeData]?
//    let noOfOccupant: Int?
//    let hasPrivateBathroom: Int?
//    
    enum CodingKeys: String, CodingKey {
        case id, name, description, images
    }
}
//
//struct BedTypeData: Codable {
//    let id: String?
//    let name: String?
//    let description: String?
////    let quantity: Int?
//}

