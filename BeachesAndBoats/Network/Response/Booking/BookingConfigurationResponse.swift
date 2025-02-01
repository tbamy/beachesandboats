//
//  BookingConfigurationResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 14/01/2025.
//

import Foundation

// MARK: - BookingConfigurationResponse

struct BookingConfigurationResponse: Codable{
    let status: Bool
    let message: String
    let data: BookingConfigurationData?
}


// MARK: - BookingConfigurationData

struct BookingConfigurationData: Codable {
    let boatServiceFee, houseServiceFee, serviceFee: Float
    let cancellationPolicy: String
    let boatCleaningFee, roomCleaningFee: Float

    enum CodingKeys: String, CodingKey {
        case boatServiceFee = "boat_service_fee"
        case houseServiceFee = "house_service_fee"
        case serviceFee = "service_fee"
        case cancellationPolicy = "cancellation_policy"
        case boatCleaningFee = "boat_cleaning_fee"
        case roomCleaningFee = "room_cleaning_fee"
    }
}
