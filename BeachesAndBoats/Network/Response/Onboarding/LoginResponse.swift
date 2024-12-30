//
//  LoginResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import Foundation

struct LoginResponse: Codable{
    var message: String?
    var status: Bool?
    var data: LoginUser?
    var errors: [String]?
}

struct LoginUser: Codable{
    var user: UserData?
    var switch_device: Bool?
    var access_token: String?
    var refreshToken: String?
}

