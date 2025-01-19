//
//  SendKYCRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

struct SendKYCRequest: Codable{
    var first_name: String
    var last_name: String
    var middle_name: String
    var email: String
    var phone_number: String
    var id_document: Data
    var second_document: Data
}
