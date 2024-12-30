//
//  OnboardingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation
import Moya

class OnboardingServiceImplementation: Provider<OnboardingTarget>, OnboardingService{
    func verifyLoginOtp(request: VerifyLoginOtpRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        provider.request(.VerifyLoginOtp(request)){ completion( self.handleResult(result: $0)) }
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        provider.request(.Login(request)){ completion( self.handleResult(result: $0)) }
    }
    
    func confirmAccount(request: ConfirmAccountRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.ConfirmAccount(request)){ completion( self.handleResult(result: $0)) }
    }
    
    func verifyCode(request: VerifyCodeRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.VerifyCode(request)){ completion( self.handleResult(result: $0)) }
    }
    
    func signUp(request: SignUpRequest, completion: @escaping (Result<LoginResponse, ErrorResponse>) -> Void) {
        provider.request(.SignUp(request)){ completion( self.handleResult(result: $0)) }
    }
    
    func refreshToken(request: RefreshTokenRequest, completion: @escaping (Result<RefreshTokenResponse, ErrorResponse>) -> Void) {
        provider.request(.RefreshToken(request)){ completion( self.handleResult(result: $0)) }
    }
    
    
}
