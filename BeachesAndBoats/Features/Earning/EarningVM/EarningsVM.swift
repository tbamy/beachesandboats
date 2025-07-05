//
//  EarningsVM.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import Foundation
import RxSwift

class EarningsVM {
    
    var dispose = DisposeBag()
    var hostingService: HostingService = HostingServiceImplementation()
    
    enum Input {
        case topEarnings(TopEarningRequest)
    }
    
    enum Output {
        case topEarningsSuccess(TopEarningResponse)
        case topEarningsFailure(ErrorResponse)
    }
    
    var output = PublishSubject<Output>()
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .topEarnings(let request):
                self?.getTopEarning(request)
            }
        }).disposed(by: dispose)
    }
    
    func getTopEarning(_ request: TopEarningRequest) {
        hostingService.getTopEarnings(request: request, completion: {[weak self] result in
            switch result {
            case .success(let response):
                self?.handleTopEarningSuccess(response)
            case .failure(let error):
                self?.handleTopEarningFailure(error)
            }})
    }
    
    func handleTopEarningSuccess(_ response: TopEarningResponse) {
        output.onNext(.topEarningsSuccess(response))
    }
    
    func handleTopEarningFailure(_ error: ErrorResponse) {
        output.onNext(.topEarningsFailure(error))
    }
}
