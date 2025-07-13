//
//  BoatVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 10/07/2025.
//

import Foundation
import RxSwift

class BoatVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getBoat(id: String)
    }
    
    enum Output {
        case getBoatSuccess(GetBoatResponse)
        case getBoatFailed(ErrorResponse)
    }
    
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBoat(let id):
                self?.getBoat(id: id)
            }
        }).disposed(by: disposeBag)
    }
    
    func getBoat(id: String) {
        bookingService.getBoat(id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBoatSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBoatFailed(error))
            }
        })
    }
}
