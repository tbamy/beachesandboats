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
    let getUserOutput = PublishSubject<GetUserOutput>()
    
    enum Input {
        case updateProfile(UpdateProfileRequest)
        case getDashboardUser
    }
    
    enum Output {
        case updateProfileSuccess(UpdateProfileResponse)
        case updateProfileFailed(ErrorResponse)
    }
    
    enum GetUserOutput {
        case getDashboardUserSuccess(DashboardUserReponse)
        case getDashboardUserFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .updateProfile(let request):
                self?.updateProfile(request: request)
            case .getDashboardUser:
                self?.getDashboardUser()
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
    
    func getDashboardUser() {
        profileService.getDashboardUser(completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.getUserOutput.onNext(.getDashboardUserSuccess(response))
            case .failure(let error):
                self?.getUserOutput.onNext(.getDashboardUserFailed(error))
            }
        })
    }

}



