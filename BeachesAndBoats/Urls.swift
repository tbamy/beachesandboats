//
//  Urls.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/08/2024.
//

import Foundation

enum Urls: String {
    
    //MARK: Onboarding
    
    case register = "api/v1/create-profile"
    case confirmAccount = "api/v1/send-otp"
    case verifyCode = "api/v1/verify-otp"
    case refreshToken = "api/v1/refresh-token"
    case verifyLoginOtp = "api/v1/verify-login-otp"

    case login = "api/v1/login"
    case logout = "api/v1/logout"
    case getPhoneCodes = "api/v1/phonecodes"
    
    //MARK: Profile Management
    case resetPassword = "api/v1/reset-password"
    case checkCode = "api/v1/password/code/check"
    case changePassword = "api/v1/change-password"
    case enable2FAEmail = "api/v1/accounts/settings/2fa/enable/email"
    case enable2FAPhone = "api/v1/accounts/settings/2fa/enable/sms"
    case verify2FA = "api/v1/accounts/settings/2fa/verify"
    case requestCode2FA = "api/v1/accounts/settings/2fa/request/email"
    case getDashboardUser = "api/v1/hosting/dashboard/user"
    case sendKYC = "api/v1/kyc-request"
    
    
    //MARK: Booking
    
    case getBookingCategories = "api/v1/booking"
    case addOrUpdateReview = "api/v1/booking/add-review"
    case addOrUpdateFavourite = "api/v1/booking/add-favourite"
    case createBeachHouseBooking = "api/v1/booking/book-beach-house"
    case createBoatBooking = "api/v1/booking/book-boat"
    case bookingConfiguration = "api/v1/booking/booking-configuration"
    case allDishes = "api/v1/booking/dishes"
    case findChefByDishes = "api/v1/booking/find-chef"
    case bookServiceProvider = "api/v1/booking/book-service"
    case updateProviderBookingDate = "api/v1/booking/update-service-booking"
    case findBouncers = "api/v1/booking/find-bouncer"
    case findDj = "api/v1/booking/find-dj"
    
    
    
    //MARK: Boat
    
    case createBoat = "api/v1/boat/create"
    case propertiesData = "api/v1/property/data"
    
    //MARK: Beach
    
    case createBeach = "api/v1/beachhouse/create"
    
    
    //MARK: Services
    
    case createService = "api/v1/provider/create"
    
    //MARK: -  Hosting
    
    case getUpcomingBooking = "api/v1/hosting/dashboard/reservations"
    case getTopEarnings = "api/v1/hosting/dashboard/earnings"
    case getWithdrawHistory = "api/v1/hosting/dashboard/withdrawal-history"
    case makeWithdrawal = "api/v1/hosting/dashboard/create-withdrawal"
    case bankList = "api/v1/hosting/dashboard/banks"
}
