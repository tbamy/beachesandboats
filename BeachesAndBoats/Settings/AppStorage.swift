//
//  AppStorage.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/08/2024.
//

import Foundation

final class AppStorage {
    @UserDefault("environment")
    static var environment: String?
    
    @UserDefault("backTime")
    static var backTime: String?
    
    @UserDefault("firebaseToken")
    static var firebaseToken: String?
    
    @UserDefault("hasSignedUp")
    static var hasSignedUp: Bool?
    
    @UserDefault("username")
    static var username: String?
    
    @UserDefault("beachListing")
    static var beachListing: CreateBeachListingRequest?
    
    @UserDefault("boatListing")
    static var boatListing: CreateBoatListingRequest?
    
    @UserDefault("serviceListing")
    static var serviceListing: CreateServiceListingRequest?
}
