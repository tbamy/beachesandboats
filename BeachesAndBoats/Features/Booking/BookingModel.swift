//
//  BookingModel.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 17/05/2024.
//

import Foundation

struct UpcomingBookingModel {
    func populateData() -> [BookingProperties] {
        [
            BookingProperties(image: "beach", name: "Marina  Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Apata, Ibadan Nigeria", date: "Jun 18-23")
        ]
    }
}

struct PastBookingModel {
    func populateData() -> [BookingProperties] {
        [
            BookingProperties(image: "beach", name: "Eko Hotel", address: "VI", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),
            BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23"),BookingProperties(image: "beach", name: "Marina Luxury Villa", address: "Ikoyi, Lagos Nigeria", date: "Jun 18-23")
        ]
    }
}


struct BookingProperties {
    var image: String?
    var name: String?
    var address: String?
    var date: String?
}


