//
//  ConfirmAccountRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

struct ConfirmAccountRequest: Codable{
    let phone_code: String?
    let phone_number: String?
    let email: String?
}
