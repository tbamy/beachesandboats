//
//  PaymentCallbackVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/03/2025.
//

import Foundation
import RxSwift

class PaymentCallbackVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case paymentCallback(reference: String)
    }
    
    enum Output {
        case paymentCallbackSuccess(GeneralResponse)
        case paymentCallbackFailed(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .paymentCallback(let reference):
                self?.paymentCallback(reference: reference)
            }
        }).disposed(by: disposeBag)
    }
    
    func paymentCallback(reference: String) {
        bookingService.paymentCallback(reference: reference, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.paymentCallbackSuccess(response))
            case .failure(let error):
                self?.output.onNext(.paymentCallbackFailed(error))
            }
        })
    }

}


