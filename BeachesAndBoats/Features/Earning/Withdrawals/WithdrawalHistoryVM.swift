//
//  WithdrawalHistoryVM.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 02/01/2025.
//

import Foundation
import RxSwift

class WithdrawalHistoryVM {
    
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case withdrawalHistory
    }
    
    enum Output {
        case withdrawalHistorySuccess(WithdrawalResponse)
        case withdrawalHistoryFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .withdrawalHistory:
                self?.getWithdrawalHistory()
            }
        }).disposed(by: dispose)
    }
    
    func getWithdrawalHistory() {
        hostingService.getWithdrawalHistory(completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleWithdrawalHistorySuccess(response)
            case .failure(let error):
                self?.handleWithdrawalHistoryFailure(error)
            }})
    }
    
    func handleWithdrawalHistorySuccess(_ response: WithdrawalResponse) {
        output.onNext(.withdrawalHistorySuccess(response))
    }
    
    func handleWithdrawalHistoryFailure(_ error: ErrorResponse) {
        output.onNext(.withdrawalHistoryFailure(error))
    }
    
    func useMockData() {
        output.onNext(.withdrawalHistorySuccess(WithdrawalResponse.mockData))
    }
}

