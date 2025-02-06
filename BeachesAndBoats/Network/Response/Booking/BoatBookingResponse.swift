//
//  BoatBookingResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/02/2025.
//

import Foundation

struct BoatBookingResponse: Codable{
    let data: BoatBookingResponseData?
}

struct BoatBookingResponseData: Codable {
    let paymentData: PaymentData?
    let bookingDetail: BoatBookingDetail?
}

// MARK: - BookingDetail
struct BoatBookingDetail: Codable {
    let boatID: String?
    let total: Float?
    let summary: String?
    let cruiseLength: Int?
    let bookingType: String?
    let noOfPeople: Int?
    let bookingDate, bookingTime, hostID, userID: String?
    let subCategoryID, boatDestinationID: String?
    let adminCharge: Float
    let id, updatedAt, createdAt: String?
    let user: BookingUser?

    enum CodingKeys: String, CodingKey {
        case boatID = "boat_id"
        case total, summary
        case cruiseLength = "cruise_length"
        case bookingType = "booking_type"
        case noOfPeople = "no_of_people"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case hostID = "host_id"
        case userID = "user_id"
        case subCategoryID = "sub_category_id"
        case boatDestinationID = "boat_destination_id"
        case adminCharge = "admin_charge"
        case id
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case user
    }
}

// MARK: - User
struct BookingUser: Codable {
    let id, firstName, lastName, email: String
    let phoneCode, phoneNumber, dob, lastLogin: String
    let fcmToken: String?
    let deviceID, emailVerifiedAt, createdAt, updatedAt: String
    let deletedAt, provider, providerID, avatar: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case dob
        case lastLogin = "last_login"
        case fcmToken = "fcm_token"
        case deviceID = "device_id"
        case emailVerifiedAt = "email_verified_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case deletedAt = "deleted_at"
        case provider
        case providerID = "provider_id"
        case avatar
    }
}

