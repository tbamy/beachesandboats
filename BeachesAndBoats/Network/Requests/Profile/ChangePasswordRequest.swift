//
//  ChangePasswordRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation

struct ChangePasswordRequest: Codable{
    var current_password: String?
    var new_password: String
}
