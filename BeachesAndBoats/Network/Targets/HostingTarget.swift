//
//  HostingTarget.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 30/12/2024.
//

import Foundation
import Moya

enum HostingTarget{
    case GetHostBooking
    case TopEarnings(TopEarningRequest)
    case WithdrawHistory
    case MakeWithdrawal(CreateWithdrawalRequest)
    case getBanks
    case PhoneNumberSecurity(TwoFAPhoneSecurityRequest)
    case EmailSecurity(TwoFAEmailSecurityRequest)
    case TwoFACompleteVerification(TwoFACompleteVerificationRequest)
}

extension HostingTarget: BaseTarget{
    var path: String {
        switch self {
        case .GetHostBooking:
            return Urls.getUpcomingBooking.rawValue
        case .TopEarnings:
            return Urls.getTopEarnings.rawValue
        case .WithdrawHistory:
            return Urls.getWithdrawHistory.rawValue
        case .MakeWithdrawal:
            return Urls.makeWithdrawal.rawValue
        case .getBanks:
            return Urls.bankList.rawValue
        case .PhoneNumberSecurity:
            return Urls.twoFASecurity.rawValue
        case .EmailSecurity:
            return Urls.twoFASecurity.rawValue
        case .TwoFACompleteVerification:
            return Urls.twoFACompleteVerification.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .GetHostBooking, .TopEarnings, .WithdrawHistory, .getBanks:
            return .get
        case .MakeWithdrawal, .EmailSecurity, .PhoneNumberSecurity, .TwoFACompleteVerification:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .GetHostBooking:
            return .requestPlain
        case .TopEarnings(let request):
            let param = NetworkUtility.toParameter(request)
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .WithdrawHistory:
            return .requestPlain
        case .MakeWithdrawal(let request):
            return .requestJSONEncodable(request)
        case .getBanks:
            return .requestPlain
        case .PhoneNumberSecurity(let request):
            return .requestJSONEncodable(request)
        case .EmailSecurity(let request):
            return .requestJSONEncodable(request)
        case .TwoFACompleteVerification(let request):
            return .requestJSONEncodable(request)
        }
    }
}
