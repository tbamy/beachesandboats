//
//  Urls.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/08/2024.
//

import Foundation

enum Urls: String {
    
    //MARK: Onboarding
    
    case register = "api/v1/register"
    case confirmAccount = "api/v1/confirm-account"
    case verifyCode = "api/v1/verify-code"
    case refreshToken = "api/v1/refresh-tokens"

    case login = "api/v1/login"
    case logout = "api/v1/logout"
    
    //MARK: Profile Management
    case resetPassword = "api/v1/reset-password"
    case checkCode = "api/v1/password/code/check"
    case changePassword = "api/v1/change-password"
    case enable2FAEmail = "api/v1/accounts/settings/2fa/enable/email"
    case enable2FAPhone = "api/v1/accounts/settings/2fa/enable/sms"
    case verify2FA = "api/v1/accounts/settings/2fa/verify"
    case requestCode2FA = "api/v1/accounts/settings/2fa/request/email"
    
    
    
    //MARK: Boat
    
    case createBoat = "api/v1/accounts/client/property/listings/boats/create"
    case boatData = "api/v1/accounts/client/property/datas/boat"
    
    //MARK: Beach
    
    case createBeach = "api/v1/accounts/client/property/listings/beach/create"
    case beachData = "api/v1/accounts/client/property/datas/beach"
    
    
    //MARK: Services
    
    case createService = "api/v1/accounts/client/services/listings/create"
    case chefDishes = "api/v1/accounts/client/services/datas/chef"
    
}
