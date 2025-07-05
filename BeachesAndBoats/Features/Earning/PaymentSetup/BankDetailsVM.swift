//
//  BankDetailsVM.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/02/2025.
//

import Foundation
import RxSwift

class BankDetailsVM {
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case getBanks
    }
    
    enum Output {
        case getBanksSuccess(ListOfBanksResponse)
        case getBanksFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBanks:
                self?.getBanks()
            }
        }).disposed(by: dispose)
    }
    
    func getBanks() {
        hostingService.getBanks(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleBankSuccess(response)
            case .failure(let error):
                self?.handleBankFailure(error)
            }})
    }
    
    func handleBankSuccess(_ response: ListOfBanksResponse) {
        output.onNext(.getBanksSuccess(response))
    }
    
    func handleBankFailure(_ error: ErrorResponse) {
        output.onNext(.getBanksFailure(error))
    }
}
