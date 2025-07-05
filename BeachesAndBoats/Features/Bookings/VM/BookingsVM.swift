//
//  BookingsVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation
import RxSwift

class BookingsVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getUserBookings
    }
    
    enum Output {
        case getUserBookingsSuccess(GetUserBookingsResponse)
        case getUserBookingsFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getUserBookings:
                self?.getUserBookings()
            }
        }).disposed(by: disposeBag)
    }
    
    func getUserBookings() {
        profileService.getUserBookings(completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getUserBookingsSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getUserBookingsFailed(error))
            }
        })
    }

}
