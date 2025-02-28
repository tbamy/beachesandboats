//
//  CustomerSupportInfoResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation


// MARK: - CustomerSupportInfoResponse
struct CustomerSupportInfoResponse: Codable {
    let data: CustomerSupportInfoData?
}

// MARK: - CustomerSupportInfoData
struct CustomerSupportInfoData: Codable {
    let id, email, name, phoneNumber: String?
    let phoneCode: String?

    enum CodingKeys: String, CodingKey {
        case id, email, name
        case phoneNumber = "phone_number"
        case phoneCode = "phone_code"
    }
}
