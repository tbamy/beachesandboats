//
//  ListBeachViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/01/2025.
//

import Foundation
import RxSwift


class ListBeachViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case listBeachSuccessful(GeneralResponse)
        case listBeachFailed(ErrorResponse)
    }
    
    func createBeach(_ request: CreateBeachListingRequest) {
        listingService.ListBeach(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.listBeachSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.listBeachFailed(error))
            }
        })
    }
}

