//
//  TwoFAEmailSecurityRequest.swift
//  BeachesAndBoats
//
//  Created by WEMA on 06/01/2025.
//

import Foundation
struct TwoFAEmailSecurityRequest: Codable {
    let email: String
}

struct TwoFAPhoneSecurityRequest: Codable {
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case phoneNumber = "phone_number"
    }
}
