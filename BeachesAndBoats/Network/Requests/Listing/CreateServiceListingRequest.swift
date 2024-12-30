//
//  CreateServiceListingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import Foundation

struct CreateServiceListingRequest: Codable {
    var roleType: String
    var name: String
    var description: String
    var categoryId: String
    var availableFrom: String
    var availableTo: String
    var images: [Data]
    var startingPrice: Double
    var dishes: [String]?
    var gender: String?
    var profilePic: Data?

    enum CodingKeys: String, CodingKey {
        case roleType = "role_type"
        case name
        case description
        case categoryId = "category_id"
        case availableFrom = "available_from"
        case availableTo = "available_to"
        case images
        case startingPrice = "starting_price"
        case dishes
        case gender
        case profilePic = "profile_pic"
    }
}
