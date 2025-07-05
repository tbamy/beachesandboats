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
    case getUserBookings
    case getSavedFavourites
    case updateNotificationSettings(NotificationSettingsRequest)
    case getCustomerSupportInfo
    case updateProfile(UpdateProfileRequest)
    case changePassword(ChangePasswordRequest)
    
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
        case .getUserBookings:
            return Urls.getUserBookings.rawValue
        case .getSavedFavourites:
            return Urls.getSavedFavourites.rawValue
        case .updateNotificationSettings(_):
            return Urls.updateNotificationSettings.rawValue
        case .getCustomerSupportInfo:
            return Urls.customerSupport.rawValue
        case .updateProfile(_):
            return Urls.updateProfile.rawValue
        case .changePassword(_):
            return Urls.changePassword.rawValue
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
        case .getUserBookings:
            return .get
        case .getSavedFavourites:
            return .get
        case .updateNotificationSettings(_):
            return .post
        case .getCustomerSupportInfo:
            return .get
        case .updateProfile(_):
            return .post
        case .changePassword(_):
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
            let fields: [String: Any] = [
                "first_name": data.first_name,
                "last_name": data.last_name,
                "middle_name": data.middle_name,
                "email": data.email,
                "phone_number": data.phone_number
//                "id_document":
//                "second_document":
            ]
            
            for (key, value) in fields {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }
            
//            Append id document
            if let idDocumentData = data.id_document {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(idDocumentData),
                        name: "id_document",
                        fileName: "id_document_\(data.first_name).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
//            Append second document
            if let secondDocumentData = data.second_document {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(secondDocumentData),
                        name: "second_document",
                        fileName: "second_document_\(data.first_name).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            
            return .uploadMultipart(multipartData)
            
        case .getUserBookings:
            return .requestPlain
        case .getSavedFavourites:
            return .requestPlain
        case .updateNotificationSettings(let request):
            return .requestJSONEncodable(request)
        case .getCustomerSupportInfo:
            return .requestPlain
        case .updateProfile(let request):
            return .requestJSONEncodable(request)
        case .changePassword(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    
}
