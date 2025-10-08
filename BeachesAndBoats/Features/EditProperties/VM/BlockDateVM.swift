//
//  BlockDateVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2025.
//

import Foundation
import RxSwift

class BlockDateVM {
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case addReservedDateSuccessful(AddReservedDateResponse)
        case addReservedDateFailed(ErrorResponse)
        
//        case removeReservedDateSuccessful(AddReservedDateResponse)
//        case removeReservedDateFailed(ErrorResponse)
        
        case getReservedDateSuccessful(AddReservedDateResponse)
        case getReservedDateFailed(ErrorResponse)
    }
    
    func addReservedDates(request: AddReservedDateRequest) {
        listingService.addReservedDates(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.addReservedDateSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.addReservedDateFailed(error))
            }
        })
    }

    
    func getReservedDates(request: GetReservedDatesRequest) {
        listingService.getReservedDates(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getReservedDateSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.getReservedDateFailed(error))
            }
        })
    }
}
