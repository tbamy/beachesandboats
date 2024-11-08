//
//  ChefDishesViewModel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation
import RxSwift

class ChefDishesViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService = ListingServiceImplementation()
    var output = PublishSubject<Output>()
    
    enum Output {
        case getChefDishesSuccess(ChefDishesResponse)
        case getChefDishesError(ErrorResponse)
    }
    
    func getChefDishes() {
        listingService.chefDishes(completion: { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getChefDishesSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getChefDishesError(error))
            }
        })
    }
}
