//
//  BeachDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

struct BeachDataResponse: Codable {
    let status: Bool?
    let message: String?
    let data: BeachDatas?
}

struct BeachDatas: Codable {
    let categories: [BeachCategory]?
    let amenities: [RoomAmenities]?
    let house_rules: [HouseRule]?
    let languages: [Languages]?
    let bed_types: [BedTypes]?
    let room_amenities: [RoomAmenities]?
//    let destinations: []?

}

struct BeachCategory: Codable {
    let id: String?
    let name: String?
    let propertyType: String?
    let description: String?
    let image: String?
    let subCategories: [BeachSubCategory]?
    let listings: [Listings]?

}

struct BedTypes: Codable{
    let id: String?
    let name: String?
    let description: String?
}

struct BeachSubCategory: Codable {
    let id: String?
    let name: String?
    let icon: String?
    let description: String?
    let image: String?
}

struct HouseRule: Codable {
    let id: String?
    let description: String?
    let name: String?
}


struct Languages: Codable {
    let id: String?
    let name: String?
}

struct RoomAmenities: Codable {
    let id: String?
    let name: String?
    let icon: String?
    let amenityType: String?
    let propertyType: String?

}


struct Listings: Codable{
    
}
