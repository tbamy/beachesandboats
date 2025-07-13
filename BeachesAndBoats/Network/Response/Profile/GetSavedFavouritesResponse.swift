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
    let locations: Locations?
    let availabilities: Availabilities
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case image, locations, availabilities, rating
    }
}

struct FavouriteBoat: Codable {
    let id, name, description: String?
    let locations: Locations?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [Destination]?
    let rating: Int?
}

