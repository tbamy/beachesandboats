//
//  ListBoatViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/11/2024.
//

import Foundation
import RxSwift


class ListBoatViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case listBoatSuccessful(GeneralResponse)
        case listBoatFailed(ErrorResponse)
    }
    
    func createBoat(_ request: CreateBoatListingRequest) {
        listingService.ListBoat(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.listBoatSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.listBoatFailed(error))
            }
        })
    }
}

