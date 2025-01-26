//
//  HostListingVM.swift
//  BeachesAndBoats
//
//  Created by WEMA on 11/01/2025.
//

import Foundation
import RxSwift

class HostListingVM {
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case beachHouseListing
//        case boatListing
    }
    
    enum Output {
        case beachHouseListingSuccess(BeachHouseListingResponse)
        case beachHouseListingFailure(ErrorResponse)
//        case boatListing(BeachHouseListingResponse)
//        case boatListing(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .beachHouseListing:
                self?.getBeachHouseListing()
//            case .boatReservation:
//                self?.getBoatHouseReservation()
            }
        }).disposed(by: dispose)
    }
    
    func getBeachHouseListing() {
        hostingService.beachHouseListing(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleBeachHouseListingSuccess(response)
            case .failure(let error):
                self?.handleBeachHouseListingFailure(error)
            }})
    }
    
//    func getBeachHouseReservation() {
//        hostingService.beachHouseReservation(completion: {[weak self] result in
//            switch result {
//            case .success(let response):
//                self?.handleBeachHouseSuccess(response)
//            case .failure(let error):
//                self?.handleBeachHouseFailure(error)
//            }})
//    }
    
    func handleBeachHouseListingSuccess(_ response: BeachHouseListingResponse) {
        output.onNext(.beachHouseListingSuccess(response))
    }
    
    func handleBeachHouseListingFailure(_ error: ErrorResponse) {
        output.onNext(.beachHouseListingFailure(error))
    }
}
