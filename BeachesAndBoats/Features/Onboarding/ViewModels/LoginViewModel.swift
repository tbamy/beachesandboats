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
    }
    
    func login(request: LoginRequest) {
        onboardingService.login(request: request, completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.loginSuccess(response))
            case .failure(let error):
                self?.output.onNext(.loginError(error))
            }
        })
    }

}
