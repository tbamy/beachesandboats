//
//  ProfileServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import Foundation

class ProfileServiceImplementation: Provider<ProfileTarget>, ProfileService{
    func sendKYC(request: SendKYCRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.sendKYC(request)){ completion( self.handleResult(result: $0))}
    }
    
    func getDashboardUser(completion: @escaping (Result<DashboardUserReponse, ErrorResponse>) -> Void) {
        provider.request(.GetDashboardUser){ completion( self.handleResult(result: $0))}
    }
    
    
}
