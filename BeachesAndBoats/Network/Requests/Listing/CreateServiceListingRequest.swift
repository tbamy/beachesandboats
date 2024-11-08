//
//  CreateServiceListingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import Foundation

struct CreateServiceListingRequest: Codable{
    let name : String
    let description : String
    let profile_image : Data
    let from_when : String
    let to_when : String
    let dishes : [String]
    let price : Int
    let sample_images : [Data]
    let type : String
    let gender : String
}
