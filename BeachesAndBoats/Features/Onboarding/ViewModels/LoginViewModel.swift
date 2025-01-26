//
//  LoginViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import Foundation
import RxSwift

class LoginViewModel{
    var disposeBag = DisposeBag()
    let onboardingService: OnboardingService = OnboardingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Output {
        case loginSuccess(LoginResponse)
        case loginError(ErrorResponse)
        
        case verifyOtpSuccess(LoginResponse)
        case verifyOtpError(ErrorResponse)
        
//        case confirmAccountSuccess(GeneralResponse)
//        case confirmAccountError(ErrorResponse)
        
    }
    
    func login(request: LoginRequest) {
        onboardingService.login(request: request, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.loginSuccess(response))
                let token = response.data?.access_token
                UserSession.shared.startSession = true
            case .failure(let error):
                self?.output.onNext(.loginError(error))
            }
        })
    }
    
//    func confirmAccount(request: ConfirmAccountRequest) {
//        onboardingService.confirmAccount(request: request, completion: { [ weak self ] data in
//            switch data {
//            case .success(let response):
//                self?.output.onNext(.confirmAccountSuccess(response))
//            case .failure(let error):
//                self?.output.onNext(.confirmAccountError(error))
//            }
//        })
//    }
    
    func verifyOtp(request: VerifyLoginOtpRequest) {
        onboardingService.verifyLoginOtp(request: request, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.verifyOtpSuccess(response))
            case .failure(let error):
                self?.output.onNext(.verifyOtpError(error))
            }
        })
    }

}
