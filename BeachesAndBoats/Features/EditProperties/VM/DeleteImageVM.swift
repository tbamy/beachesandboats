//
//  DeleteImageVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/09/2025.
//

import Foundation
import RxSwift


class DeleteImageVM{
    var disposeBag = DisposeBag()
    let listingService: ListingService
    var output = PublishSubject<Output>()
    var lastDeletedImageUrl: String?
    
    init(listingService: ListingService = ListingServiceImplementation()) {
        self.listingService = listingService
    }
    
    enum Output {
        case deleteImageSuccessful(GeneralResponse)
        case deleteImageFailed(ErrorResponse)
    }
    
    func deleteImage(request: DeleteImagesRequest) {
        listingService.deleteImages(request: request, completion:  { [ weak self ] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.deleteImageSuccessful(response))
            case .failure(let error):
                self?.output.onNext(.deleteImageFailed(error))
            }
        })
    }
}
