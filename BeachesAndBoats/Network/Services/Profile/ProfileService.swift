//
//  ProfileService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/10/2024.
//

import Foundation

protocol ProfileService{
    func getDashboardUser(completion: @escaping(Result<DashboardUserReponse, ErrorResponse>) -> Void)
    func sendKYC(request: SendKYCRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
}
