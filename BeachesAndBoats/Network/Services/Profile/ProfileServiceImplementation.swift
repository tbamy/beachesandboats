//
//  ProfileServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import Foundation

class ProfileServiceImplementation: Provider<ProfileTarget>, ProfileService{
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
