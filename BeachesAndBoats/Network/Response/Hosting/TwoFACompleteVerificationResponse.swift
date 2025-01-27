//
//  TwoFACompleteVerificationResponse.swift
//  BeachesAndBoats
//
//  Created by WEMA on 06/01/2025.
//

import Foundation
struct TwoFACompleteVerificationResponse: Codable {
    let status: Bool?
    let message: String?
    let data: String?
    let errors: String?
}
