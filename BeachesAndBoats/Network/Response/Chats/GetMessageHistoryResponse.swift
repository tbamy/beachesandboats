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
    let from, lastPage: Int
    let lastPageURL: String
    let links: [Link]
    let nextPageURL: String?
    let path: String
    let perPage: Int
    let prevPageURL: String?
    let to, total: Int

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
    let providerBookingDetail: ProviderBookingDetail
    let beachHouseBookingDetail: BeachHouseBooking?
//    let boatBookingDetail: JSONNull?
}



// MARK: - ProviderBookingDetail
struct ProviderBookingDetail: Codable {
    let hostInfo, serviceProvider: HostInfo
    let bookingDate: String
    let amount, total: Int
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



// MARK: - Link
struct Link: Codable {
    let url: String?
    let label: String
    let active: Bool
}
