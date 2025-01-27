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
    func getPhoneSecurity(request: TwoFAPhoneSecurityRequest, completion: @escaping(Result<TwoFASecurityResponse, ErrorResponse>) -> Void)
    func getEmailSecurity(request: TwoFAEmailSecurityRequest, completion: @escaping(Result<TwoFASecurityResponse, ErrorResponse>) -> Void)
    func twoFACompleteVerification(request: TwoFACompleteVerificationRequest, completion: @escaping(Result<TwoFACompleteVerificationResponse, ErrorResponse>) -> Void)
    func beachHouseReservation(completion: @escaping(Result<BeachHouseReservations, ErrorResponse>) -> Void)
    func boatReservation(completion: @escaping(Result<BoatReservations, ErrorResponse>) -> Void)
    func beachHouseListing(completion: @escaping(Result<BeachHouseListingResponse, ErrorResponse>) -> Void)
    func boatHouseListing(completion: @escaping(Result<BeachHouseListingResponse, ErrorResponse>) -> Void)
}
