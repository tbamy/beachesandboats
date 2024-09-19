//
//  ConfirmAccountViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/09/2024.
//

import Foundation
import RxSwift

class ConfirmAccountViewModel{
    var disposeBag = DisposeBag()
    let onboardingService: OnboardingService = OnboardingServiceImplementation()
    var output = PublishSubject<Output>()
    
    
    enum Output {
        case confirmAccountSuccess(GeneralResponse)
        case confirmAccountError(ErrorResponse)
        
        case verifyCodeSuccess(GeneralResponse)
        case verifyCodeError(ErrorResponse)
        
        case signUpSuccess(SignUpResponse)
        case signUpError(ErrorResponse)
    }
    
    func confirmAccount(request: ConfirmAccountRequest) {
        onboardingService.confirmAccount(request: request, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.confirmAccountSuccess(response))
            case .failure(let error):
                self?.output.onNext(.confirmAccountError(error))
            }
        })
    }
    
    func verifyCode(request: VerifyCodeRequest) {
        onboardingService.verifyCode(request: request, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.verifyCodeSuccess(response))
            case .failure(let error):
                self?.output.onNext(.verifyCodeError(error))
            }
        })
    }
    
    func signUp(profileRequest: SignUpRequest) {
        onboardingService.signUp(request: profileRequest, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.signUpSuccess(response))
            case .failure(let error):
                self?.output.onNext(.signUpError(error))
            }
        })
    }
    
}
