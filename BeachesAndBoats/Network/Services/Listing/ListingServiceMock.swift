//
//  ListingServiceMock.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

class ListingServiceMock: Provider<ListingTarget>, ListingService{
    
    var successMode: Bool = true
    let error = ErrorResponse(message: "Error encountered", status: false)
    
    func BeachData(completion: @escaping (Result<BeachDataResponse, ErrorResponse>) -> Void) {

//        let category = [Category(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, description: <#T##String#>, image: <#T##String?#>, accountID: <#T##String#>, categoryID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let subCategory = [SubCategory(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, description: <#T##String#>, image: <#T##String?#>, accountID: <#T##String#>, categoryID: <#T##String#>, subCatID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let guestAllowed = [GuestAllowed(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, description: <#T##String#>, accountID: <#T##String#>, bookingID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let rules = [HouseRule(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, description: <#T##String#>, accountID: <#T##String#>, bookingID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let languages = [Language(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, accountID: <#T##String#>, languageID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let amenities = [AmenityCategory(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, accountID: <#T##String#>, categoryID: <#T##String#>, tagID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>, amenities: <#T##[Amenity]#>)]
//        let amenity = [Amenity(id: <#T##Int#>, name: <#T##String#>, slug: <#T##String#>, accountID: <#T##String#>, amenityID: <#T##String#>, tagID: <#T##String#>, createdAt: <#T##String#>, updatedAt: <#T##String#>)]
//        
//        let data = BeachData(categories: <#T##[Category]#>, subCategories: <#T##[SubCategory]#>, guestAllowed: <#T##[GuestAllowed]#>, rules: <#T##[HouseRule]#>, languages: <#T##[Language]#>, amenities: <#T##[AmenityCategory]#>)
//        
//        let response = BeachDataResponse(success: <#T##Bool#>, message: <#T##String#>, data: <#T##BeachData#>)
    }
    
    func chefDishes(completion: @escaping (Result<ChefDishesResponse, ErrorResponse>) -> Void) {
        
    }
    
    func BoatData(completion: @escaping (Result<BoatDataResponse, ErrorResponse>) -> Void) {
        
    }
    
    func ListService(request: CreateServiceListingRequest, completion: @escaping (Result<GeneralResponse, ErrorResponse>) -> Void) {
        
    }
    
    
    
    
}
