//
//  BookingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

class BookingServiceImplementation: Provider<BookingTarget>, BookingService{
    func addOrUpdateReview(request: AddReviewRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.AddOrUpdateReview(request)){ completion( self.handleResult(result: $0))}
    }
    
    func createBoatBooking(request: CreateBoatBookingRequest, completion: @escaping (Result<BoatBookingResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBoatBooking(request)){ completion( self.handleResult(result: $0))}
    }
    
    func getAllDishes(completion: @escaping (Result<GetAllDishesResponse, ErrorResponse>) -> Void) {
        provider.request(.AllDishes){ completion( self.handleResult(result: $0))}
    }
    
    func addOrUpdateFavourite(request: AddFavouriteRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.AddOrUpdateFavourite(request)){ completion( self.handleResult(result: $0))}
    }
    
    func findChefByDishes(dishIds: String, completion: @escaping (Result<FindServiceProviderResponse, ErrorResponse>) -> Void) {
        provider.request(.FindChefByDishes(dishIds: dishIds)){ completion( self.handleResult(result: $0))}
    }
    
    func findBouncers(gender: String, completion: @escaping (Result<FindServiceProviderResponse, ErrorResponse>) -> Void) {
        provider.request(.FindBouncers(gender: gender)){ completion( self.handleResult(result: $0))}
    }
    
    func findDJ(completion: @escaping (Result<FindServiceProviderResponse, ErrorResponse>) -> Void) {
        provider.request(.FindDj){ completion( self.handleResult(result: $0))}
    }
    
    func updateProviderBookingDate(request: CreateBeachHouseBookingRequest, completion: @escaping (Result<BeachHouseBookingResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBeachHouseBooking(request)){ completion( self.handleResult(result: $0))}
    }
    
    func bookServiceProvider(request: CreateBeachHouseBookingRequest, completion: @escaping (Result<BeachHouseBookingResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBeachHouseBooking(request)){ completion( self.handleResult(result: $0))}
    }
    
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
