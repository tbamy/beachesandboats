//
//  HostingService.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 30/12/2024.
//

import Foundation

protocol HostingService {
    func getUpcomingBooking(completion: @escaping(Result<ServiceReservations, ErrorResponse>) -> Void)
    func getTopEarnings(request: TopEarningRequest, completion: @escaping(Result<TopEarningResponse, ErrorResponse>) -> Void)
    func getWithdrawalHistory(completion: @escaping(Result<WithdrawalResponse, ErrorResponse>) -> Void)
    func makeWithdrawal(request: CreateWithdrawalRequest, completion: @escaping(Result<CreateWithdrawalResponse, ErrorResponse>) -> Void)
    func getBanks(completion: @escaping(Result<ListOfBanksResponse, ErrorResponse>) -> Void)
}
