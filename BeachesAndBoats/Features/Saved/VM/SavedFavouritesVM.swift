//
//  SavedFavouritesVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/02/2025.
//

import Foundation
import RxSwift

class SavedFavouritesVM{
    private let disposeBag = DisposeBag()
    private let profileService: ProfileService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getSavedFavourites
    }
    
    enum Output {
        case getSavedFavouritesSuccess(GetSavedFavouritesResponse)
        case getSavedFavouritesFailed(ErrorResponse)
    }
    
    init(profileService: ProfileService = ProfileServiceImplementation()) {
        self.profileService = profileService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getSavedFavourites:
                self?.getSavedFavourites()
            }
        }).disposed(by: disposeBag)
    }
    
    func getSavedFavourites() {
        profileService.getSavedFavourites(completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getSavedFavouritesSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getSavedFavouritesFailed(error))
            }
        })
    }
}
