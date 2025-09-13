//
//  ListingServiceMock.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

class ListingServiceMock: Provider<ListingTarget>, ListingService{
    func deleteBeach(id: String, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    func deleteBoat(id: String, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    func deleteBeachRoom(id: String, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    func EditBoat(request: CreateBoatListingRequest, id: String, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    func EditBeach(request: CreateBeachListingRequest, id: String, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    
    func ListBeach(request: CreateBeachListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    func ListBoat(request: CreateBoatListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    
    var successMode: Bool = true
    let error = ErrorResponse(message: "Error encountered", status: false, errors: nil)
    
    func BeachData(completion: @escaping (Result<BeachDataResponse, ErrorResponse>) -> Void) {

    }
    
    func chefDishes(completion: @escaping (Result<ChefDishesResponse, ErrorResponse>) -> Void) {
        
    }
    
    func BoatData(completion: @escaping (Result<BoatDataResponse, ErrorResponse>) -> Void) {
        
    }
    
    func ListService(request: CreateServiceListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    
    
    
}
