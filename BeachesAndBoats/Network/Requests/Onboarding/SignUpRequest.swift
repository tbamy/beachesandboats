//
//  SignUpRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

public struct SignUpRequest: Codable{
    var first_name: String?
    var last_name: String?
    var email: String?
    var birthday: String?
    var password: String?
    var password_confirmation: String?
    var keep_signed_in: Bool?
    var phone_number: String?
    var device_id: String?
}
