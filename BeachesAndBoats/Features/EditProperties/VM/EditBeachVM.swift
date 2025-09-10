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
    var deleteOutput = PublishSubject<DeleteOutput>()
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case editBeachSuccessful(GeneralResponse)
        case editBeachFailed(ErrorResponse)
    }
    
    enum DeleteOutput {
        case deleteBeachRoomSuccessful(GeneralResponse)
        case deleteBeachRoomFailed(ErrorResponse)
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
                self?.deleteOutput.onNext(.deleteBeachRoomSuccessful(response))
            case .failure(let error):
                self?.deleteOutput.onNext(.deleteBeachRoomFailed(error))
            }
        })
    }
}
