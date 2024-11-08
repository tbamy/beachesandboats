//
//  ChefDataResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/11/2024.
//

import Foundation

struct ChefDishesResponse: Codable{
    let success: Bool
    let message: String
    let data: Dishes
}

struct Dishes: Codable{
    let dishes: [DishesData]
}

struct DishesData: Codable{
    let id : Int
    let name : String
    let slug : String
    let account_id : String
    let dish_id : String
    let created_at : String
    let updated_at : String
          
}
