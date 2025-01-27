//
//  ListingDashboardVM.swift
//  BeachesAndBoats
//
//  Created by WEMA on 08/01/2025.
//

import Foundation
import RxSwift

class ListingDashboardVM {
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case beachHouseReservation
        case boatReservation
    }
    
    enum Output {
        case beachHouseReservationSuccess(BeachHouseReservations)
        case beachHouseReservationFailure(ErrorResponse)
        case boatReservationSuccess(BoatReservations)
        case boatReservationFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .beachHouseReservation:
                self?.getBeachHouseReservation()
            case .boatReservation:
                self?.getBoatHouseReservation()
            }
        }).disposed(by: dispose)
    }
    
    func getBoatHouseReservation() {
        hostingService.boatReservation(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleBoatSuccess(response)
            case .failure(let error):
                self?.handleBoatFailure(error)
            }})
    }
    
    func getBeachHouseReservation() {
        hostingService.beachHouseReservation(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleBeachHouseSuccess(response)
            case .failure(let error):
                self?.handleBeachHouseFailure(error)
            }})
    }
    
    func handleBoatSuccess(_ response: BoatReservations) {
        output.onNext(.boatReservationSuccess(response))
    }
    
    func handleBoatFailure(_ error: ErrorResponse) {
        output.onNext(.boatReservationFailure(error))
    }
    
    func handleBeachHouseSuccess(_ response: BeachHouseReservations) {
        output.onNext(.beachHouseReservationSuccess(response))
    }
    
    func handleBeachHouseFailure(_ error: ErrorResponse) {
        output.onNext(.beachHouseReservationFailure(error))
    }
}
