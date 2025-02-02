//
//  ListingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

class ListingServiceImplementation: Provider<ListingTarget>, ListingService{
    func ListService(request: CreateServiceListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateServiceListing(data: request)){ completion( self.handleResult(result: $0))}
    }
    
    func chefDishes(completion: @escaping (Result<ChefDishesResponse, ErrorResponse>) -> Void) {
        provider.request(.ChefDishes()){ completion( self.handleResult(result: $0))}
    }
    
    func BeachData(completion: @escaping (Result<BeachDataResponse, ErrorResponse>) -> Void) {
        provider.request(.BeachData()){ completion( self.handleResult(result: $0))}
    }
    
    func BoatData(completion: @escaping (Result<BoatDataResponse, ErrorResponse>) -> Void) {
        provider.request(.BoatData()){ completion( self.handleResult(result: $0))}
    }
    
    func ListBoat(request: CreateBoatListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBoatListing(data: request)){ completion( self.handleResult(result: $0))}
    }
    
    func ListBeach(request: CreateBeachListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        provider.request(.CreateBeachListing(data: request)){ completion( self.handleResult(result: $0))}
    }
    
    
    
}
