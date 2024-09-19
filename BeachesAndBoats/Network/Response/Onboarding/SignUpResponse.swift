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
}
