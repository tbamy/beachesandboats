//
//  TwoFASecurityResponse.swift
//  BeachesAndBoats
//
//  Created by WEMA on 06/01/2025.
//

import Foundation
struct TwoFASecurityResponse: Codable {
    let status: Bool?
    let message: String?
    let data: String?
    let errors: String?
}
