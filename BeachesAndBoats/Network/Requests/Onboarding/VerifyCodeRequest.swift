//
//  VerifyCodeRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

struct VerifyCodeRequest: Codable{
    var otp_code: String?
    var email: String?
}
