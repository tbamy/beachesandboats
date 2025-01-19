//
//  GetBookingCategoryResponse.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation


// MARK: - Root Response
struct GetBookingCategoryResponse: Codable {
    let status: Bool
    let message: String
    let data: [PropertyCategory]?
}

// MARK: - Property Category
struct PropertyCategory: Codable {
    let id: String?
    let name: String?
    let propertyType: String?
    let description: String?
    let image: String?
    let subCategories: [SubCategory]?
    let listings: [Listing]?
    
}

// MARK: - Sub Category
struct SubCategory: Codable {
    let id: String?
    let name: String?
    let description: String?
    let image: String?
    let icon: String?
}

// MARK: - Listing
struct Listing: Codable {
    let id: String?
    let name: String?
    let description: String?
    let aboutOwner: String?
    let checkInFrom: String?
    let checkInTo: String?
    let checkOutFrom: String?
    let checkOutTo: String?
    let pricePerNight: Float?
    let bookingType: String?
    let category: Category?
    let subCategory: SubCategory?
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let locations: Location?
    let availabilities: Availability?
    let houseRules: [BookingHouseRule]?
    let rooms: [BookingRoom]?
    let userReviewed: Bool?
    let rating: Int?
    let userFavourite: Bool?
    let reviews: [Review]?
    let noOfAdults: Int?
    let noOfChildren: Int?
    let noOfPets: Int?
    let destinations: [Destinations]?
    let images: [RoomImage]?
//    let boatBookings: [BoatBooking]?
//    let beachHouseBookings: [BeachHouseBooking]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case checkInFrom = "check_in_from"
        case checkInTo = "check_in_to"
        case checkOutFrom = "check_out_from"
        case checkOutTo = "check_out_to"
        case pricePerNight = "price_per_night"
        case bookingType = "booking_type"
        case category
        case subCategory = "sub_category"
        case owner
        case amenities
        case languages
        case locations
        case availabilities
        case houseRules
        case rooms
        case userReviewed
        case rating
        case userFavourite
        case reviews
        case noOfAdults = "no_of_adults"
        case noOfChildren = "no_of_children"
        case noOfPets = "no_of_pets"
        case destinations
        case images
    }
}

// MARK: - Category
struct Category: Codable {
    let id: String?
    let name: String?
    let description: String?
    let image: String?
}

// MARK: - Owner
struct Owner: Codable {
    let id: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneCode: String?
    let phoneNumber: String?
    let dob: String?
    let roles: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case dob
        case roles
    }
}

// MARK: - Amenity
struct Amenity: Codable {
    let id: String?
    let name: String?
    let icon: String?
    let amenityType: String?
    let propertyType: String?
}

// MARK: - Language
struct Language: Codable {
    let name: String?
}

// MARK: - Location
struct Location: Codable {
    let country: String?
    let state: String?
    let streetName: String?
    let city: String?
    let latitude: String?
    let longitude: String?
    
    enum CodingKeys: String, CodingKey{
        case country
        case state
        case streetName = "street_name"
        case city
        case latitude
        case longitude
    }
}

// MARK: - Availability
struct Availability: Codable {
    let availableFrom: String?
    let availableTo: String?
    
    enum CodingKeys: String, CodingKey{
        case availableFrom = "available_from"
        case availableTo = "available_to"
    }
}

// MARK: - House Rule
struct BookingHouseRule: Codable {
    let name: String?
    let description: String?
}

// MARK: - Room
struct BookingRoom: Codable {
    let id: String?
    let name: String?
    let description: String?
    let pricePerNight: Float??
    let discountPercent: Float?
    let images: [RoomImage]?
    let bedTypes: [BookingCatBedType]?
    let noOfOccupant: Int?
    let hasPrivateBathroom: Int?
    
    enum CodingKeys: String, CodingKey{
        case id
        case name
        case description
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images
        case bedTypes
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
    }
}

// MARK: - Bed Type
struct BookingCatBedType: Codable {
    let id: String?
    let name: String?
    let description: String?
    let quantity: Int?
}

struct RoomImage: Codable{
    let url: String?
}

// MARK: - Review
struct Review: Codable {
//    let id: String
//    let userId: String
//    let reviewableId: String
//    let reviewableType: String
//    let rating: Int
//    let note: String
//    let createdAt: String
//    let updatedAt: String
}

// MARK: - Boat Booking
struct BoatBooking: Codable {
    // Define properties if available
}

// MARK: - Beach House Booking
struct BeachHouseBooking: Codable {
    // Define properties if available
}



@propertyWrapper
struct StringOrNumber: Codable {
    var wrappedValue: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let stringValue = try? container.decode(String.self) {
            wrappedValue = stringValue
        } else if let doubleValue = try? container.decode(Double.self) {
            wrappedValue = String(doubleValue)
        } else if let intValue = try? container.decode(Int.self) {
            wrappedValue = String(intValue)
        } else {
            wrappedValue = nil // Handle missing key by setting nil
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }
}
