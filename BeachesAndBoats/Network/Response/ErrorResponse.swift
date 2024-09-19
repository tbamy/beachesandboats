//
//  ErrorResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

struct ErrorResponse: Codable, Error{
    let message: String?
    let status: Bool?
}
