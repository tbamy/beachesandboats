//
//  AddReviewRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation

struct AddReviewRequest: Codable {
    var itemId: String
    var type: String
    var note: String
    var rating: Int
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case type, note, rating
    }
}
