//
//  BeachHouseVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 10/07/2025.
//

import Foundation
import RxSwift

class BeachHouseVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getBeachHouse(id: String)
    }
    
    enum Output {
        case getBeachHouseSuccess(GetBeachResponse)
        case getBeachHouseFailed(ErrorResponse)
    }
    
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBeachHouse(let id):
                self?.getBeachHouse(id: id)
            }
        }).disposed(by: disposeBag)
    }
    
    func getBeachHouse(id: String) {
        bookingService.getBeachHouse(id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBeachHouseSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBeachHouseFailed(error))
            }
        })
    }
}
