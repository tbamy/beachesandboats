//
//  HomeViewVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation
import RxSwift

class HomeViewVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case getBookingCategories(filter: GetBookingCategorySearchRequest)
        case addFavourite(AddFavouriteRequest)
    }
    
    enum Output {
        case getBookingCategoriesSuccess(GetBookingCategoryResponse)
        case getBookingCategoriesFailed(ErrorResponse)
        
        case addFavouriteSuccess(GeneralResponse)
        case addFavouriteFailed(ErrorResponse)
    }
    
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBookingCategories(let filter):
                self?.getBookingCategories(filter: filter)
            case .addFavourite(let request):
                self?.AddFavourite(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    func getBookingCategories(filter: GetBookingCategorySearchRequest) {
        bookingService.getBookingCategories(filter: filter, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBookingCategoriesSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBookingCategoriesFailed(error))
            }
        })
    }
    
    func AddFavourite(request: AddFavouriteRequest) {
        bookingService.addOrUpdateFavourite(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.addFavouriteSuccess(response))
            case .failure(let error):
                self?.output.onNext(.addFavouriteFailed(error))
            }
        })
    }
}
