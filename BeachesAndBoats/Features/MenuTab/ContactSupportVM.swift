//
//  ContactSupportVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation
import RxSwift

class ContactSupportVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getCustomerSupportInfo
    }
    
    enum Output {
        case getCustomerSupportInfoSuccess(CustomerSupportInfoResponse)
        case getCustomerSupportInfoFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getCustomerSupportInfo:
                self?.getCustomerSupportInfo()
            }
        }).disposed(by: disposeBag)
    }
    
    func getCustomerSupportInfo() {
        profileService.getCustomerSupportInfo(completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getCustomerSupportInfoSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getCustomerSupportInfoFailed(error))
            }
        })
    }

}




