//
//  BoatDataViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import Foundation
import RxSwift

class BoatDataViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService = ListingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Output {
        case getBoatDataSuccess(BoatDataResponse)
        case getBoatDataError(ErrorResponse)
    }
    
    func getBoatData() {
        listingService.BoatData(completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBoatDataSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBoatDataError(error))
            }
        })
    }
}
