//
//  LoginRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import Foundation

struct LoginRequest: Codable{
    var email: String?
    var password: String?
    var device_id: String?
}
