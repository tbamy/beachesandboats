//
//  CancelBookingRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

struct CancelBookingRequest: Codable{
    let booking_id: String
    let booking_type: String
    let reason: String
}
