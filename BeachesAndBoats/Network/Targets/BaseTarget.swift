//
//  BaseTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import Moya
import Foundation

protocol BaseTarget: TargetType, AccessTokenAuthorizable {}

extension TargetType {
    public var baseURL: URL {
        return Configuration.baseURL
    }
    
    public var headers: [String : String]? {
        Configuration.headers
    }
    
    public var validationType: ValidationType {
       return .successCodes
    }
}

extension AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? {
        return .bearer
    }
}
