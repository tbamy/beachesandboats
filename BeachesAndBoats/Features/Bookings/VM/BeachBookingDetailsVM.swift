//
//  BeachBookingDetailsVM.swift
//  BeachesAndBoats
//
//  Created by WEMA on 03/07/2025.
//

import Foundation
import RxSwift

class BeachBookingDetailsVM {
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case addReview(AddReviewRequest)
    }
    
    enum Output {
        case addReviewSuccess(GeneralResponse)
        case addReviewFailure(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .addReview(let request):
                self?.saveReview(request)
            }
        }).disposed(by: disposeBag)
    }
    
    func saveReview(_ request: AddReviewRequest) {
        bookingService.addOrUpdateReview(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.addReviewSuccess(response))
            case .failure(let error):
                self?.output.onNext(.addReviewFailure(error))
            }
        })
    }

}
