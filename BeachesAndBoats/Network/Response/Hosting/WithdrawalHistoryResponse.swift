//
//  WithdrawalHistoryResponse.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import Foundation
//
//struct WithdrawalResponse: Codable {
//    let status: Bool
//    let message: String?
//    let data: [String: [WithdrawalDetail]]? // Optional to handle empty cases
//    let errors: String?
//}
//
//struct WithdrawalDetail: Codable {
//    let id: String?
//    let amount: Decimal?
//    let status: String?
//    let createdAt: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case amount
//        case status
//        case createdAt = "created_at"
//    }
//}
//
//extension WithdrawalResponse {
//    static var mockData: WithdrawalResponse {
//        return WithdrawalResponse(
//            status: true,
//            message: "Success!",
//            data: [
//                "2024-01-02": [
//                    WithdrawalDetail(
//                        id: "1",
//                        amount: 55000,
//                        status: "completed",
//                        createdAt: "2024-01-02T10:10:00Z"
//                    ),
//                    WithdrawalDetail(
//                        id: "2",
//                        amount: 55000,
//                        status: "completed",
//                        createdAt: "2024-01-02T22:08:00Z"
//                    )
//                ],
//                "2024-01-04": [
//                    WithdrawalDetail(
//                        id: "3",
//                        amount: 55000,
//                        status: "completed",
//                        createdAt: "2024-01-04T10:39:00Z"
//                    ),
//                    WithdrawalDetail(
//                        id: "4",
//                        amount: 55000,
//                        status: "completed",
//                        createdAt: "2024-01-04T10:39:00Z"
//                    )
//                ]
//            ],
//            errors: nil
//        )
//    }
//}


struct WithdrawalResponse: Codable {
    let status: Bool?
    let message: String?
    let data: [WithdrawalDetail]?// Changed from [String: [WithdrawalDetail]]
    let errors: String?
}

struct WithdrawalDetail: Codable {
    let id: String?
    let amount: Decimal?
    let status: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case amount
        case status
        case createdAt = "created_at"
    }
}

extension WithdrawalResponse {
    static var mockData: WithdrawalResponse {
        return WithdrawalResponse(
            status: true,
            message: "Success!",
            data: [
                WithdrawalDetail(
                    id: "1",
                    amount: 55000,
                    status: "completed",
                    createdAt: "2024-01-02T10:10:00Z"
                ),
                WithdrawalDetail(
                    id: "2",
                    amount: 55000,
                    status: "completed",
                    createdAt: "2024-01-02T22:08:00Z"
                ),
                WithdrawalDetail(
                    id: "3",
                    amount: 55000,
                    status: "completed",
                    createdAt: "2024-01-04T10:39:00Z"
                ),
                WithdrawalDetail(
                    id: "4",
                    amount: 55000,
                    status: "completed",
                    createdAt: "2024-01-04T10:39:00Z"
                )
            ],
            errors: nil
        )
    }
}
