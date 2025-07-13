//
//  GetBeachResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/07/2025.
//

struct GetBeachResponse: Codable{
    let data: GetBeachData?
}

struct GetBeachData: Codable {
    let id, name, description, aboutOwner: String?
    let pricePerDay, dayDiscountPercent, listingPrice, discountPercent: Float?
    let checkInFrom, checkInTo, checkOutFrom: String?
    let pricePerNight: Float?
    let checkOutTo, bookingType: String?
    let category, subCategory: Category?
    let locations: Locations?
    let availabilities: Availabilities?
    let minRoomPricePerDay, minRoomPricePerNight: String?
    let userReviewed: Bool?
    let rating: Int?
    let userFavourite: Bool?
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let houseRules: [HouseRule]?
    let rooms: [BeachRoom]?
    let reviews: [Review]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case checkInFrom = "check_in_from"
        case checkInTo = "check_in_to"
        case checkOutFrom = "check_out_from"
        case pricePerNight = "price_per_night"
        case checkOutTo = "check_out_to"
        case bookingType = "booking_type"
        case category
        case subCategory = "sub_category"
        case locations, availabilities, minRoomPricePerDay, minRoomPricePerNight, userReviewed, rating, userFavourite, owner, amenities, languages, houseRules, rooms, reviews
    }
}

// MARK: - Room
struct BeachRoom: Codable {
    let id, name, description: String?
    let pricePerDay, dayDiscountPercent, pricePerNight, discountPercent: Float?
    let images: [Image]?
    let bedTypes: [BedType]?
    let noOfOccupant, hasPrivateBathroom: String?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images, bedTypes
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
        case quantity
    }
}


