//
//  OnboardingService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation

protocol OnboardingService{
    func signUp(request: SignUpRequest, completion: @escaping(Result<LoginResponse, ErrorResponse>) -> Void)
    func refreshToken(request: RefreshTokenRequest, completion: @escaping (Result<RefreshTokenResponse, ErrorResponse>) -> Void)
    func confirmAccount(request: ConfirmAccountRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    func verifyCode(request: VerifyCodeRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    func login(request: LoginRequest, completion: @escaping(Result<LoginResponse, ErrorResponse>) -> Void)
}
