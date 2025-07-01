//
//  Provider.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation
import Moya
import Alamofire
import CommonCrypto

public class Provider<T: TargetType> {
    private var moyaError: MoyaError?
    
    private let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
    private let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)

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
        return Session(serverTrustManager: manager)
    }
     
    func handleResult<U: Codable>(result: Result<Moya.Response, MoyaError>) -> Result<U, ErrorResponse> {
        switch result {
        case let .success(response):
            do {
                // Debug logging
                if let JSONString = String(data: response.data, encoding: .utf8) {
                    print("Success Response: \(JSONString)")
                }
                
                let results = try JSONDecoder().decode(U.self, from: response.data)
                return .success(results)
            } catch {
                print("Decoding error: \(error)")
                return .failure(handleErrorCodes(0))
            }
            
        case let .failure(error):
            moyaError = error
            
            // Try to decode error response from server
            if let data = error.response?.data {
                if let JSONString = String(data: data, encoding: .utf8) {
                    print("Error Response: \(JSONString)")
                }
                
                do {
                    let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    return .failure(result)
                } catch {
                    print("Error decoding ErrorResponse: \(error)")
                }
            }
            
            // Fallback to handling by status code
            if let statusCode = error.response?.statusCode {
                return .failure(handleErrorCodes(statusCode))
            }
            
            return .failure(handleErrorCodes(0))
        }
    }
    
    func getData<V: Codable>(result: Result<V, ErrorResponse>) -> Data {
        switch result {
        case .success(let response):
            do {
                let jsonData = try JSONEncoder().encode(response)
                return jsonData
            } catch {
                print("Encoding error: \(error)")
                return Data()
            }
        case .failure(let error):
            print("Result failure: \(error)")
            return Data()
        }
    }
    
    func handleError(_ error: MoyaError) -> ErrorResponse {
        switch error {
        case .underlying(let (_, response)):
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            return handleErrorCodes(statusCode)
        case .statusCode(let response):
            return handleErrorCodes(response.statusCode)
        default:
            return ErrorResponse(message: "Something went wrong", status: false, errors: nil)
        }
    }
    
    func handleErrorCodes(_ code: Int) -> ErrorResponse {
        switch code {
        case 401:
            return ErrorResponse(message: "Unauthorized Access", status: false, errors: nil)
        case 408:
            return ErrorResponse(message: "Request timeout", status: false, errors: nil)
        case 500...599:
            return ErrorResponse(message: "Server error", status: false, errors: nil)
        case 400...499:
            return ErrorResponse(message: "Client error", status: false, errors: nil)
        default:
            return ErrorResponse(message: "Something went wrong", status: false, errors: nil)
        }
    }
    
    func handleNoInternetError() -> ErrorResponse {
        return ErrorResponse(
            message: "Looks like the server is unreachable. You may need to check your network and try again.",
            status: false,
            errors: nil
        )
    }
}

//public class Provider<T: TargetType> {
//    private var moyaError: MoyaError?
//    
//    private let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
//    private let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
//
//    
//   var provider: MoyaProvider<T> {
//       let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
//        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
//        
//       return MoyaProvider<T>(stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior }, session: getSession(), plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)])
//
//    }
//    
//    private func getSession() -> Session {
//        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
////            "beachesandboat.com": PinnedCertificatesTrustEvaluator()
//            "beachesnboats.azurewebsites.net": DisabledTrustEvaluator()
//        ]
//        let manager = ServerTrustManager(evaluators: serverTrustPolicies)
//        return Session.init(serverTrustManager: manager)
//    }
//     
//    func handleResult<U: Codable>(result: Result<Moya.Response, MoyaError>) -> Result<U, ErrorResponse> {
//        switch result {
//        case let .success(response):
//            do {
//                if let JSONString = String(data: response.data, encoding: String.Encoding.utf8) {
//                    print(JSONString)
//                }
//                let results = try JSONDecoder().decode(U.self, from: response.data)
//                return .success(results)
//            } catch {
//                print(error)
//                return .failure(handleErrorCodes(0))
//            }
//        case let .failure(error):
//            moyaError = error
//            do {
////                if !NetworkManager.shared.isConnected {
////                    return .failure(handleNoInternetError())
////                }
//                if let data = error.response?.data, let JSONString = String(data: data, encoding: String.Encoding.utf8) {
//                    print(JSONString)
//                    let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
////                    if result.responseCode == 15 {
////                        MiddleModal.show(title: "Session Timeout", type: .error, dismissable: false, onConfirm: { UserSession.shared.performLogout()} )
////                    } else {
//                        return .failure(result)
////                    }
//                }
//            } catch {
//                print(error)
//
//            }
//            return .failure(handleErrorCodes(0))
//        }
//    }
//    
//    func getData<V: Codable>(result: Result<V, ErrorResponse>) -> Data {
//        switch result {
//        case .success(let response):
//            do {
//                let jsonData = try JSONEncoder().encode(response)
//                let jsonString = String(data: jsonData, encoding: .utf8)
//                return jsonString?.data(using: String.Encoding.utf8) ?? Data()
//            } catch {
//                print(error)
//            }
//        case .failure(let error):
//            print(error)
//        }
//        return Data()
//    }
//    
//    func handleError(_ error: MoyaError) -> ErrorResponse {
//        switch error {
//        case .underlying(let (_, moyaError)):
//            return handleErrorCodes(moyaError?.statusCode ?? 0)
//        case .statusCode(let error):
//            return handleErrorCodes(error.statusCode)
//        default:
//            return ErrorResponse(message: "Something went wrong", status: false, errors: [])
//        }
//    }
//    
//    func handleErrorCodes(_ code: Int) -> ErrorResponse {
//        switch code {
//         case 401:
//            return ErrorResponse(message: "Unauthorized Access", status: false, errors: [])
//        case 408:
//            return ErrorResponse(message: "Request timeout", status: false, errors: [])
//        default:
//            return ErrorResponse(message: "Something went wrong", status: false, errors: [])
//        }
//    }
//    
//    func handleNoInternetError() -> ErrorResponse {
//        ErrorResponse(message: "Looks like the server is unreachable. You may need to check your network and try again.", status: false, errors: [])
//    }
//}


