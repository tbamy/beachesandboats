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
    var user: UserData?
    var access_token: String?
    var token_type: String?
    var expires_at: String?
}

struct UserData: Codable{
    var id: Int?
    var account_id: String?
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone_code: String?
    var phone: String?
    var dob: String?
    var street_address: String?
    var receive_mails: String?
    var status: String?
    var is_login: String?
    var role_id: Int?
    var last_login: String?
    var city: String?
    var country: String?
    var state: String?
    var postcode: String?
    var rememberMe: String?
    var email_verified_at: String?
    var created_at: String?
    var updated_at: String?
    
}
