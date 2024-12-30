//
//  HomeViewVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation
import RxSwift

class HomeViewVM{
    var disposeBag = DisposeBag()
    let bookingService: BookingService = BookingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Input {
        case getBookingCategories(page: String)
    }
    
    enum Output {
        case getBookingCategoriesSuccess(GetBookingCategoryResponse)
        case getBookingCategoriesFailed(ErrorResponse)
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBookingCategories(let page):
                self?.getBookingCategories(page: page)
            }
        }).disposed(by: disposeBag)
    }
    
    func getBookingCategories(page: String) {
        bookingService.getBookingCategories(page: page, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBookingCategoriesSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBookingCategoriesFailed(error))
            }
        })
    }
}
