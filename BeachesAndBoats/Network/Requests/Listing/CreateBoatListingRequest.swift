//
//  CreateBoatListingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation

struct CreateBoatListingRequest: Codable{
    let type: [String]
    let name: String
    let description: String
    let from_when: String
    let to_when: String
    let amenities: [String]
    let preferred_languages: [String]
    let brief_introduction: String
    let rules: [String]
    let no_of_adults: Int
    let no_of_children: Int
    let no_of_pets: Int
    let country: String
    let state: String
    let city: String
    let street_address: String
    let destinations_prices: [DestinationPrices]
    let images: [Data]
}

struct DestinationPrices: Codable{
    let id: String
    let price: Int
}
