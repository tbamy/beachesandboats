//
//  GeneralResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

struct GeneralResponse: Codable, Error{
    let message: String?
    let status: Bool?
}
