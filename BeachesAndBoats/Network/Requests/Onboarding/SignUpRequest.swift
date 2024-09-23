//
//  SignUpRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

public struct SignUpRequest: Codable{
    let first_name: String?
    let last_name: String?
    let dob: String?
    let phone_code: String?
    let phone: String?
    let email: String?
    let password: String?
    let password_confirmation: String?
}
