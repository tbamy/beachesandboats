//
//  BookingConfigurationVM.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 14/01/2025.
//
import Foundation
import RxSwift

class BookingConfigurationVM{
    private let disposeBag = DisposeBag()
    private let bookingService: BookingService
    
    let output = PublishSubject<Output>()
    let boatOutput = PublishSubject<BoatOutput>()
    
    enum Input{
        case getBookingConfiguration
        case createBeachHouseBooking(CreateBeachHouseBookingRequest)
        case createBoatBooking(CreateBoatBookingRequest)
    }
    
    enum Output{
        case getBookingConfigurationSuccess(BookingConfigurationResponse)
        case getBookingConfigurationFailed(ErrorResponse)
        
        case createBeachHouseBookingSuccess(BeachHouseBookingResponse)
        case createBeachHouseBookingFailed(ErrorResponse)
    }
    
    enum BoatOutput{
        case getBookingConfigurationSuccess(BookingConfigurationResponse)
        case getBookingConfigurationFailed(ErrorResponse)
        
        case createBoatBookingSuccess(BoatBookingResponse)
        case createBoatBookingFailed(ErrorResponse)
    }
    
    init(bookingService: BookingService = BookingServiceImplementation()) {
        self.bookingService = bookingService
    }
    
    func transform(input: PublishSubject<Input>){
        input.subscribe(onNext: { [weak self] event in
            switch event {
            case .getBookingConfiguration:
                self?.getBookingConfiguration()
            case .createBeachHouseBooking(let request):
                self?.createBeachHouseBooking(request: request)
            case .createBoatBooking(let request):
                self?.createBoatBooking(request: request)
            }
        }).disposed(by: disposeBag)
    }
    
    
    func getBookingConfiguration(){
        bookingService.bookingConfiguration(completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.getBookingConfigurationSuccess(response))
                self?.boatOutput.onNext(.getBookingConfigurationSuccess(response))
            case .failure(let error):
                self?.output.onNext(.getBookingConfigurationFailed(error))
                self?.boatOutput.onNext(.getBookingConfigurationFailed(error))
            }
        })
    }
    
    func createBeachHouseBooking(request: CreateBeachHouseBookingRequest){
        bookingService.createBeachHouseBooking(request: request, completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.output.onNext(.createBeachHouseBookingSuccess(response))
            case .failure(let error):
                self?.output.onNext(.createBeachHouseBookingFailed(error))
            }
        })
    }
    
    func createBoatBooking(request: CreateBoatBookingRequest){
        bookingService.createBoatBooking(request: request, completion: { [weak self] data in
            switch data {
            case .success(let response):
                self?.boatOutput.onNext(.createBoatBookingSuccess(response))
            case .failure(let error):
                self?.boatOutput.onNext(.createBoatBookingFailed(error))
            }
        })
    }
}
