//
//  AddFavouriteRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation

struct AddFavouriteRequest: Codable {
    var itemId: String
    var type: String
    var note: String
    
    enum CodingKeys: String, CodingKey {
        case itemId = "item_id"
        case type, note
    }
}
