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
    func getSavedFavourites(completion: @escaping(Result<GetSavedFavouritesResponse, ErrorResponse>) -> Void)
    func getUserBookings(completion: @escaping(Result<GetUserBookingsResponse, ErrorResponse>) -> Void)
    func updateNotificationSettings(request: NotificationSettingsRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    func getCustomerSupportInfo(completion: @escaping(Result<CustomerSupportInfoResponse, ErrorResponse>) -> Void)
    func updateProfileRequest(request: UpdateProfileRequest, completion: @escaping(Result<UpdateProfileResponse, ErrorResponse>) -> Void)
    func changePasswordRequest(request: ChangePasswordRequest, completion: @escaping(Result<UpdateProfileResponse, ErrorResponse>) -> Void)
}
