//
//  EditBoatVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/04/2025.
//

import Foundation
import RxSwift


class EditBoatViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case editBoatSuccessful(GeneralResponse)
        case editBoatFailed(ErrorResponse)
    }
    
    func editBoat(_ request: CreateBoatListingRequest, id: String) {
        listingService.EditBoat(request: request, id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.editBoatSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.editBoatFailed(error))
            }
        })
    }
}
