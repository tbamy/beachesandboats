//
//  BeachDataViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation
import RxSwift

class BeachDataViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService = ListingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Output {
        case getBeachDataSuccess(BeachDataResponse)
        case getBeachDataError(ErrorResponse)
    }
    
    func getBeachData() {
        listingService.BeachData(completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBeachDataSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBeachDataError(error))
            }
        })
    }
}
