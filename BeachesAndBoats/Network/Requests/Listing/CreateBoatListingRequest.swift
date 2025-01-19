//
//  CreateBoatListingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation

struct CreateBoatListingRequest: Codable {
    var name: String
    var description: String
    var aboutOwner: String
    var noOfAdults: Int
    var noOfChildren: Int
    var noOfPets: Int
    var categoryId: String
    var subCategoryId: String
    var country: String
    var state: String
    var streetName: String
    var city: String
    var availableFrom: String
    var availableTo: String
    var amenities: [String]
    var languages: [String]
    var houseRules: [String]
    var destinations: [Destination]
    var images: [Data]

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case aboutOwner = "about_owner"
        case noOfAdults = "no_of_adults"
        case noOfChildren = "no_of_children"
        case noOfPets = "no_of_pets"
        case categoryId = "category_id"
        case subCategoryId = "sub_category_id"
        case country
        case state
        case streetName = "street_name"
        case city
        case availableFrom = "available_from"
        case availableTo = "available_to"
        case amenities
        case languages
        case houseRules = "houserules"
        case destinations
        case images
    }
}

struct Destination: Codable {
    var destinationId: String
    var pricePerHour: Double

    enum CodingKeys: String, CodingKey {
        case destinationId = "destination_id"
        case pricePerHour = "price_per_hour"
    }
}


