//
//  CreateWithdrawalRequest.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import Foundation

struct CreateWithdrawalRequest: Codable {
    let withdrawalType: WithdrawalType
    let amount: Double
    let bankName: String?
    let bankAccountNumber: String?
    let mobileMoneyNumber: String?
    
    init(withdrawalType: WithdrawalType,
             amount: Double,
             bankName: String? = nil,
             bankAccountNumber: String? = nil,
             mobileMoneyNumber: String? = nil) {
            self.withdrawalType = withdrawalType
            self.amount = amount
            self.bankName = bankName
            self.bankAccountNumber = bankAccountNumber
            self.mobileMoneyNumber = mobileMoneyNumber
        }
    
    enum CodingKeys: String, CodingKey {
        case withdrawalType = "withdrawal_type"
        case amount
        case bankName = "bank_name"
        case bankAccountNumber = "bank_account_number"
        case mobileMoneyNumber = "mobile_money_number"
    }
}

enum WithdrawalType: String, Codable {
    case mobileMoeny = "Mobile_Money"
    case bank = "Bank"
}
