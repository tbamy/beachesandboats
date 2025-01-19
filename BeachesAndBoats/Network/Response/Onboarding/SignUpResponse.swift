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
    var data: SignUpUser?
    var errors: [String]?
}

struct SignUpUser: Codable{
    var user: UserData?
    var accessToken: String?
    var refreshToken: String?
}

struct UserData: Codable{
    var id: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone_code: String?
    var phone_number: String?
    var dob: String?
    var roles: [String]?
    var isAccountVerified: Bool?
    var verificationStatus: String?
    
}
