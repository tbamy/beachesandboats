//
//  BeachHouseListingResponse.swift
//  BeachesAndBoats
//
//  Created by WEMA on 11/01/2025.
//

//import Foundation
//
//struct BeachHouseListingResponse: Codable {
//    let status: Bool?
//    let message: String?
//    let data: [BeachHouseListingResponseData]?
//    let errors: String?
//}
//
//struct BeachHouseListingResponseData: Codable {
//    let id, name, description, aboutOwner: String?
//    let listingPrice, discountPercent: Double?
//    let checkInFrom, checkInTo, checkOutFrom, pricePerNight: String?
//    let checkOutTo, bookingType: String?
//    let category, subCategory: CategoryData?
//    let owner: OwnerData?
//    let amenities: [AmenityData]?
//    let languages: [LanguageData]?
//    let locations: Locations?
//    let availabilities: Availabilities?
//    let houseRules: [HouseRuleData]?
//    let rooms: [RoomData]?
//    let userReviewed: Bool?
//    let rating: Int?
//    let userFavourite: Bool?
//    let reviews: [ReviewData]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case aboutOwner = "about_owner"
//        case listingPrice = "listing_price"
//        case discountPercent = "discount_percent"
//        case checkInFrom = "check_in_from"
//        case checkInTo = "check_in_to"
//        case checkOutFrom = "check_out_from"
//        case pricePerNight = "price_per_night"
//        case checkOutTo = "check_out_to"
//        case bookingType = "booking_type"
//        case category
//        case subCategory = "sub_category"
//        case owner, amenities, languages, locations, availabilities, houseRules, rooms, userReviewed, rating, userFavourite, reviews
//    }
//}
//
//    // MARK: - Amenity
//    struct AmenityData: Codable {
//        let id: String?
//        let name: String? //AmenityName
//        let icon: String?
//        let amenityType: String?//AmenityType
//        let propertyType: String?//PropertyType
//    }
//
////    enum AmenityType: String, Codable {
////        case general = "General"
////    }
////
////    enum AmenityName: String, Codable {
////        case firePit = "Fire pit"
////        case lakeAccess = "Lake access"
////    }
////
////    enum PropertyType: String, Codable {
////        case beachHouse = "BeachHouse"
////    }
//
//    // MARK: - Category
//struct CategoryData: Codable {
//    let id: String?
//    let name: CategoryName?
//    let description: String?
//    let image: String?
//    let quantity: Int?
//    let icon: String?
//}
//
//enum CategoryName: String, Codable {
//    case beachHolidayHome = "Beach holiday home"
//    case beachHouses = "Beach Houses"
//    case singleBed = "Single bed"
//}
//
//    // MARK: - HouseRule
//struct HouseRuleData: Codable {
//    let name: HouseRuleName?
//    let description: String?
//}
//
//enum HouseRuleName: String, Codable {
//    case childrenAllowed = "Children allowed"
//    case partiesAllowed = "Parties allowed"
//}
//
//    // MARK: - Language
//struct LanguageData: Codable {
//    let name: LanguageName?
//}
//
//enum LanguageName: String, Codable {
//    case english = "English"
//    case spanish = "Spanish"
//}
//
//    // MARK: - Owner
//struct OwnerData: Codable {
//    let id, firstName, lastName, email: String?
//    let phoneCode, phoneNumber: String?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email
//        case phoneCode = "phone_code"
//        case phoneNumber = "phone_number"
//    }
//}
//
//    // MARK: - Review
//    struct ReviewData: Codable {
//        let id, userID, reviewableID, reviewableType: String
//        let rating: Int
//        let note, createdAt, updatedAt: String
//
//        enum CodingKeys: String, CodingKey {
//            case id
//            case userID = "user_id"
//            case reviewableID = "reviewable_id"
//            case reviewableType = "reviewable_type"
//            case rating, note
//            case createdAt = "created_at"
//            case updatedAt = "updated_at"
//        }
//    }
//
//    // MARK: - Room
//struct RoomData: Codable {
//    let id, name: String?
//    let description: Description?
//    let pricePerNight, discountPercent: String?
//    let images: [Image]?
//    let bedTypes: [CategoryData]?
//    let noOfOccupant, hasPrivateBathroom: Int?
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
//
//enum Description: String, Codable {
//    case somethingHere = "Something here"
//}
//


import Foundation

struct BeachHouseListingResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BeachHouseListingResponseData?
    let errors: String?
}

// MARK: - DataClass
struct BeachHouseListingResponseData: Codable {
    let totalListings: Int
    let beachHouseListings: [BeachHouseListing]?
    let boatListings: [BoatListing]?
}

// MARK: - BeachHouseListing
struct BeachHouseListing: Codable {
    let id, name: String?
    let description: String?
    let aboutOwner: String?  // Changed from AboutOwner to String
    let listingPrice, discountPercent: Decimal?
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

//struct BeachHouseListing: Codable {
//    let id, name: String?
//    let description: String?
//    let aboutOwner: AboutOwner?
//    let listingPrice, discountPercent: Double?
//    let image: String?
//    let locations: Locations?
//    let availabilities: Availabilities?
//    let rating: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case aboutOwner = "about_owner"
//        case listingPrice = "listing_price"
//        case discountPercent = "discount_percent"
//        case image, locations, availabilities, rating
//    }
//}
//
//enum AboutOwner: String, Codable {
//    case dsgads = "dsgads"
//}


// MARK: - BoatListing
struct BoatListing: Codable {
    let id, name, description: String?
    let locations: Locations?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [DestinationData]?
    let rating: Int?
}

// MARK: - Destination
struct DestinationData: Codable {
    let id, name, price: String?
}
