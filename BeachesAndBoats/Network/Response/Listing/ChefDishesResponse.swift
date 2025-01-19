//
//  ChefDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import Foundation

struct ChefDishesResponse: Codable{
    let status: Bool
    let message: String
    let data: DishesData?
}

struct DishesData: Codable{
    let categories: [BeachCategory]?
    let dishes: [Dishes]?
}

struct Dishes: Codable{
    let id : String
    let name : String
}

