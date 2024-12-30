//
//  BookingService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation

protocol BookingService{
    func getBookingCategories(page: String, completion: @escaping(Result<GetBookingCategoryResponse, ErrorResponse>) -> Void)
}
