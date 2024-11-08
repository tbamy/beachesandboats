//
//  ListServiceViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 05/11/2024.
//

import Foundation
import RxSwift


class ListServiceViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService = ListingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Output {
        case listServiceSuccessful(GeneralResponse)
        case listServiceFailed(ErrorResponse)
    }
    
    func createService(_ request: CreateServiceListingRequest) {
        listingService.ListService(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.listServiceSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.listServiceFailed(error))
            }
        })
    }
}
