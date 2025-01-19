//
//  BookingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

class BookingServiceImplementation: Provider<BookingTarget>, BookingService{
    func createBeachHouseBooking(request: CreateBeachHouseBookingRequest, completion: @escaping (Result<BeachHouseBookingResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBeachHouseBooking(request)){ completion( self.handleResult(result: $0))}
    }
    
    func bookingConfiguration(completion: @escaping (Result<BookingConfigurationResponse, ErrorResponse>) -> Void) {
        provider.request(.BookingConfiguration){ completion( self.handleResult(result: $0))}
    }
    
    func getBookingCategories(page: String, completion: @escaping (Result<GetBookingCategoryResponse, ErrorResponse>) -> Void) {
        provider.request(.GetBookingCategories(page: page)){ completion( self.handleResult(result: $0))}
    }
    
    
}
