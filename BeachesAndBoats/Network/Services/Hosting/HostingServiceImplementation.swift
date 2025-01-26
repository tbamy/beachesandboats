//
//  HostingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 30/12/2024.
//

import Foundation
import Moya

class HostingServiceImplementation: Provider<HostingTarget>, HostingService {
    func beachHouseListing(completion: @escaping (Result<BeachHouseListingResponse, ErrorResponse>) -> Void) {
        provider.request(.beachHouseListing) { completion(self.handleResult(result: $0))}
    }
    
    func boatHouseListing(completion: @escaping (Result<BeachHouseListingResponse, ErrorResponse>) -> Void) {
        provider.request(.boatHouseListing) { completion(self.handleResult(result: $0))}
    }
    
//    func beachHouseListing(completion: @escaping (Result<BeachHouseListingResponseData, ErrorResponse>) -> Void) {
//        provider.request(.beachHouseListing) { completion(self.handleResult(result: $0))}
//    }
    
    func beachHouseReservation(completion: @escaping (Result<BeachHouseReservations, ErrorResponse>) -> Void) {
        provider.request(.beachHouseReservations) { completion(self.handleResult(result: $0))}
    }
    
    func boatReservation(completion: @escaping (Result<BoatReservations, ErrorResponse>) -> Void) {
        provider.request(.boatReservations) { completion(self.handleResult(result: $0))}
    }
    
    func twoFACompleteVerification(request: TwoFACompleteVerificationRequest, completion: @escaping (Result<TwoFACompleteVerificationResponse, ErrorResponse>) -> Void) {
        provider.request(.TwoFACompleteVerification(request)) {completion(self.handleResult(result: $0))}

    }
    
    func getPhoneSecurity(request: TwoFAPhoneSecurityRequest, completion: @escaping (Result<TwoFASecurityResponse, ErrorResponse>) -> Void) {
        provider.request(.PhoneNumberSecurity(request)) {completion(self.handleResult(result: $0))}

    }
    
    func getEmailSecurity(request: TwoFAEmailSecurityRequest, completion: @escaping (Result<TwoFASecurityResponse, ErrorResponse>) -> Void) {
        provider.request(.EmailSecurity(request)) {completion(self.handleResult(result: $0))}

    }
    
    func getBanks(completion: @escaping (Result<ListOfBanksResponse, ErrorResponse>) -> Void) {
        provider.request(.getBanks){ completion( self.handleResult(result: $0)) }
    }
    
    func makeWithdrawal(request: CreateWithdrawalRequest, completion: @escaping (Result<CreateWithdrawalResponse, ErrorResponse>) -> Void) {
        provider.request(.MakeWithdrawal(request)) {completion(self.handleResult(result: $0))}
    }
    
    func getWithdrawalHistory(completion: @escaping (Result<WithdrawalResponse, ErrorResponse>) -> Void) {
        provider.request(.WithdrawHistory){ completion( self.handleResult(result: $0)) }
    }
    
    func getTopEarnings(request: TopEarningRequest, completion: @escaping (Result<TopEarningResponse, ErrorResponse>) -> Void) {
        provider.request(.TopEarnings(request)) {completion(self.handleResult(result: $0))}
    }
    
    func getUpcomingBooking(completion: @escaping (Result<ServiceReservations, ErrorResponse>) -> Void) {
        provider.request(.GetHostBooking){ completion( self.handleResult(result: $0)) }
    }
}
