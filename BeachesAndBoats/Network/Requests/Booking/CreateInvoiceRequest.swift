//
//  CreateInvoiceRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

struct CreateInvoiceRequest: Codable{
    let property_type: String
    let booking_id: String
    let amount: Float
    let agreement_description: String
    let conversation_id: String
}
