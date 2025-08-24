//
//  CancelBookingVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

import Foundation
import RxSwift

class CancelBookingVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    
    let output = PublishSubject<Output>()
    
    enum Input{
        case getBookingConfiguration
        case cancelBoking(CancelBookingRequest)
    }
    
    enum Output{
        case getBookingConfigurationSuccess(BookingConfigurationResponse)
        case getBookingConfigurationFailed(ErrorResponse)
        
        case cancelBookingSuccess(GeneralResponse)
        case cancelBookingFailed(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>){
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBookingConfiguration:
                self?.getBookingConfiguration()
            case .cancelBoking(let request):
                self?.cancelBoking(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    
    func getBookingConfiguration(){
        bookingService.bookingConfiguration(completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBookingConfigurationSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBookingConfigurationFailed(error))
            }
        })
    }
    
    func cancelBoking(request: CancelBookingRequest){
        bookingService.cancelBooking(request: request, completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.cancelBookingSuccess(response))
            case .failure(let error):
                self?.output.onNext(.cancelBookingFailed(error))
            }
        })
    }
}

