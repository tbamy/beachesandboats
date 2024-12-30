//
//  BookingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

class BookingServiceImplementation: Provider<BookingTarget>, BookingService{
    func getBookingCategories(page: String, completion: @escaping (Result<GetBookingCategoryResponse, ErrorResponse>) -> Void) {
        provider.request(.GetBookingCategories(page: page)){ completion( self.handleResult(result: $0))}
    }
    
    
}
