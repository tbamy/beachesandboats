//
//  SavedFavouritesVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation
import RxSwift

class SavedFavouritesVM {
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getSavedFavourites
        case addFavourite(AddFavouriteRequest)
    }
    
    enum Output {
        case getSavedFavouritesSuccess(GetSavedFavouritesResponse)
        case getSavedFavouritesFailed(ErrorResponse)
        
        case addFavouriteSuccess(GeneralResponse)
        case addFavouriteFailed(ErrorResponse)
    }
    
    // ✅ Single initializer initializing both services
    init(
        profileService: ProfileService = ProfileServiceImplementation(),
        bookingService: BookingService = BookingServiceImplementation()
    ) {
        self.profileService = profileService
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getSavedFavourites:
                self?.getSavedFavourites()
            case .addFavourite(let request):
                self?.addFavourite(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    private func getSavedFavourites() {
        profileService.getSavedFavourites { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getSavedFavouritesSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getSavedFavouritesFailed(error))
            }
        }
    }
    
    private func addFavourite(request: AddFavouriteRequest) {
        bookingService.addOrUpdateFavourite(request: request) { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.addFavouriteSuccess(response))
            case .failure(let error):
                self?.output.onNext(.addFavouriteFailed(error))
            }
        }
    }
}
