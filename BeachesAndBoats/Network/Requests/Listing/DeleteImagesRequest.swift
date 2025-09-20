//
//  DeleteImagesRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/09/2025.
//

struct DeleteImagesRequest: Codable{
    let property_type: String
    let property_id: String
    let images: [String]
}
