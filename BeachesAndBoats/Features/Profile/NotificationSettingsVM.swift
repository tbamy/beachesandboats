//
//  NotificationSettingsVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/02/2025.
//

import Foundation
import RxSwift

class NotificationSettingsVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case updateNotificationSettings(NotificationSettingsRequest)
    }
    
    enum Output {
        case updateNotificationSettingsSuccess(GeneralResponse)
        case updateNotificationSettingsFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .updateNotificationSettings(let request):
                self?.updateNotificationSettings(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func updateNotificationSettings(request: NotificationSettingsRequest) {
        profileService.updateNotificationSettings(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.updateNotificationSettingsSuccess(response))
            case .failure(let error):
                self?.output.onNext(.updateNotificationSettingsFailed(error))
            }
        })
    }

}

