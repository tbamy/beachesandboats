//
//  AuthInterceptor.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/07/2025.
//

import Foundation
import Moya
import Alamofire

class AuthInterceptor: RequestInterceptor {
    private var isRefreshing = false
    private var requestsToRetry: [(RetryResult) -> Void] = []
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let token = UserSession.shared.token {
            urlRequest.headers.add(.authorization(bearerToken: token))
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // If not a 401, don’t retry
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        // Add this retry handler to the queue
        requestsToRetry.append(completion)
        
        // If already refreshing, wait
        if isRefreshing { return }
        
        isRefreshing = true
        
        TokenManager.shared.refreshToken { [weak self] success in
            guard let self = self else { return }
            self.isRefreshing = false
            
            let retryResult: RetryResult = success ? .retry : .doNotRetry
            self.requestsToRetry.forEach { $0(retryResult) }
            self.requestsToRetry.removeAll()
        }
    }
}
