//
//  BoatDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation


struct BoatDataResponse: Codable{
    let success: Bool
    let message: String
    let data: BoatDatas
}

struct BoatDatas: Codable{
    let types: [BoatTypes]
    let languages: [Language]
    let destinations: [DestinationsData]
    let amenities: [AmenityCategory]
    let rules: [HouseRule]?
}

struct BoatTypes: Codable{
    let id : Int
    let name : String
    let slug : String
    let image : String?
    let account_id : String
    let type_id : String
    let category_id : String
    let created_at : String
    let updated_at : String
}

struct DestinationsData: Codable{
    let id : Int
    let name : String
    let slug : String
    let account_id : String
    let destination_id : String
    let created_at : String
    let updated_at : String
}
