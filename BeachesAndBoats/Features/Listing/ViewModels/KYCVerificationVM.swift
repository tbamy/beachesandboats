//
//  KYCVerificationVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation
import RxSwift

class KYCVerificationVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case kycVerification(SendKYCRequest)
    }
    
    enum Output {
        case kycVerificationSuccess(GeneralResponse)
        case kycVerificationFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .kycVerification(let request):
                self?.kycVerification(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func kycVerification(request: SendKYCRequest) {
        profileService.sendKYC(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.kycVerificationSuccess(response))
            case .failure(let error):
                self?.output.onNext(.kycVerificationFailed(error))
            }
        })
    }

}


