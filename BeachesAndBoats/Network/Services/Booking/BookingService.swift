//
//  BookingService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

protocol BookingService{
    func getBookingCategories(filter: GetBookingCategorySearchRequest, completion: @escaping(Result<GetBookingCategoryResponse, ErrorResponse>) -> Void)
    func bookingConfiguration(completion: @escaping(Result<BookingConfigurationResponse, ErrorResponse>) -> Void)
    func createBeachHouseBooking(request: CreateBeachHouseBookingRequest, completion: @escaping(Result<BeachHouseBookingResponse, ErrorResponse>) -> Void)
    
    func createBoatBooking(request: CreateBoatBookingRequest, completion: @escaping(Result<BoatBookingResponse, ErrorResponse>) -> Void)
    
    func addOrUpdateReview(request: AddReviewRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    
    func addOrUpdateFavourite(request: AddFavouriteRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    
    func findChefByDishes(dishIds: String, completion: @escaping(Result<FindServiceProviderResponse, ErrorResponse>) -> Void)
    
    func findBouncers(gender: String, completion: @escaping(Result<FindServiceProviderResponse, ErrorResponse>) -> Void)
    
    func findDJ(completion: @escaping(Result<FindServiceProviderResponse, ErrorResponse>) -> Void)
    
    func updateProviderBookingDate(request: CreateBeachHouseBookingRequest, completion: @escaping(Result<BeachHouseBookingResponse, ErrorResponse>) -> Void)
    
    func bookServiceProvider(request: CreateBeachHouseBookingRequest, completion: @escaping(Result<BeachHouseBookingResponse, ErrorResponse>) -> Void)
    
    func getAllDishes(completion: @escaping(Result<GetAllDishesResponse, ErrorResponse>) -> Void)
    func paymentCallback(reference: String, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
    
    func getBeachHouse(id: String, completion: @escaping(Result<GetBeachResponse, ErrorResponse>) -> Void)
    func getBoat(id: String, completion: @escaping(Result<GetBoatResponse, ErrorResponse>) -> Void)
}
