//
//  BeachHouseBookingResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 14/01/2025.
//

import Foundation

struct BeachHouseBookingResponse: Codable{
    let status: Bool
    let message: String
    let data: BeachHouseBookingResponseData?
}

// MARK: - DataClass
struct BeachHouseBookingResponseData: Codable {
    let paymentData: PaymentData?
    let bookingDetail: BookingDetail?
}

// MARK: - BookingDetail
struct BookingDetail: Codable {
    let userID, hostID, beachHouseRoomID, beachHouseID: String
    let checkingDate, checkoutDate, checkingTime, checkoutTime: String
    let noOfPeople: Int
    let units: Int
    let adminCharge, total: Float
    let id, updatedAt, createdAt: String
    let user: User?

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case hostID = "host_id"
        case beachHouseRoomID = "beach_house_room_id"
        case beachHouseID = "beach_house_id"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case noOfPeople = "no_of_people"
        case units
        case adminCharge = "admin_charge"
        case total, id
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case user
    }
}

// MARK: - User
//struct User: Codable {
//    let id, firstName, lastName, email: String
//    let phoneCode, phoneNumber, dob, lastLogin: String
//    let fcmToken: JSONNull?
//    let deviceID, emailVerifiedAt, createdAt, updatedAt: String
//    let deletedAt, provider, providerID, avatar: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email
//        case phoneCode = "phone_code"
//        case phoneNumber = "phone_number"
//        case dob
//        case lastLogin = "last_login"
//        case fcmToken = "fcm_token"
//        case deviceID = "device_id"
//        case emailVerifiedAt = "email_verified_at"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case provider
//        case providerID = "provider_id"
//        case avatar
//    }
//}

// MARK: - PaymentData
struct PaymentData: Codable {
    let authorizationURL: String
    let accessCode, reference: String

    enum CodingKeys: String, CodingKey {
        case authorizationURL = "authorization_url"
        case accessCode = "access_code"
        case reference
    }
}

