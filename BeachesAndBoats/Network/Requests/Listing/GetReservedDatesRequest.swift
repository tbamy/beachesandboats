//
//  GetReservedDatesRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2025.
//

import Foundation

struct GetReservedDatesRequest: Codable {
    let dateable_id: String
    let dateable_type: String
}
