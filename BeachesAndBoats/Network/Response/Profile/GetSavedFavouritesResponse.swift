//
//  GetSavedFavouritesResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation

struct GetSavedFavouritesResponse: Codable{
    let data: [SavedFavouritesData]?
}

// MARK: - Datum
struct SavedFavouritesData: Codable {
    let id, itemID, favouritableType: String
    let beachHouse: FavouriteBeachHouse?
    let boat: FavouriteBoat?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case itemID = "item_id"
        case favouritableType = "favouritable_type"
        case beachHouse, boat
        case createdAt = "created_at"
    }
}

// MARK: - BeachHouse
struct FavouriteBeachHouse: Codable {
    let id, name, description, aboutOwner: String?
    let listingPrice, discountPercent: Float?
    let image: String?
    let locations: Location?
    let availabilities: Availabilities
    let rating: Double?
    let bookingType: String?
    let pricePerDay, pricePerNight, actualPricePerNight, actualPricePerDay: Float?
    let minRoomPricePerDay, minRoomPricePerNight: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case bookingType = "booking_type"
        case image, locations, availabilities, rating
        case pricePerDay = "price_per_day"
        case pricePerNight = "price_per_night"
        case actualPricePerNight = "actual_price_per_night"
        case actualPricePerDay = "actual_price_per_day"
        case minRoomPricePerDay
        case minRoomPricePerNight
    }
}

struct FavouriteBoat: Codable {
    let id, name, description: String?
    let locations: Location?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [Destination]?
    let rating: Double?
}

