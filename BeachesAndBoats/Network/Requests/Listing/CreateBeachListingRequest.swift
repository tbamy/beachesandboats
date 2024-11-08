//
//  CreateBeachListing.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

struct CreateBeachListingRequest: Codable {
    let category_id: String
    let sub_cat_id: String
    let guest_booking_id: String
    let name: String
    let description: String
    let country: String
    let state: String
    let city: String
    let street_address: String
    let from_when: String
    let to_when: String
    let amenities: [String]
    let preferred_languages: [String]
    let brief_introduction: String
    let house_rules: [String]
    let check_in_start: String
    let check_in_end: String
    let check_out_start: String
    let check_out_end: String
    let roominfo: [RoomData]
    let full_apartment_cost: Double
    let full_apartment_discount: Double
    let full_apartment_amount_to_earn: Double
}

struct RoomData: Codable{
    let id: Int
    let name: String
    let description: String
    let amenities: [String]
    let price_per_night: Double
    let discount: Double
    let amount_to_earn: Double
    let room_images: [Data]
    let number_of_guests: String
    let number_of_rooms: String
    let number_of_beds: String
}
