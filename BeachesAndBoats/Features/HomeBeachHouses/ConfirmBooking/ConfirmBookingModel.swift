//
//  ConfirmBookingModel.swift
//  BeachesAndBoats
//
//  Created by WEMA on 07/06/2024.
//

import Foundation

struct ConfirmBookingModel {
    func populateData() -> [ConfirmBookingProperties] {
        [
            ConfirmBookingProperties(imageName: "bed", name: "Deluxe Bedroom", numberOfGuests: "2 Guests", numberOfBeds: "1 Queens bed", date: "Mar 19-25 (5 nights", price: "₦ 1,200,000"),
            ConfirmBookingProperties(imageName: "bed", name: "Deluxe Bedroom", numberOfGuests: "2 Guests", numberOfBeds: "1 Queens bed", date: "Mar 19-25 (5 nights", price: "₦ 1,200,000"),
            ConfirmBookingProperties(imageName: "bed", name: "Deluxe Bedroom", numberOfGuests: "2 Guests", numberOfBeds: "1 Queens bed", date: "Mar 19-25 (5 nights", price: "₦ 1,200,000"),
            ConfirmBookingProperties(imageName: "bed", name: "Deluxe Bedroom", numberOfGuests: "2 Guests", numberOfBeds: "1 Queens bed", date: "Mar 19-25 (5 nights", price: "₦ 1,200,000"),
            ConfirmBookingProperties(imageName: "bed", name: "Deluxe Bedroom", numberOfGuests: "2 Guests", numberOfBeds: "1 Queens bed", date: "Mar 19-25 (5 nights", price: "₦ 1,200,000")
        ]
    }
}

struct ConfirmBookingProperties {
    let imageName: String?
    let name: String?
    let numberOfGuests: String?
    let numberOfBeds: String?
    let date: String?
    let price: String?
}
