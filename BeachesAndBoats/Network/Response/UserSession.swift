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
            token = loginRes?.access_token
            userDetails = loginRes?.user
            print("User token is : \(token ?? "")")
        }
    }
    
    var token: String?
    var startSession: Bool = false {
        didSet {
            if let window = UIApplication.shared.windows.first as? AppWindow {
                window.start()
            }
        }
    }
    var environment: Environment?
    
    
    func performLogout() {
        startSession = false
        let navigationController = BaseNavigationController()
        let coordinator = AppCoordinator(navigationController: navigationController, completion: nil)
        coordinator.start()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = navigationController
        }

    }
}

