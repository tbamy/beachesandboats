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
    
//    var plainProvider: MoyaProvider<T> {
//         return MoyaProvider<T>(stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior }, plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)])
//     }
    
   var provider: MoyaProvider<T> {
       let authPlugin = AccessTokenPlugin { _ in UserSession.shared.token ?? "" }
        let loggerConfig = NetworkLoggerPlugin.Configuration(logOptions: .verbose)
        if Configuration.environment == .Release {
           return MoyaProvider<T>(stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior }, session: getSession(), plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)])
        }
        return MoyaProvider<T>(stubClosure: { (_: T) -> Moya.StubBehavior in Configuration.stubBehavior }, plugins: [authPlugin, NetworkLoggerPlugin(configuration: loggerConfig)])
    }
    
    private func getSession() -> Session {
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
//            "benbsbackend.etogetherness.com": PinnedCertificatesTrustEvaluator()
            "benb.wqcdesigns.com": DisabledTrustEvaluator()
        ]
        let manager = ServerTrustManager(evaluators: serverTrustPolicies)
        return Session.init(serverTrustManager: manager)
    }
    
    func handleResult<U: Codable>(result: Result<Moya.Response, MoyaError>) -> Result<U, ErrorResponse> {
        switch result {
        case let .success(response):
            do {
                if let JSONString = String(data: response.data, encoding: String.Encoding.utf8) {
                    print(JSONString)
                }
                let results = try JSONDecoder().decode(U.self, from: response.data)
                return .success(results)
            } catch {
                print(error)
                return .failure(handleErrorCodes(0))
            }
        case let .failure(error):
            moyaError = error
            do {
//                if !NetworkManager.shared.isConnected {
//                    return .failure(handleNoInternetError())
//                }
                if let data = error.response?.data, let JSONString = String(data: data, encoding: String.Encoding.utf8) {
                    print(JSONString)
                    let result = try JSONDecoder().decode(ErrorResponse.self, from: data)
//                    if result.responseCode == 15 {
//                        MiddleModal.show(title: "Session Timeout", type: .error, dismissable: false, onConfirm: { UserSession.shared.performLogout()} )
//                    } else {
                        return .failure(result)
//                    }
                }
            } catch {
                print(error)

            }
            return .failure(handleErrorCodes(0))
        }
    }
    
    func getData<V: Codable>(result: Result<V, ErrorResponse>) -> Data {
        switch result {
        case .success(let response):
            do {
                let jsonData = try JSONEncoder().encode(response)
                let jsonString = String(data: jsonData, encoding: .utf8)
                return jsonString?.data(using: String.Encoding.utf8) ?? Data()
            } catch {
                print(error)
            }
        case .failure(let error):
            print(error)
        }
        return Data()
    }
    
    func handleError(_ error: MoyaError) -> ErrorResponse {
        switch error {
        case .underlying(let (_, moyaError)):
            return handleErrorCodes(moyaError?.statusCode ?? 0)
        case .statusCode(let error):
            return handleErrorCodes(error.statusCode)
        default:
            return ErrorResponse(message: "Something went wrong", status: false)
        }
    }
    
    func handleErrorCodes(_ code: Int) -> ErrorResponse {
        switch code {
         case 401:
            return ErrorResponse(message: "Unauthorized Access", status: false)
        case 408:
            return ErrorResponse(message: "Request timeout", status: false)
        default:
            return ErrorResponse(message: "Something went wrong", status: false)
        }
    }
    
    func handleNoInternetError() -> ErrorResponse {
        ErrorResponse(message: "Looks like the server is unreachable. You may need to check your network and try again.", status: false)
    }
}


