//
//  AddReservedDateResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2025.
//

import Foundation

struct AddReservedDateResponse: Codable {
    let status: Bool?
    let message: String?
    let data: ReservedDates?
}

struct ReservedDates: Codable {
    let dates: [String]?
    let dateable_id: String?
    let dateable_type: String?
}
