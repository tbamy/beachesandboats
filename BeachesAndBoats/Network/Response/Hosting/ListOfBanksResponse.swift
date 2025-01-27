//
//  ListOfBanksResponse.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import Foundation

struct ListOfBanksResponse: Codable {
    let status: Bool
    let message: String
    let data: [ListOfBanks]?
}

struct ListOfBanks: Codable {
    let id: Int
    let name: String?
    let slug: String?
    let code: String?
    let longcode: String?
    let gateway: Gateway?
    let payWithBank: Bool?
    let supportsTransfer: Bool?
    let active: Bool?
    let country: Country?
    let currency: Currency?
    let type: TypeEnum?
    let isDeleted: Bool?
    let createdAt: String?
    let updatedAt: String?

    enum CodingKeys: String, CodingKey {
        case id, name, slug, code, longcode, gateway
        case payWithBank = "pay_with_bank"
        case supportsTransfer = "supports_transfer"
        case active, country, currency, type
        case isDeleted = "is_deleted"
        case createdAt, updatedAt
    }
}

enum Country: String, Codable {
    case nigeria = "Nigeria"
}

enum Currency: String, Codable {
    case ngn = "NGN"
}

enum Gateway: String, Codable {
    case digitalbankmandate = "digitalbankmandate"
    case emandate = "emandate"
    case empty = ""
    case ibank = "ibank"
    case null = "null"
}

enum TypeEnum: String, Codable {
    case nuban = "nuban"
}
