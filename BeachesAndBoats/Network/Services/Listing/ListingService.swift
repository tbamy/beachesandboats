//
//  ListingService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation

protocol ListingService{
    func BeachData(completion: @escaping(Result<BeachDataResponse, ErrorResponse>) -> Void)
    func BoatData(completion: @escaping(Result<BoatDataResponse, ErrorResponse>) -> Void)
    func chefDishes(completion: @escaping(Result<ChefDishesResponse, ErrorResponse>) -> Void)
    func ListService(request: CreateServiceListingRequest, completion: @escaping(Result<GeneralResponse, ErrorResponse>) -> Void)
}
