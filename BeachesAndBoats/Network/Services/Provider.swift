//
//  Provider.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

//import Foundation
//import Moya
//import Alamofire
//import CommonCrypto
//
//public class Provider<T: TargetType> {
//    private var moyaError: MoyaError?
//    
//    private let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
//    private let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
//
//    var provider: MoyaProvider<T> {
//        let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
//        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
//        
//        return MoyaProvider<T>(
//            stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior },
//            session: getSession(),
//            plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)]
//        )
//    }
//    
//    private func getSession() -> Session {
//        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
//            "beachesandboats.com": DisabledTrustEvaluator()
//        ]
//        let manager = ServerTrustManager(evaluators: serverTrustPolicies)
//        return Session(serverTrustManager: manager)
//    }
//     
//    func handleResult<U: Codable>(result: Result<Moya.Response, MoyaError>) -> Result<U, ErrorResponse> {
//        switch result {
//        case let .success(response):
//            do {
//                // Debug logging
//                if let JSONString = String(data: response.data, encoding: .utf8) {
//                    print("Success Response: \(JSONString)")
//                }
//                
//                let results = try JSONDecoder().decode(U.self, from: response.data)
//                return .success(results)
//            } catch {
//                print("Decoding error: \(error)")
//                return .failure(handleErrorCodes(0))
//            }
//            
//        case let .failure(error):
//            moyaError = error
//            
//            // Try to decode error response from server
//            if let data = error.response?.data {
//                if let JSONString = String(data: data, encoding: .utf8) {
//                    print("Error Response: \(JSONString)")
//                }
//                
//                do {
//                    let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                    return .failure(result)
//                } catch {
//                    print("Error decoding ErrorResponse: \(error)")
//                }
//            }
//            
//            // Fallback to handling by status code
//            if let statusCode = error.response?.statusCode {
//                return .failure(handleErrorCodes(statusCode))
//            }
//            
//            return .failure(handleErrorCodes(0))
//        }
//    }
//    
//    func getData<V: Codable>(result: Result<V, ErrorResponse>) -> Data {
//        switch result {
//        case .success(let response):
//            do {
//                let jsonData = try JSONEncoder().encode(response)
//                return jsonData
//            } catch {
//                print("Encoding error: \(error)")
//                return Data()
//            }
//        case .failure(let error):
//            print("Result failure: \(error)")
//            return Data()
//        }
//    }
//    
//    func handleError(_ error: MoyaError) -> ErrorResponse {
//        switch error {
//        case .underlying(let (_, response)):
//            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
//            return handleErrorCodes(statusCode)
//        case .statusCode(let response):
//            return handleErrorCodes(response.statusCode)
//        default:
//            return ErrorResponse(message: "Something went wrong", status: false, errors: nil)
//        }
//    }
//    
//    func handleErrorCodes(_ code: Int) -> ErrorResponse {
//        switch code {
//        case 401:
//            return ErrorResponse(message: "Unauthorized Access", status: false, errors: nil)
//        case 408:
//            return ErrorResponse(message: "Request timeout", status: false, errors: nil)
//        case 500...599:
//            return ErrorResponse(message: "Server error", status: false, errors: nil)
//        case 400...499:
//            return ErrorResponse(message: "Client error", status: false, errors: nil)
//        default:
//            return ErrorResponse(message: "Something went wrong", status: false, errors: nil)
//        }
//    }
//    
//    func handleNoInternetError() -> ErrorResponse {
//        return ErrorResponse(
//            message: "Looks like the server is unreachable. You may need to check your network and try again.",
//            status: false,
//            errors: nil
//        )
//    }
//}

import Foundation
import Moya
import Alamofire
import Network
import CommonCrypto

public class Provider<T: TargetType> {
    private var moyaError: MoyaError?
    private let networkMonitor = NWPathMonitor()
    private let monitorQueue = DispatchQueue(label: "NetworkMonitor")
    private var isNetworkAvailable = true
    
    private let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
    private let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)

    public init() {
        startNetworkMonitoring()
    }
    
    deinit {
        networkMonitor.cancel()
    }
    
    // MARK: - Network Monitoring
    
    private func startNetworkMonitoring() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkAvailable = path.status == .satisfied
            }
        }
        networkMonitor.start(queue: monitorQueue)
    }
    
    private func isConnectedToNetwork() -> Bool {
        return isNetworkAvailable
    }

    var provider: MoyaProvider<T> {
        let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        
        return MoyaProvider<T>(
            stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior },
            session: getSession(),
            plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)]
        )
    }
    
    private func getSession() -> Session {
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            "beachesandboats.com": DisabledTrustEvaluator()
        ]
        let manager = ServerTrustManager(evaluators: serverTrustPolicies)
        
        // Configure session with timeout intervals
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        
        return Session(
            configuration: configuration,
            serverTrustManager: manager
        )
    }
    
    // MARK: - Network Request Methods
    
    func request<U: Codable>(target: T, completion: @escaping (Result<U, ErrorResponse>) -> Void) {
        // Check network connectivity first
        guard isConnectedToNetwork() else {
            completion(.failure(handleNoInternetError()))
            return
        }
        
        provider.request(target) { [weak self] result in
            guard let self = self else { return }
            
            let handledResult: Result<U, ErrorResponse> = self.handleResult(result: result)
            completion(handledResult)
        }
    }
    
    func handleResult<U: Codable>(result: Result<Moya.Response, MoyaError>) -> Result<U, ErrorResponse> {
        switch result {
        case let .success(response):
            return handleSuccessResponse(response: response)
            
        case let .failure(error):
            return handleFailureResponse(error: error)
        }
    }
    
    // MARK: - Success Response Handling
    
    private func handleSuccessResponse<U: Codable>(response: Moya.Response) -> Result<U, ErrorResponse> {
        // Log response for debugging
        if let jsonString = String(data: response.data, encoding: .utf8) {
            print("✅ Success Response [\(response.statusCode)]: \(jsonString)")
        }
        
        // Handle successful HTTP status codes
        guard 200...299 ~= response.statusCode else {
            print("⚠️ Unexpected success status code: \(response.statusCode)")
            return .failure(handleErrorCodes(response.statusCode))
        }
        
        do {
            let results = try JSONDecoder().decode(U.self, from: response.data)
            return .success(results)
        } catch let decodingError {
            print("❌ Decoding error: \(decodingError)")
            
            // More detailed decoding error handling
            if let decodingError = decodingError as? DecodingError {
                return .failure(handleDecodingError(decodingError))
            }
            
            return .failure(ErrorResponse(
                message: "Failed to parse server response",
                status: false,
                errors: .dictionary(["decoding": ["Invalid response format"]])
            ))
        }
    }
    
    // MARK: - Failure Response Handling

    private func handleFailureResponse<U: Codable>(error: MoyaError) -> Result<U, ErrorResponse> {
        moyaError = error
        
        // Handle MoyaError types first
        switch error {
        case .underlying(let (afError, response)):
            // Check for network connectivity issues using AFError
            if let afError = afError as? AFError {
                switch afError {
                case .sessionTaskFailed(let sessionError):
                    if let urlError = sessionError as? URLError {
                        switch urlError.code {
                        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                            return .failure(handleNoInternetError())
                        case .timedOut:
                            return .failure(handleTimeoutError())
                        case .cannotConnectToHost, .cannotFindHost:
                            // This handles NSURLErrorDomain Code=-1004 "Could not connect to the server"
                            return .failure(handleNoInternetError())
                        default:
                            // For any other URLError, also treat as network issue
                            return .failure(handleConnectionError(urlError))
                        }
                    }
                    // If it's not a URLError but still a session task failure, treat as connection issue
                    return .failure(handleConnectionError(sessionError))
                default:
                    break
                }
            }
            
            // Handle response if available
            if let response = response {
                if !response.data.isEmpty {
                    if let jsonString = String(data: response.data, encoding: .utf8) {
                        print("❌ Error Response [\(response.statusCode)]: \(jsonString)")
                    }
                    
                    do {
                        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        return .failure(errorResponse)
                    } catch {
                        print("⚠️ Failed to decode ErrorResponse in .underlying: \(error)")
                        return .failure(handleErrorCodes(response.statusCode))
                    }
                } else {
                    return .failure(handleErrorCodes(response.statusCode))
                }
            }

            
            // If no specific handling, treat as connection error
            return .failure(handleConnectionError(error))
            
        case .statusCode(let response):
            // Try to decode structured error response from server
            if !response.data.isEmpty {
                // Log error response for debugging
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("❌ Error Response [\(response.statusCode)]: \(jsonString)")
                }
                
                // Try to decode as ErrorResponse
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    return .failure(errorResponse)
                } catch {
                    print("⚠️ Failed to decode ErrorResponse: \(error)")
                    // Fall back to status code handling
                    return .failure(handleErrorCodes(response.statusCode))
                }
            }
            
            return .failure(handleErrorCodes(response.statusCode))
            
        case .requestMapping, .parameterEncoding, .encodableMapping:
            return .failure(ErrorResponse(
                message: "Invalid request format",
                status: false,
                errors: .dictionary(["request": ["Failed to format request"]])
            ))
            
        case .jsonMapping, .stringMapping, .objectMapping:
            return .failure(ErrorResponse(
                message: "Failed to parse response",
                status: false,
                errors: .dictionary(["response": ["Invalid response format"]])
            ))
        case .imageMapping(_):
            return .failure(ErrorResponse(
                message: "Failed to parse response",
                status: false,
                errors: .dictionary(["response": ["Invalid response format"]])
            ))
        }
    }

    // MARK: - Error Handling Helpers
    
    private func handleConnectionError(_ error: Error) -> ErrorResponse {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
                return handleNoInternetError()
            case .timedOut:
                return handleTimeoutError()
            case .cannotConnectToHost, .cannotFindHost:
                return ErrorResponse(
                    message: "Unable to connect to server. Please check your internet connection and try again.",
                    status: false,
                    errors: .dictionary(["connection": ["Cannot connect to server"]])
                )
            case .badServerResponse:
                return ErrorResponse(
                    message: "Server is not responding properly. Please try again later.",
                    status: false,
                    errors: .dictionary(["server": ["Bad server response"]])
                )
            default:
                return ErrorResponse(
                    message: "Connection failed. Please check your internet connection and try again.",
                    status: false,
                    errors: .dictionary(["connection": ["Connection error: \(urlError.localizedDescription)"]])
                )
            }
        }
        
        // For any other type of error
        return ErrorResponse(
            message: "Connection failed. Please check your internet connection and try again.",
            status: false,
            errors: .dictionary(["connection": ["Network connection failed"]])
        )
    }
    
    private func handleDecodingError(_ error: DecodingError) -> ErrorResponse {
        var errorMessage = "Failed to parse server response"
        var errors: [String: [String]] = [:]
        
        switch error {
        case .keyNotFound(let key, _):
            errorMessage = "Missing required field: \(key.stringValue)"
            errors["parsing"] = ["Missing field: \(key.stringValue)"]
        case .typeMismatch(let type, let context):
            errorMessage = "Invalid data type for field: \(context.codingPath.last?.stringValue ?? "unknown")"
            errors["parsing"] = ["Expected \(type) but got different type"]
        case .valueNotFound(let type, let context):
            errorMessage = "Missing value for required field: \(context.codingPath.last?.stringValue ?? "unknown")"
            errors["parsing"] = ["Missing required \(type) value"]
        case .dataCorrupted(let context):
            errorMessage = "Invalid data format"
            errors["parsing"] = [context.debugDescription]
        @unknown default:
            errorMessage = "Unknown parsing error"
            errors["parsing"] = ["Unknown decoding error"]
        }
        
        return ErrorResponse(
            message: errorMessage,
            status: false,
            errors: .dictionary(errors)
        )
    }
    
    func getData<V: Codable>(result: Result<V, ErrorResponse>) -> Data {
        switch result {
        case .success(let response):
            do {
                let jsonData = try JSONEncoder().encode(response)
                return jsonData
            } catch {
                print("❌ Encoding error: \(error)")
                return Data()
            }
        case .failure(let error):
            print("❌ Result failure: \(error)")
            return Data()
        }
    }
    
    func handleErrorCodes(_ code: Int) -> ErrorResponse {
        switch code {
        case 400:
            return ErrorResponse(
                message: "Bad request - please check your input",
                status: false,
                errors: .dictionary(["request": ["Invalid request parameters"]])
            )
        case 401:
            return ErrorResponse(
                message: "Authentication required - please log in again",
                status: false,
                errors: .dictionary(["auth": ["Invalid or expired token"]])
            )
        case 403:
            return ErrorResponse(
                message: "Access denied - insufficient permissions",
                status: false,
                errors: .dictionary(["permission": ["Insufficient privileges"]])
            )
        case 404:
            return ErrorResponse(
                message: "Resource not found",
                status: false,
                errors: .dictionary(["resource": ["The requested resource does not exist"]])
            )
        case 408:
            return ErrorResponse(
                message: "Request timeout - please try again",
                status: false,
                errors: .dictionary(["timeout": ["Request took too long to complete"]])
            )
        case 422:
            return ErrorResponse(
                message: "Validation failed - please check your input",
                status: false,
                errors: .dictionary(["validation": ["Input validation failed"]])
            )
        case 429:
            return ErrorResponse(
                message: "Too many requests - please wait before trying again",
                status: false,
                errors: .dictionary(["rate_limit": ["Request limit exceeded"]])
            )
        case 500:
            return ErrorResponse(
                message: "Internal server error - please try again later",
                status: false,
                errors: .dictionary(["server": ["Internal server error"]])
            )
        case 502:
            return ErrorResponse(
                message: "Service temporarily unavailable",
                status: false,
                errors: .dictionary(["server": ["Bad gateway"]])
            )
        case 503:
            return ErrorResponse(
                message: "Service temporarily unavailable - please try again later",
                status: false,
                errors: .dictionary(["server": ["Service unavailable"]])
            )
        case 501...599:
            return ErrorResponse(
                message: "Server error - please try again later",
                status: false,
                errors: .dictionary(["server": ["Server error occurred"]])
            )
        case 400...499:
            return ErrorResponse(
                message: "Request error - please check your input",
                status: false,
                errors: .dictionary(["client": ["Client error occurred"]])
            )
        default:
            return ErrorResponse(
                message: "An unexpected error occurred",
                status: false,
                errors: .dictionary(["unknown": ["Unknown error occurred"]])
            )
        }
    }
    
    func handleNoInternetError() -> ErrorResponse {
        return ErrorResponse(
            message: "No internet connection. Please check your network and try again.",
            status: false,
            errors: .dictionary(["network": ["No internet connection available"]])
        )
    }
    
    private func handleTimeoutError() -> ErrorResponse {
        return ErrorResponse(
            message: "Request timed out. Please check your connection and try again.",
            status: false,
            errors: .dictionary(["timeout": ["Request timed out"]])
        )
    }
    
    // MARK: - Utility Methods
    
    func retryRequest<U: Codable>(target: T, maxRetries: Int = 3, completion: @escaping (Result<U, ErrorResponse>) -> Void) {
        func attemptRequest(attempt: Int) {
            request(target: target) { (result: Result<U, ErrorResponse>) in
                switch result {
                case .success:
                    completion(result)
                case .failure(let error):
                    if attempt < maxRetries && self.shouldRetry(error: error) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(attempt)) {
                            attemptRequest(attempt: attempt + 1)
                        }
                    } else {
                        completion(result)
                    }
                }
            }
        }
        
        attemptRequest(attempt: 1)
    }
    
    private func shouldRetry(error: ErrorResponse) -> Bool {
        // Retry for network issues, timeouts, and server errors
        guard let errors = error.errors else { return false }
        
        switch errors {
        case .list(_):
            // For list format, we can't determine specific error types easily
            return false
        case .dictionary(let dict):
            return dict.keys.contains("network") ||
                   dict.keys.contains("timeout") ||
                   dict.keys.contains("server")
        }
    }
}
