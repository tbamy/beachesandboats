//
//  EditBeachVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/04/2025.
//

import Foundation
import RxSwift


class EditBeachViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case editBeachSuccessful(GeneralResponse)
        case editBeachFailed(ErrorResponse)
    }
    
    func createBeach(_ request: CreateBeachListingRequest) {
        listingService.EditBeach(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.editBeachSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.editBeachFailed(error))
            }
        })
    }
}
