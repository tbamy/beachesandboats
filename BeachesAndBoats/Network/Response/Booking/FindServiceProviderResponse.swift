//
//  FindServiceProviderResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/02/2025.
//

import Foundation

struct FindServiceProviderResponse: Codable{
    let data: [FindProviderResponseData]?
}

struct FindProviderResponseData: Codable{
    let id, name, description: String?
    let startingPrice: Float?
    let gender: String?
    let availabilities: Availabilities?
    let dishes: [Dishes]?
    let images: [Image]?
    let chefInfo: ChefInfo?
    let category: Category?
    let rating: Int?
    let reviews: [Review]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case startingPrice = "starting_price"
        case gender, availabilities, dishes, images
        case chefInfo = "chef_info"
        case category, rating, reviews
    }
}

struct ChefInfo: Codable {
    let id, firstName, lastName, email: String
    let phoneCode, phoneNumber, dob: String
    let roles: [String]
    let isAccountVerified: Bool
//    let verificationStatus: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case dob, roles, isAccountVerified
//        , verificationStatus
    }
}

