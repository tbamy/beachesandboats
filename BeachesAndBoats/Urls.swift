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
    case forgotPassword = "api/v1/forgot-password"
    case resetPassword = "api/v1/reset-password"
    
    case login = "api/v1/login"
    case logout = "api/v1/logout"
    case getPhoneCodes = "api/v1/phonecodes"
    
    //MARK: Profile Management
    case checkCode = "api/v1/password/code/check"
    case changePassword = "api/v1/user/update-password"
    case updateProfile = "api/v1/user/update-account"
    case getDashboardUser = "api/v1/hosting/dashboard/user"
    case sendKYC = "api/v1/kyc-request"
    case updateNotificationSettings = "api/v1/user/update-notification-settings"
    case customerSupport = "api/v1/user/support"
    
    case getUserBookings = "api/v1/user/bookings"
    case getSavedFavourites = "api/v1/user/favourites"
    
    
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
    case paymentCallback = "api/v1/callback/paystack/booking"
    case getBeachHouse = "api/v1/beachhouse/%@"
    case getBoat = "api/v1/boat/%@"
    case cancelBooking = "api/v1/booking/cancel"
    //    case createInvoice = "api/v1/booking/book-service"
    
    
    
    //MARK: Boat
    
    case createBoat = "api/v1/boat/create"
    case propertiesData = "api/v1/property/data"
    case editBoat = "api/v1/boat/edit/%@"
    case deleteBoat = "api/v1/boat/delete-boat/%@"
    
    //MARK: Beach
    
    case createBeach = "api/v1/beachhouse/create"
    case editBeach = "api/v1/beachhouse/edit/%@"
    case deleteBeachRoom = "api/v1/beachhouse/delete-beach-room/%@"
    case deleteBeachHouse = "api/v1/beachhouse/delete-beach-house/%@"
    
    
    //MARK: Services
    
    case createService = "api/v1/provider/create"
    
    //MARK: -  Hosting
    
    case reservations = "api/v1/hosting/dashboard/reservations"
    case getTopEarnings = "api/v1/hosting/dashboard/earnings"
    case getWithdrawHistory = "api/v1/hosting/dashboard/withdrawal-history"
    case makeWithdrawal = "api/v1/hosting/dashboard/create-withdrawal"
    case bankList = "api/v1/hosting/dashboard/banks"
    case twoFASecurity = "api/v1/user/send-mfa-otp"
    case twoFACompleteVerification = "api/v1/user/update-mfa-security"
    
    //MARK: - Listing
    case beachHouseAndBoatListing = "api/v1/hosting/dashboard/listings"
    case deleteImages = "api/v1/property-image/remove"
    
    
    //MARK: - Chats
    case startConversation = "api/v1/chat/start-conversation"
    case sendChat = "api/v1/chat/send-chat"
    case getConservations = "api/v1/chat/get-conversations"
    case getMessageHistory = "api/v1/chat/get-messages/%@"
    
    //MARK: - Date Reservation
    
    case getReservedDates = "api/v1/reserved-dates"
    case removeReservedDates = "api/v1/reserved-dates/remove"
    case addReservedDates = "api/v1/reserved-dates/add-multiple"
    
}
