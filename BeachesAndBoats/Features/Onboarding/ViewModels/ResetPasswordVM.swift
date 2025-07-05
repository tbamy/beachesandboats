//
//  ResetPasswordVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/02/2025.
//

import Foundation
import RxSwift

class ResetPasswordVM{
    private let disposeBag = DisposeBag()
    private let onboardingService: OnboardingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case resetPassword(ResetPasswordRequest)
    }
    
    enum Output {
        case resetPasswordSuccess(GeneralResponse)
        case resetPasswordFailed(ErrorResponse)
    }
    
    init(onboardingService: OnboardingService = OnboardingServiceImplementation()) {
        self.onboardingService = onboardingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .resetPassword(let request):
                self?.resetPassword(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func resetPassword(request: ResetPasswordRequest) {
        onboardingService.resetPassword(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.resetPasswordSuccess(response))
            case .failure(let error):
                self?.output.onNext(.resetPasswordFailed(error))
            }
        })
    }

}


