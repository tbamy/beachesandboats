//
//  UserSession.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import Foundation
import UIKit

class UserSession {
    static let shared = UserSession()
    
    private init() {
        // Initialize singleton
    }
    
    
    var userDetails: UserData?
    
    var loginRes: LoginResponse? {
        didSet {
            token = loginRes?.data?.access_token
            userDetails = loginRes?.data?.user
            print("User token is : \(token)")
        }
    }
    
//    var signupRes: SignUpResponse? {
//        didSet {
//            token = signupRes?.data?.accessToken
//            userDetails = signupRes?.data?.user
//            print("User token is : \(token)")
//        }
//    }
    
    var token: String?
    var startSession: Bool = false {
        didSet {
            if let window = UIApplication.shared.windows.first as? AppWindow {
                window.startSessionTimer()
            }
        }
    }
    var environment: Environment?
    
    
    func performLogout() {
        if let window = UIApplication.shared.windows.first as? AppWindow {
            window.stopAllTimers()
        }
        startSession = false
        userDetails = nil
        let navigationController = BaseNavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController, completion: nil)
        coordinator.start()
        UIApplication.shared.windows.first?.rootViewController = navigationController
    }
}

