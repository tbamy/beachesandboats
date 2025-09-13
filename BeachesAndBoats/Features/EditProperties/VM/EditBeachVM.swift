//
//  EditBeachVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/04/2025.
//

import Foundation
import RxSwift


class EditBeachViewModel{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    var deleteRoomOutput = PublishSubject<DeleteRoomOutput>()
    var deleteBeachOutput = PublishSubject<DeleteBeachOutput>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case editBeachSuccessful(GeneralResponse)
        case editBeachFailed(ErrorResponse)
    }
    
    enum DeleteRoomOutput {
        case deleteBeachRoomSuccessful(GeneralResponse)
        case deleteBeachRoomFailed(ErrorResponse)
    }
    
    enum DeleteBeachOutput {
        case deleteBeachSuccessful(GeneralResponse)
        case deleteBeachFailed(ErrorResponse)
    }
    
    func editBeach(_ request: CreateBeachListingRequest, id: String) {
        listingService.EditBeach(request: request, id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.editBeachSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.editBeachFailed(error))
            }
        })
    }
    
    func deleteBeachRoom(id: String) {
        listingService.deleteBeachRoom(id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.deleteRoomOutput.onNext(.deleteBeachRoomSuccessful(response))
            case .failure(let error):
                self?.deleteRoomOutput.onNext(.deleteBeachRoomFailed(error))
            }
        })
    }
    
    func deleteBeach(id: String) {
        listingService.deleteBeach(id: id, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.deleteBeachOutput.onNext(.deleteBeachSuccessful(response))
            case .failure(let error):
                self?.deleteBeachOutput.onNext(.deleteBeachFailed(error))
            }
        })
    }
}
