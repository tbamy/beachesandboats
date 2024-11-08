//
//  ProfileTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 15/10/2024.
//

import Foundation
import Moya

enum ProfileTarget{
    case Enable2FAEmail
    case Enable2FAPhone
    case Verify2FA(VerifyCodeRequest)
    case RequestCode2FA
}

extension ProfileTarget: BaseTarget{
    var path: String {
        switch self {
        case .Enable2FAEmail:
            return Urls.enable2FAEmail.rawValue
        case .Enable2FAPhone:
            return Urls.enable2FAPhone.rawValue
        case .RequestCode2FA:
            return Urls.requestCode2FA.rawValue
        case .Verify2FA:
            return Urls.verify2FA.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Enable2FAEmail, .Enable2FAPhone, .RequestCode2FA, .Verify2FA:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .Enable2FAEmail:
            return .requestPlain
        case .Enable2FAPhone:
            return .requestPlain
        case .RequestCode2FA:
            return .requestPlain
        case .Verify2FA(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    
}
