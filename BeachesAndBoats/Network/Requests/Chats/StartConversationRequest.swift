//
//  StartConversationRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

struct StartConversationRequest: Codable{
    var personId: String
    var bookingId: String?
    var propertyType: String?
    
    enum CodingKeys: String, CodingKey{
        case personId = "person_id"
        case bookingId = "booking_id"
        case propertyType = "property_type"
    }
    
}
