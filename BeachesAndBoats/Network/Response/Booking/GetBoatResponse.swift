//
//  GetBoatResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/07/2025.
//

struct GetBoatResponse: Codable {
    let data: GetBoatData?
}

struct GetBoatData: Codable {
    let id, name, description, aboutOwner: String
    let noOfAdults, noOfChildren, noOfPets: String?
    let category, subCategory: Category?
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let locations: Locations?
    let availabilities: Availabilities?
    let images: [Image]?
    let destinations: [Destination]?
    let houseRules: [HouseRule]?
    let userReviewed: Bool?
    let rating: Int?
    let userFavourite: Bool?
    let reviews: [Review]?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case noOfAdults = "no_of_adults"
        case noOfChildren = "no_of_children"
        case noOfPets = "no_of_pets"
        case category
        case subCategory = "sub_category"
        case owner, amenities, languages, locations, availabilities, images, destinations, houseRules, userReviewed, rating, userFavourite, reviews
    }
}

// MARK: - Amenity
//struct Amenity: Codable {
//    let id, name: String
//    let icon: String?
//    let amenityType, propertyType: String
//}

// MARK: - Category
//struct Category: Codable {
//    let id, name, description: String
//    let image: String?
//    let icon: String?
//}

// MARK: - Destination
//struct Destination: Codable {
//    let id, name, price: String
//}

// MARK: - HouseRule
//struct HouseRule: Codable {
//    let name: String
//    let description: JSONNull?
//}

// MARK: - Image
//struct Image: Codable {
//    let url: String
//}

// MARK: - Language
//struct Language: Codable {
//    let name: String
//}

// MARK: - Locations
//struct Locations: Codable {
//    let country, state, streetName, city: String
//    let latitude, longitude: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case country, state
//        case streetName = "street_name"
//        case city, latitude, longitude
//    }
//}

// MARK: - Owner
//struct Owner: Codable {
//    let id, firstName, lastName, email: String
//    let phoneCode, phoneNumber: String
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
