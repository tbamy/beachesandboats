//
//  VerifyLoginOtpRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/12/2024.
//

import Foundation

struct VerifyLoginOtpRequest: Codable{
    var email: String?
    var otp_code: String?
    var device_id: String?
}
