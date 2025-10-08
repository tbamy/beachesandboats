//
//  TwoFACompleteVerificationRequest.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 06/01/2025.
//

import Foundation

struct TwoFACompleteVerificationRequest: Codable {
    let email: String?
    let phoneNumber: String?
    let otpCode: String
    
    init(email: String? = nil, phoneNumber: String? = nil, otpCode: String) {
        self.email = email
        self.phoneNumber = phoneNumber
        self.otpCode = otpCode
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case phoneNumber = "phone_number"
        case otpCode = "otp_code"
    }
}


