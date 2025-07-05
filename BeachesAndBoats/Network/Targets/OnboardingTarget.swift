//
//  OnboardingTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation
import Moya

enum OnboardingTarget{
    case SignUp(SignUpRequest)
    case RefreshToken(RefreshTokenRequest)
    case ConfirmAccount(ConfirmAccountRequest)
    case VerifyCode(VerifyCodeRequest)
    case Login(LoginRequest)
    case VerifyLoginOtp(VerifyLoginOtpRequest)
    case ForgotPassword(ForgotPasswordRequest)
    case ResetPassword(ResetPasswordRequest)
}

extension OnboardingTarget: BaseTarget{
    var path: String {
        switch self {
        case .RefreshToken:
            return Urls.refreshToken.rawValue
        case .SignUp:
            return Urls.register.rawValue
        case .ConfirmAccount:
            return Urls.confirmAccount.rawValue
        case .VerifyCode:
            return Urls.verifyCode.rawValue
        case .Login:
            return Urls.login.rawValue
        case .VerifyLoginOtp:
            return Urls.verifyLoginOtp.rawValue
        case .ForgotPassword(_):
            return Urls.forgotPassword.rawValue
        case .ResetPassword(_):
            return Urls.resetPassword.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .RefreshToken, .SignUp, .ConfirmAccount, .VerifyCode, .Login:
            return .post
        case .VerifyLoginOtp(_):
            return .post
        case .ForgotPassword(_):
            return .post
        case .ResetPassword(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .RefreshToken(let request):
            return .requestJSONEncodable(request)
        case .SignUp(let request):
            return .requestJSONEncodable(request)
        case .ConfirmAccount(let request):
            return .requestJSONEncodable(request)
        case .VerifyCode(let request):
            return .requestJSONEncodable(request)
        case .Login(let request):
            return .requestJSONEncodable(request)
        case .VerifyLoginOtp(let request):
            return .requestJSONEncodable(request)
        case .ForgotPassword(let request):
            return .requestJSONEncodable(request)
        case .ResetPassword(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    
}
