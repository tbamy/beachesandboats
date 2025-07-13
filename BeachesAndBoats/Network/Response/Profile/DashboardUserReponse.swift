//
//  DashboardUserReponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//
import Foundation

struct DashboardUserReponse: Codable {
    let status: Bool
    let message: String
    let data: DashboardUserData?
    let errors: [String]?
}

struct DashboardUserData: Codable {
    let id, firstName, lastName, email: String
    let phoneCode, phoneNumber, dob: String
    let wallet: Wallet
    let roles: [String]
    let isAccountVerified: Bool
    let verificationStatus: String?
    let notificationSettings: [NotificationSetting]
    let mfaEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case dob, wallet, roles, isAccountVerified, verificationStatus, notificationSettings
        case mfaEnabled = "mfa_enabled"
    }
}

// MARK: - NotificationSetting
struct NotificationSetting: Codable {
    let id, title, description: String
    let status: Bool
}

// MARK: - Wallet
struct Wallet: Codable {
    let id: String
    let balance: Int
    let currency: String
}

//struct Reservation: Codable {
//    let id: String
//    let startDate: String
//    let endDate: String
//    let status: String
//    let amount: Double
//    let summary: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case startDate = "start_date"
//        case endDate = "end_date"
//        case status
//        case amount
//        case summary
//    }
//}
//
//struct ServiceReservation: Codable {
//    let hostInfo: HostInfo?
//    let serviceProvider: ServiceProvider?
//    let bookingDate: String?
//    let amount: Double?
//    let total: Double?
//    let status: String?
//    let agreementDescription: String?
//    let bookingData: BookingData?
//    let bookingableType: String?
//
//    enum CodingKeys: String, CodingKey {
//        case hostInfo = "host_info"
//        case serviceProvider = "service_provider"
//        case bookingDate = "booking_date"
//        case amount
//        case total
//        case status
//        case agreementDescription = "agreement_description"
//        case bookingData = "booking_data"
//        case bookingableType = "bookingable_type"
//    }
//}
//
struct HostInfo: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
    }
}
//
struct ServiceProvider: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
    }
}
//
//struct BookingData: Codable {
//    let user: User?
//    let beachHouseRoom: BeachHouseRoom?
//    let beachHouse: BeachHouse?
//    let checkingDate: String
//    let checkoutDate: String
//    let checkingTime: String
//    let checkoutTime: String
//    let noOfPeople: Int
//    let status: String
//    let summary: String?
//    let units: Int
//    let total: String
//
//    enum CodingKeys: String, CodingKey {
//        case user
//        case beachHouseRoom = "beach_house_room"
//        case beachHouse = "beach_house"
//        case checkingDate = "checking_date"
//        case checkoutDate = "checkout_date"
//        case checkingTime = "checking_time"
//        case checkoutTime = "checkout_time"
//        case noOfPeople = "no_of_people"
//        case status
//        case summary
//        case units
//        case total
//    }
//}
//
struct User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
    }
}
//
//struct BeachHouseRoom: Codable {
//    let id: String
//    let name: String
//    let description: String
//    let pricePerNight: Double //String
//    let discountPercent: Double//String
//    let images: [Image]
//    let bedTypes: [BookingBedType]?
//    let noOfOccupant: Int
//    let hasPrivateBathroom: Int //Bool
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case description
//        case pricePerNight = "price_per_night"
//        case discountPercent = "discount_percent"
//        case images
//        case bedTypes = "bed_types"
//        case noOfOccupant = "no_of_occupant"
//        case hasPrivateBathroom = "has_private_bathroom"
//    }
//}
//
struct BookingBedType: Codable {
    let id: String
    let name: String
    let description: String
    let quantity: String
}
//
//struct BeachHouse: Codable {
//    let id: String
//    let name: String
//    let description: String
//    let location: String
//    let images: [String]
//    let amenities: [String]
//    let pricePerNight: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case name
//        case description
//        case location
//        case images
//        case amenities
//        case pricePerNight = "price_per_night"
//    }
//}
//
//
