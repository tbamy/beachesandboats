//
//  ProfileServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import Foundation

class ProfileServiceImplementation: Provider<ProfileTarget>, ProfileService{
    func updateProfileRequest(request: UpdateProfileRequest, completion: @escaping (Result<UpdateProfileResponse, ErrorResponse>) -> Void) {
        provider.request(.updateProfile(request)){ completion( self.handleResult(result: $0))}
    }
    
    func changePasswordRequest(request: ChangePasswordRequest, completion: @escaping (Result<UpdateProfileResponse, ErrorResponse>) -> Void) {
        provider.request(.changePassword(request)){ completion( self.handleResult(result: $0))}
    }
    
    func getCustomerSupportInfo(completion: @escaping (Result<CustomerSupportInfoResponse, ErrorResponse>) -> Void) {
        provider.request(.getCustomerSupportInfo){ completion( self.handleResult(result: $0))}
    }
    
    func updateNotificationSettings(request: NotificationSettingsRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.updateNotificationSettings(request)){ completion( self.handleResult(result: $0))}
    }
    
    func getSavedFavourites(completion: @escaping (Result<GetSavedFavouritesResponse, ErrorResponse>) -> Void) {
        provider.request(.getSavedFavourites){ completion( self.handleResult(result: $0))}
    }
    
    func getUserBookings(completion: @escaping (Result<GetUserBookingsResponse, ErrorResponse>) -> Void) {
        provider.request(.getUserBookings){ completion( self.handleResult(result: $0))}
    }
    
    func sendKYC(request: SendKYCRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.sendKYC(request)){ completion( self.handleResult(result: $0))}
    }
    
    func getDashboardUser(completion: @escaping (Result<DashboardUserReponse, ErrorResponse>) -> Void) {
        provider.request(.GetDashboardUser){ completion( self.handleResult(result: $0))}
    }
    
    
}
