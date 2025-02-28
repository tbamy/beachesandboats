//
//  UpdateProfileVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/02/2025.
//

import Foundation
import RxSwift

class UpdateProfileVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case updateProfile(UpdateProfileRequest)
    }
    
    enum Output {
        case updateProfileSuccess(UpdateProfileResponse)
        case updateProfileFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .updateProfile(let request):
                self?.updateProfile(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func updateProfile(request: UpdateProfileRequest) {
        profileService.updateProfileRequest(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.updateProfileSuccess(response))
            case .failure(let error):
                self?.output.onNext(.updateProfileFailed(error))
            }
        })
    }

}



