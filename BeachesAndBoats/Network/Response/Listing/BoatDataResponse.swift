//
//  BoatDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation


struct BoatDataResponse: Codable{
    let status: Bool?
    let message: String?
    let data: BoatDatas?
}

struct BoatDatas: Codable{
    let categories: [BoatCategory]?
    let amenities: [RoomAmenities]?
    let house_rules: [HouseRule]?
    let languages: [Languages]?
    let destinations: [Destinations]?
}
struct BoatCategory: Codable{
    let id: String?
    let name: String?
    let propertyType: String?
    let description: String?
    let image: String?
    let subCategories: [BoatTypes]?
}

struct BoatTypes: Codable{
    let id : String?
    let name : String?
    let description : String?
    let image : String?
    let icon : String?
}

struct Destinations: Codable{
    let id : String?
    let name : String?
}
