//
//  MakeWithdrawVM.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import Foundation
import RxSwift

class MakeWithdrawVM {
    
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case makeWithdrawal(CreateWithdrawalRequest)
        case getBanks
    }
    
    enum Output {
        case makeWithdrawalSuccess(CreateWithdrawalResponse)
        case makeWithdrawalFailure(ErrorResponse)
        case getBanksSuccess(ListOfBanksResponse)
        case getBanksFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .makeWithdrawal(let request):
                self?.withdraw(request)
            case .getBanks:
                self?.getListOfBanks()
            }
        }).disposed(by: dispose)
    }
    
    func getListOfBanks() {
        hostingService.getBanks(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleBankSuccess(response)
            case .failure(let error):
                self?.handleBankFailure(error)
            }})
    }
    
    func withdraw(_ request: CreateWithdrawalRequest) {
        hostingService.makeWithdrawal(request: request, completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleWithdrawalSuccess(response)
            case .failure(let error):
                self?.handleWithdrawalFailure(error)
            }})
    }
    
    func handleBankSuccess(_ response: ListOfBanksResponse) {
        output.onNext(.getBanksSuccess(response))
    }
    
    func handleBankFailure(_ error: ErrorResponse) {
        output.onNext(.getBanksFailure(error))
    }
    
    func handleWithdrawalSuccess(_ response: CreateWithdrawalResponse) {
        output.onNext(.makeWithdrawalSuccess(response))
    }
    
    func handleWithdrawalFailure(_ error: ErrorResponse) {
        output.onNext(.makeWithdrawalFailure(error))
    }
}
