//
//  SignUpResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

struct SignUpResponse: Codable{
    var message: String?
    var status: Bool?
    var user: UserData?
    var access_token: String?
    var token_type: String?
    var expires_at: String?
}
