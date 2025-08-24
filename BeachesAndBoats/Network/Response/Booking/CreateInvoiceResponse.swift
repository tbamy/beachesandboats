//
//  CreateInvoiceResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

struct CreateInvoiceResponse: Codable{
    let message: String
    let data: CreateInvoiceResponseData?
}

struct CreateInvoiceResponseData: Codable {
    let paymentData: PaymentData
    let bookingDetail: ServiceBookingDetail
}

// MARK: - BookingDetail
struct ServiceBookingDetail: Codable {
    let id, hostID: String
    let serviceProvider: ServiceProviderInfo
    let bookingDate: String
    let amount, total: Float
    let status: String?
    let agreementDescription, bookingableID, bookingableType: String?
    let paymentReference: String?

    enum CodingKeys: String, CodingKey {
        case id
        case hostID = "host_id"
        case serviceProvider = "service_provider"
        case bookingDate = "booking_date"
        case amount, total, status
        case agreementDescription = "agreement_description"
        case bookingableID = "bookingable_id"
        case bookingableType = "bookingable_type"
        case paymentReference = "payment_reference"
    }
}

// MARK: - ServiceProvider

struct ServiceProviderInfo: Codable {
    let id, firstName, lastName, email: String
    let phoneCode, phoneNumber, dob: String
    let roles: [String]
    let isAccountVerified: Bool
    let verificationStatus: String?
    let notificationSettings: [NotificationSetting]
    let mfaEnabled: Bool
    let mfaEmail, mfaPhoneNumber: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case dob, roles, isAccountVerified, verificationStatus, notificationSettings
        case mfaEnabled = "mfa_enabled"
        case mfaEmail = "mfa_email"
        case mfaPhoneNumber = "mfa_phone_number"
    }
}

// MARK: - PaymentData
//struct ServicePaymentData: Codable {
//    let authorizationURL: String
//    let accessCode, reference: String
//
//    enum CodingKeys: String, CodingKey {
//        case authorizationURL = "authorization_url"
//        case accessCode = "access_code"
//        case reference
//    }
//}
