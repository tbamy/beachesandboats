//
//  TwoFASecurityVM.swift
//  BeachesAndBoats
//
//  Created by WEMA on 06/01/2025.
//

import Foundation
import RxSwift

class TwoFASecurityVM {
    
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case phoneSecurity(TwoFAPhoneSecurityRequest)
        case emailSecurity(TwoFAEmailSecurityRequest)
        case completeTwoFA(TwoFACompleteVerificationRequest)
    }
    
    enum Output {
        case phoneSecuritySuccess(TwoFASecurityResponse)
        case phoneSecurityFailure(ErrorResponse)
        case emailSecuritySuccess(TwoFASecurityResponse)
        case emailSecurityFailure(ErrorResponse)
        case completeTwoFASuccess(TwoFACompleteVerificationResponse)
        case completeTwoFAFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .emailSecurity(let request):
                self?.emailSecurity(request)
            case .phoneSecurity(let request):
                self?.phoneSecurity(request)
            case .completeTwoFA(let request):
                self?.getTwoFACompletion(request)
            }
        }).disposed(by: dispose)
    }
    
    func getTwoFACompletion(_ request: TwoFACompleteVerificationRequest) {
        hostingService.twoFACompleteVerification(request: request, completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleCompleteVerificationSuccess(response)
            case .failure(let error):
                self?.handleCompleteVerificationFailure(error)
            }})
    }
    
    func emailSecurity(_ request: TwoFAEmailSecurityRequest) {
        hostingService.getEmailSecurity(request: request, completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleEmailSecuritySuccess(response)
            case .failure(let error):
                self?.handleEmailSecurityFailure(error)
            }})
    }
    
    func phoneSecurity(_ request: TwoFAPhoneSecurityRequest) {
        hostingService.getPhoneSecurity(request: request, completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handlePhoneSecuritySuccess(response)
            case .failure(let error):
                self?.handlePhoneSecurityFailure(error)
            }})
    }
    
    func handleCompleteVerificationSuccess(_ response: TwoFACompleteVerificationResponse) {
        output.onNext(.completeTwoFASuccess(response))
    }
    
    func handleCompleteVerificationFailure(_ error: ErrorResponse) {
        output.onNext(.completeTwoFAFailure(error))
    }
    
    func handleEmailSecuritySuccess(_ response: TwoFASecurityResponse) {
        output.onNext(.emailSecuritySuccess(response))
    }
    
    func handleEmailSecurityFailure(_ error: ErrorResponse) {
        output.onNext(.emailSecurityFailure(error))
    }
    
    func handlePhoneSecuritySuccess(_ response: TwoFASecurityResponse) {
        output.onNext(.phoneSecuritySuccess(response))
    }
    
    func handlePhoneSecurityFailure(_ error: ErrorResponse) {
        output.onNext(.phoneSecurityFailure(error))
    }
}
