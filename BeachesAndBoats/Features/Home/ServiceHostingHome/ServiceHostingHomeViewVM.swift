//
//  ServiceHostingHomeViewVM.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 30/12/2024.
//


import Foundation
import RxSwift

class ServiceHostingHomeViewVM {
    
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case upcomingBooking
    }
    
    enum Output {
        case getUpcomingBookingSuccess(ServiceReservations)
        case getUpcomingBookingFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .upcomingBooking:
                self?.getUpcomingBooking()
            }
        }).disposed(by: dispose)
    }
    
    func getUpcomingBooking() {
        hostingService.getUpcomingBooking(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleUpcomingBookingSuccess(response)
            case .failure(let error):
                self?.handleUpcomingBookingFailure(error)
            }})
    }
    
    func handleUpcomingBookingSuccess(_ response: ServiceReservations) {
        output.onNext(.getUpcomingBookingSuccess(response))
    }
    
    func handleUpcomingBookingFailure(_ error: ErrorResponse) {
        output.onNext(.getUpcomingBookingFailure(error))
    }
}
