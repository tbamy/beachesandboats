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
    var overnightCheckIn: String?
    var overnightCheckOut: String?
    var dayCheckIn: String?
    var dayCheckOut: String?
    let pricePerNight: Float?
    let bookingType: String?
    let category, subCategory: Category?
    let locations: Location?
    let availabilities: Availabilities?
    let minRoomPricePerDay, minRoomPricePerNight: String?
    let userReviewed: Bool?
    let rating: Int?
    let userFavourite: Bool?
    let images: [Image]?
    let isPrivateStay: Bool?
    let additionalHouseRules: String?
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let houseRules: [HouseRule]?
    let rooms: [BeachRoom]?
    let reviews: [Review]?
    let noOfRooms : Int?
    let noOfGuests : Int?
    let noOfBeds : Int?
    let noOfBathrooms : Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case overnightCheckIn = "overnight_check_in"
        case overnightCheckOut = "overnight_check_out"
        case dayCheckIn = "day_check_in"
        case dayCheckOut = "day_check_out"
        case pricePerNight = "price_per_night"
        case bookingType = "booking_type"
        case category
        case subCategory = "sub_category"
        case locations, availabilities, minRoomPricePerDay, minRoomPricePerNight, userReviewed, rating, userFavourite, owner, amenities, languages, houseRules, rooms, reviews, images
        case isPrivateStay = "is_private_stay"
        case additionalHouseRules = "additional_house_rules"
        case noOfRooms = "no_of_rooms"
        case noOfGuests = "no_of_guests"
        case noOfBeds = "no_of_beds"
        case noOfBathrooms = "no_of_bathrooms"
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


