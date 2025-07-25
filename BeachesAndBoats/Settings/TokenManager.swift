//
//  TokenManager.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/07/2025.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let onboardingService = OnboardingServiceImplementation()
    private var isRefreshing = false
    private var refreshQueue: [(Bool) -> Void] = []

    func refreshToken(completion: @escaping (Bool) -> Void) {
        guard let refreshToken = UserSession.shared.token, !refreshToken.isEmpty else {
            logUserOut()
            completion(false)
            return
        }

        // Prevent multiple simultaneous refreshes
        if isRefreshing {
            refreshQueue.append(completion)
            return
        }

        isRefreshing = true
        refreshQueue.append(completion)

        let request = RefreshTokenRequest(token: refreshToken)
        onboardingService.refreshToken(request: request) { [weak self] data in
            
            self?.isRefreshing = false
            
            switch data {
            case .success(let response):
                UserSession.shared.token = response.data
                print("🔄 Token refreshed successfully")
                self?.refreshQueue.forEach { $0(true) }
            case .failure(_):
                self?.logUserOut()
            }
            
            self?.refreshQueue.removeAll()
        }
        
    }

    private func logUserOut() {
        DispatchQueue.main.async {
            MiddleModal.show(title: "Session Expired", subtitle: "Please log in again to continue", type: .error, dismissable: false, onConfirm: {
                UserSession.shared.performLogout()
            })
        }

        refreshQueue.forEach { $0(false) }
    }
}
