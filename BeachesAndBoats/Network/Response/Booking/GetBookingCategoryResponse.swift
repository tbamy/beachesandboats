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
    let boatBookings: [BoatBooking]?
    let beachHouseBookings: [BeachHouseBooking]?
    
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
    let listingPrice: Float?
    let discountPercent: Int?
    let pricePerDay: Float?
    let dayDiscountPercent: Int?
    let checkInFrom, checkInTo, checkOutFrom, checkOutTo: String?
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
    let destinations: [Destination]?
    let images: [RoomImage]?

    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case checkInFrom = "check_in_from"
        case checkInTo = "check_in_to"
        case checkOutFrom = "check_out_from"
        case pricePerNight = "price_per_night"
        case checkOutTo = "check_out_to"
        case bookingType = "booking_type"
        case category
        case subCategory = "sub_category"
        case owner, amenities, languages, locations, availabilities, houseRules, rooms, userReviewed, rating, userFavourite, reviews
        case noOfAdults
        case noOfChildren
        case noOfPets
        case destinations, images
    }
}

//struct Listingg: Codable {
//    let id, name, description, aboutOwner: String
//    let pricePerDay, dayDiscountPercent, listingPrice, discountPercent: Float?
//    let checkInFrom, checkInTo, checkOutFrom: String?
//    let pricePerNight: Float?
//    let checkOutTo: String?
//    let bookingType: HouseBookingType?
//    let category, subCategory: SubCategory?
//    let owner: Owner?
//    let amenities: [Amenity]?
//    let languages: [Language]?
//    let locations: Location?
//    let availabilities: Availabilities?
//    let houseRules: [HouseRule]?
//    let rooms: [Room]?
//    let userReviewed: Bool?
//    let rating: Int?
//    let userFavourite: Bool?
//    let reviews: [Review]?
//    let noOfAdults, noOfChildren, noOfPets: Int?
//    let images: [Image]?
//    let destinations: [Destination]?
//    let boatBookings: [BoatBooking]?
//    let beachHouseBookings: [BeachHouseBooking]?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case aboutOwner = "about_owner"
//        case pricePerDay = "price_per_day"
//        case dayDiscountPercent = "day_discount_percent"
//        case listingPrice = "listing_price"
//        case discountPercent = "discount_percent"
//        case checkInFrom = "check_in_from"
//        case checkInTo = "check_in_to"
//        case checkOutFrom = "check_out_from"
//        case pricePerNight = "price_per_night"
//        case checkOutTo = "check_out_to"
//        case bookingType = "booking_type"
//        case category
//        case subCategory = "sub_category"
//        case owner, amenities, languages, locations, availabilities, houseRules, rooms, userReviewed, rating, userFavourite, reviews
//        case noOfAdults
//        case noOfChildren
//        case noOfPets
//        case images, destinations, boatBokings, beachHouseBookings
//    }
//}

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
    let pricePerDay, dayDiscountPercent, pricePerNight, discountPercent: Float?
    let images: [RoomImage]?
    let bedTypes: [BookingCatBedType]?
    let noOfOccupant: Int?
    let hasPrivateBathroom: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images, bedTypes
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
    let id, note, createdAt: String?
    let rating: Int?
    let user: User?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case rating
        case note
        case user
    }
}

//struct Review: Codable {
//    let id, firstName, lastName, email: String?
//    let phoneCode, phoneNumber: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email
//        case phoneCode = "phone_code"
//        case phoneNumber = "phone_number"
//    }
//}

// MARK: - Boat Booking
struct BoatBooking: Codable {
    let boat: FavouriteBoat?
    let total: Int
    let summary: String?
    let status: String
    let cruiseLength: Int
    let bookingType: String
    let noOfPeople: Int
    let bookingDate, bookingTime, hostID: String
    let boatDestination: BoatDestination
    let subCategory: BoatBookingSubCategory
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case boat, total, summary, status
        case cruiseLength = "cruise_length"
        case bookingType = "booking_type"
        case noOfPeople = "no_of_people"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case hostID = "host_id"
        case boatDestination = "boat_destination"
        case subCategory = "sub_category"
        case createdAt = "created_at"
    }
}

struct BoatDestination: Codable {
    let id, name: String?
    let price: Float?
}
// MARK: - Beach House Booking
struct BeachHouseBooking: Codable {
    let id, hostID: String?
    let beachHouseRoom: BookingBeachHouseRoom?
    let beachHouse: BookingBeachHouse?
    let checkingDate, checkoutDate, checkingTime, checkoutTime: String?
    let noOfPeople: Int?
    let status: String?
    let summary: String?
    let units, total: Int?
    let createdAt: String?
    let adminCharge: Int?
    let cleaningFee: String?
    let noOfNights: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case hostID = "host_id"
        case beachHouseRoom = "beach_house_room"
        case beachHouse = "beach_house"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case noOfPeople = "no_of_people"
        case status, summary, units, total
        case createdAt = "created_at"
        case adminCharge = "admin_charge"
        case cleaningFee = "cleaning_fee"
        case noOfNights = "no_of_nights"
    }
}

struct BookingBeachHouseRoom: Codable {
    let id, name, description: String?
    let pricePerDay, dayDiscountPercent, pricePerNight, discountPercent: Float?
    let images: [Image]?
    let bedTypes: [BookingBedType]?
    let noOfOccupant, hasPrivateBathroom: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images, bedTypes
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
    }
}

struct BookingBeachHouse: Codable {
    let id, name, description, aboutOwner: String
    let listingPrice, discountPercent: Float?
    let image: String?
    let locations: Locations?
    let availabilities: Availabilities?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case id, name, description
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case image, locations, availabilities, rating
    }
}

// MARK: - BoatBookingSubCategory
struct BoatBookingSubCategory: Codable {
    let id, name, description: String
    let image, icon: String?
}

struct Destination: Codable {
    let id, name: String?
    let price: String?
}

