//
//  ProfileTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 15/10/2024.
//

import Foundation
import Moya

enum ProfileTarget{
//    case Enable2FAEmail
//    case Enable2FAPhone
//    case Verify2FA(VerifyCodeRequest)
//    case RequestCode2FA
    case GetDashboardUser
    case sendKYC(SendKYCRequest)
    
}

extension ProfileTarget: BaseTarget{
    var path: String {
        switch self {
//        case .Enable2FAEmail:
//            return Urls.enable2FAEmail.rawValue
//        case .Enable2FAPhone:
//            return Urls.enable2FAPhone.rawValue
//        case .RequestCode2FA:
//            return Urls.requestCode2FA.rawValue
//        case .Verify2FA:
//            return Urls.verify2FA.rawValue
        case .GetDashboardUser:
            return Urls.getDashboardUser.rawValue
        case .sendKYC:
            return Urls.sendKYC.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .Enable2FAEmail, .Enable2FAPhone, .RequestCode2FA, .Verify2FA:
//            return .post
        case .GetDashboardUser:
            return .get
        case .sendKYC:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
//        case .Enable2FAEmail:
//            return .requestPlain
//        case .Enable2FAPhone:
//            return .requestPlain
//        case .RequestCode2FA:
//            return .requestPlain
//        case .Verify2FA(let request):
//            return .requestJSONEncodable(request)
        case .GetDashboardUser:
            return .requestPlain
        case .sendKYC(let data):
            var multipartData: [MultipartFormData] = []

            // Append standard fields as form data
//            let fields: [String: Any] = [
//                "role_type": data.roleType,
//                "name": data.name,
//                "description": data.description,
//                "category_id": data.categoryId,
//                "available_from": data.availableFrom,
//                "available_to": data.availableTo,
//                "starting_price": data.startingPrice
//            ]
//            
//            for (key, value) in fields {
//                if let stringValue = String(describing: value).data(using: .utf8) {
//                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
//                }
//            }

            
            //Append profile picture
            
//            if let profilePictureData = data.profilePic {
//                multipartData.append(
//                    MultipartFormData(
//                        provider: .data(profilePictureData),
//                        name: "profile_pic",
//                        fileName: "profile_picture.jpg",
//                        mimeType: "image/jpeg"
//                    )
//                )
//            }
                    

            return .uploadMultipart(multipartData)
        }
    }
    
    
}
