//
//  ForgotPasswordVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation
import RxSwift

class ForgotPasswordVM{
    private let disposeBag = DisposeBag()
    private let onboardingService: OnboardingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case forgotPassword(ForgotPasswordRequest)
    }
    
    enum Output {
        case forgotPasswordSuccess(GeneralResponse)
        case forgotPasswordFailed(ErrorResponse)
    }
    
    init(onboardingService: OnboardingService = OnboardingServiceImplementation()) {
        self.onboardingService = onboardingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .forgotPassword(let request):
                self?.forgotPassword(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func forgotPassword(request: ForgotPasswordRequest) {
        onboardingService.forgotPassword(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.forgotPasswordSuccess(response))
            case .failure(let error):
                self?.output.onNext(.forgotPasswordFailed(error))
            }
        })
    }

}
