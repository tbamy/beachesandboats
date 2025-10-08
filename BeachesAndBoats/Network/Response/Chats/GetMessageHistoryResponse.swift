//
//  GetMessageHistoryResponse.swift
//  BeachesAndBoatsw
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation


struct GetMessageHistoryResponse: Codable{
    let data: GetMessageHistoryData?
}

// MARK: - DataClass
struct GetMessageHistoryData: Codable {
    let currentPage: Int
    let data: [MessagesData]
    let firstPageURL: String
    let from, lastPage: Int?
    let lastPageURL: String
    let links: [Link]
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to: Int?
    let total: Float

    enum CodingKeys: String, CodingKey {
        case currentPage = "current_page"
        case data
        case firstPageURL = "first_page_url"
        case from
        case lastPage = "last_page"
        case lastPageURL = "last_page_url"
        case links
        case nextPageURL = "next_page_url"
        case path
        case perPage = "per_page"
        case prevPageURL = "prev_page_url"
        case to, total
    }
}

// MARK: - Datum
struct MessagesData: Codable {
    let id, conversationID, senderID, senderName: String
    let receiverID, receiverName, message: String
    let payload: Payload?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case conversationID = "conversation_id"
        case senderID = "sender_id"
        case senderName = "sender_name"
        case receiverID = "receiver_id"
        case receiverName = "receiver_name"
        case message, payload
        case createdAt = "created_at"
    }
}

// MARK: - Payload
struct Payload: Codable {
    let paymentData: PaymentData
    let propertyType: String
    let providerBookingDetail: ProviderBookingDetail?
//    let beachHouseBookingDetail: BeachHouseBooking?
//    let boatBookingDetail: BoatBookingDetail?
}



// MARK: - ProviderBookingDetail
struct ProviderBookingDetail: Codable {
    let hostInfo, serviceProvider: HostInfo
    let bookingDate: String
    let amount, total: Float
    let status: String?
    let agreementDescription: String
    let boatBooking: BoatBooking?
    let beachHouseBooking: BeachHouseBooking?
    let bookingableType: String

    enum CodingKeys: String, CodingKey {
        case hostInfo = "host_info"
        case serviceProvider = "service_provider"
        case bookingDate = "booking_date"
        case amount, total, status
        case agreementDescription = "agreement_description"
        case boatBooking
        case beachHouseBooking
        case bookingableType = "bookingable_type"
    }
}

//struct ProviderBeachHouseBooking: Codable {
//    let id: String
//    let hostId: String
//    let hostFirstName: String
//    let hostLastName: String
//    let hostEmail: String
//    let phoneNumber: String
//    let isHostAccountVerified: Bool
//    let beachHouseRoom: BeachHouseRoom?
//    let beachHouse: BeachHouse?
//    let checkingDate: String
//    let checkoutDate: String
//    let checkingTime: String
//    let checkoutTime: String
//    let noOfPeople: Int
//    let status: String
//    let summary: String?
//    let units: String
//    let total: Double
//    let createdAt: String
//    let adminCharge: Double
//    let cleaningFee: String
//    let noOfNights: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case id, status, summary, units, total
//        case hostId = "host_id"
//        case hostFirstName = "host_first_name"
//        case hostLastName = "host_last_name"
//        case hostEmail = "host_email"
//        case phoneNumber = "phone_number"
//        case isHostAccountVerified
//        case beachHouseRoom = "beach_house_room"
//        case beachHouse = "beach_house"
//        case checkingDate = "checking_date"
//        case checkoutDate = "checkout_date"
//        case checkingTime = "checking_time"
//        case checkoutTime = "checkout_time"
//        case noOfPeople = "no_of_people"
//        case createdAt = "created_at"
//        case adminCharge = "admin_charge"
//        case cleaningFee = "cleaning_fee"
//        case noOfNights = "no_of_nights"
//    }
//}



// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}
