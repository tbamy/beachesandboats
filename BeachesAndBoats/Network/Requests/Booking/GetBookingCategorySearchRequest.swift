//
//  GetBookingCategorySearchRequest.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/07/2025.
//

struct GetBookingCategorySearchRequest: Codable {
    var page: Int?
    var subCategoryId: String?
    var minPrice: Double?
    var maxPrice: Double?
    var noOfBedrooms: Int?
    var noOfAdults: Int?
    var noOfChildren: Int?
    var noOfBeds: Int?
    var petAllowed: Int?
    var languages: [String]?
    var amenities: [String]?
    var filterType: String?
    var searchQuery: String?

    func toParameters() -> [String: Any] {
        var params: [String: Any] = [:]
        if let page = page { params["page"] = page }
        if let subCategoryId = subCategoryId { params["sub_category_id"] = subCategoryId }
        if let minPrice = minPrice { params["min_price"] = minPrice }
        if let maxPrice = maxPrice { params["max_price"] = maxPrice }
        if let noOfBedrooms = noOfBedrooms { params["no_of_bedrooms"] = noOfBedrooms }
        if let noOfAdults = noOfAdults { params["no_of_adults"] = noOfAdults }
        if let noOfChildren = noOfChildren { params["no_of_children"] = noOfChildren }
        if let noOfBeds = noOfBeds { params["no_of_beds"] = noOfBeds }
        if let petAllowed = petAllowed { params["pet_allowed"] = petAllowed }
        if let languages = languages, !languages.isEmpty {
            params["languages"] = languages.joined(separator: ",")
        }
        if let amenities = amenities, !amenities.isEmpty {
            params["amenities"] = amenities.joined(separator: ",")
        }
        if let filterType = filterType { params["filter_type"] = filterType }
        if let searchQuery = searchQuery { params["search_query"] = searchQuery }
        return params
    }
}

