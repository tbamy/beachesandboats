//
//  FindServiceProviderVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/02/2025.
//

import Foundation
import RxSwift

class FindServiceProviderVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    
    let bouncerOutput = PublishSubject<BouncerOutput>()
    let chefOutput = PublishSubject<ChefOutput>()
    let djOutput = PublishSubject<DjOutput>()
    
    enum Input{
        case findBouncer(String)
        case findChef(String)
        case findDj
        case getAllDishes
    }
    
    enum BouncerOutput{
        case findBouncerSuccessful(FindServiceProviderResponse)
        case findBouncerFailed(ErrorResponse)
        
    }
    
    enum ChefOutput{
        case findChefSuccessful(FindServiceProviderResponse)
        case findChefFailed(ErrorResponse)
        
        case getAllDishesSuccessful(GetAllDishesResponse)
        case getAllDishesFailed(ErrorResponse)
    }
    
    enum DjOutput{
        
        case findDjSuccessful(FindServiceProviderResponse)
        case findDjFailed(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>){
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .findChef(let dishIds):
                self?.findChef(dishIds: dishIds)
            case .findBouncer(let gender):
                self?.findBouncer(gender: gender)
            case .findDj:
                self?.findDj()
            case .getAllDishes:
                self?.getAllDishes()
            }
        }).disposed(by: disposeBag)
    }
    
    
    func findBouncer(gender: String){
        bookingService.findBouncers(gender: gender, completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.bouncerOutput.onNext(.findBouncerSuccessful(response))
            case .failure(let error):
                self?.bouncerOutput.onNext(.findBouncerFailed(error))
            }
        })
    }
    
    func findChef(dishIds: String){
        bookingService.findChefByDishes(dishIds: dishIds, completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.chefOutput.onNext(.findChefSuccessful(response))
            case .failure(let error):
                self?.chefOutput.onNext(.findChefFailed(error))
            }
        })
    }
    
    func findDj(){
        bookingService.findDJ(completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.djOutput.onNext(.findDjSuccessful(response))
            case .failure(let error):
                self?.djOutput.onNext(.findDjFailed(error))
            }
        })
    }
    
    func getAllDishes(){
        bookingService.getAllDishes(completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.chefOutput.onNext(.getAllDishesSuccessful(response))
            case .failure(let error):
                self?.chefOutput.onNext(.getAllDishesFailed(error))
            }
        })
    }
}
