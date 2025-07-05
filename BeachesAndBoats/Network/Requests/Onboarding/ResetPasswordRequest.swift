//
//  ResetPasswordRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation

struct ResetPasswordRequest: Codable{
    var email: String
    var otp_code: String
    var new_password: String
    var new_password_confirmation: String
}
