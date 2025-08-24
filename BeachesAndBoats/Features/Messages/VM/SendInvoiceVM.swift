//
//  SendInvoiceVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/07/2025.
//

import RxSwift

class SendInvoiceVM {
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    let output = PublishSubject<Output>()
    
    enum Input {
        case createInvoice(CreateInvoiceRequest)
    }
    
    enum Output {
        
        case createInvoiceSuccess(CreateInvoiceResponse)
        case createInvoiceFailed(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>) {
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .createInvoice(let request):
                self?.createInvoice(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    
    func createInvoice(request: CreateInvoiceRequest) {
        bookingService.bookServiceProvider(request: request, completion:  { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.createInvoiceSuccess(response))
            case .failure(let error):
                self?.output.onNext(.createInvoiceFailed(error))
            }
        })
    }
    
}
