//
//  BeachDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

struct BeachDataResponse: Codable {
    let success: Bool
    let message: String
    let data: BeachDatas
}

struct BeachDatas: Codable {
    let categories: [BeachCategory]
    let subCategories: [BeachSubCategory]
    let guestAllowed: [GuestAllowed]
    let rules: [HouseRule]?
    let languages: [Language]
    let bedTypes: [BedTypesData]
    let amenities: [AmenityCategory]
    
    enum CodingKeys: String, CodingKey {
        case categories
        case subCategories = "sub_categories"
        case guestAllowed = "guest_allowed"
        case bedTypes = "bed_types"
        case rules
        case languages
        case amenities
    }
}

struct BedTypesData: Codable{
    let id: Int
    let name: String
    let slug: String
    let size: String?
    let bedID: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, size
        case bedID = "bed_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct BeachCategory: Codable {
    let id: Int
    let name: String
    let slug: String
    let description: String
    let image: String?
    let accountID: String
    let categoryID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, image
        case accountID = "account_id"
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct BeachSubCategory: Codable {
    let id: Int
    let name: String
    let slug: String
    let description: String
    let image: String?
    let accountID: String
    let categoryID: String
    let subCatID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, image
        case accountID = "account_id"
        case categoryID = "category_id"
        case subCatID = "sub_cat_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct GuestAllowed: Codable {
    let id: Int
    let name: String
    let slug: String
    let description: String
    let accountID: String
    let bookingID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description
        case accountID = "account_id"
        case bookingID = "booking_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct HouseRule: Codable {
    let id: Int
    let description: String
    let accountID: String
    let ruleID: String
    let categoryID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, description
        case accountID = "account_id"
        case ruleID = "rule_id"
        case categoryID = "category_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}



struct Language: Codable {
    let id: Int
    let name: String
    let slug: String
    let accountID: String
    let languageID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case accountID = "account_id"
        case languageID = "language_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct AmenityCategory: Codable {
    let id: Int
    let name: String
    let slug: String
    let accountID: String
    let categoryID: String
    let tagID: String
    let createdAt: String
    let updatedAt: String
    let amenities: [Amenity]
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug
        case accountID = "account_id"
        case categoryID = "category_id"
        case tagID = "tag_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case amenities
    }
}

struct Amenity: Codable {
    let id: Int
    let name: String
    let slug: String
    let description: String?
    let accountID: String
    let image: String?
    let amenityID: String
    let tagID: String
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, slug, description, image
        case accountID = "account_id"
        case amenityID = "amenity_id"
        case tagID = "tag_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
