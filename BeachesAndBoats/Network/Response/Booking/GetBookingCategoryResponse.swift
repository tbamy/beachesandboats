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

//// MARK: - Sub Category
//struct SubCategory: Codable {
//    let id: String?
//    let name: String?
//    let description: String?
//    let image: String?
//    let icon: String?
//}
//
//// MARK: - Listing
//struct Listing: Codable {
//    let id: String?
//    let name: String?
//    let description: String?
//    let aboutOwner: String?
//    let listingPrice: Float?
//    let discountPercent: Float?
//    let pricePerDay: Float?
//    let dayDiscountPercent: Float?
//    let checkInFrom, checkInTo, checkOutFrom, checkOutTo: String?
//    let pricePerNight: Float?
//    let bookingType: String?
//    let category: Category?
//    let subCategory: SubCategory?
//    let owner: Owner?
//    let amenities: [Amenity]?
//    let languages: [Language]?
//    let locations: Location?
//    let availabilities: Availability?
//    let houseRules: [BookingHouseRule]?
//    let rooms: [BookingRoom]?
//    let userReviewed: Bool?
//    let rating: Double?
//    let userFavourite: Bool?
//    let reviews: [Review]?
//    let noOfAdults: Int?
//    let noOfChildren: Int?
//    let noOfPets: Int?
//    let destinations: [Destination]?
//    let images: [RoomImage]?
//
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
//        case destinations, images
//    }
//}
//
////struct Listingg: Codable {
////    let id, name, description, aboutOwner: String
////    let pricePerDay, dayDiscountPercent, listingPrice, discountPercent: Float?
////    let checkInFrom, checkInTo, checkOutFrom: String?
////    let pricePerNight: Float?
////    let checkOutTo: String?
////    let bookingType: HouseBookingType?
////    let category, subCategory: SubCategory?
////    let owner: Owner?
////    let amenities: [Amenity]?
////    let languages: [Language]?
////    let locations: Location?
////    let availabilities: Availabilities?
////    let houseRules: [HouseRule]?
////    let rooms: [Room]?
////    let userReviewed: Bool?
////    let rating: Int?
////    let userFavourite: Bool?
////    let reviews: [Review]?
////    let noOfAdults, noOfChildren, noOfPets: Int?
////    let images: [Image]?
////    let destinations: [Destination]?
////    let boatBookings: [BoatBooking]?
////    let beachHouseBookings: [BeachHouseBooking]?
////
////    enum CodingKeys: String, CodingKey {
////        case id, name, description
////        case aboutOwner = "about_owner"
////        case pricePerDay = "price_per_day"
////        case dayDiscountPercent = "day_discount_percent"
////        case listingPrice = "listing_price"
////        case discountPercent = "discount_percent"
////        case checkInFrom = "check_in_from"
////        case checkInTo = "check_in_to"
////        case checkOutFrom = "check_out_from"
////        case pricePerNight = "price_per_night"
////        case checkOutTo = "check_out_to"
////        case bookingType = "booking_type"
////        case category
////        case subCategory = "sub_category"
////        case owner, amenities, languages, locations, availabilities, houseRules, rooms, userReviewed, rating, userFavourite, reviews
////        case noOfAdults
////        case noOfChildren
////        case noOfPets
////        case images, destinations, boatBokings, beachHouseBookings
////    }
////}
//
//// MARK: - Category
//struct Category: Codable {
//    let id: String?
//    let name: String?
//    let description: String?
//    let image: String?
//}
//
//// MARK: - Owner
//struct Owner: Codable {
//    let id: String?
//    let firstName: String?
//    let lastName: String?
//    let email: String?
//    let phoneCode: String?
//    let phoneNumber: String?
//    let dob: String?
//    let roles: [String]?
//    
//    enum CodingKeys: String, CodingKey {
//        case id
//        case firstName = "first_name"
//        case lastName = "last_name"
//        case email
//        case phoneCode = "phone_code"
//        case phoneNumber = "phone_number"
//        case dob
//        case roles
//    }
//}
//
//// MARK: - Amenity
//struct Amenity: Codable {
//    let id: String?
//    let name: String?
//    let icon: String?
//    let amenityType: String?
//    let propertyType: String?
//}
//
//// MARK: - Language
//struct Language: Codable {
//    let name: String?
//}
//
//// MARK: - Location
//struct Location: Codable {
//    let country: String?
//    let state: String?
//    let streetName: String?
//    let city: String?
//    let latitude: String?
//    let longitude: String?
//    
//    enum CodingKeys: String, CodingKey{
//        case country
//        case state
//        case streetName = "street_name"
//        case city
//        case latitude
//        case longitude
//    }
//}
//
//// MARK: - Availability
//struct Availability: Codable {
//    let availableFrom: String?
//    let availableTo: String?
//    
//    enum CodingKeys: String, CodingKey{
//        case availableFrom = "available_from"
//        case availableTo = "available_to"
//    }
//}
//
//// MARK: - House Rule
//struct BookingHouseRule: Codable {
//    let name: String?
//    let description: String?
//}
//
//// MARK: - Room
struct BookingRoom: Codable {
    let id: String?
    let name: String?
    let description: String?
    let pricePerDay, dayDiscountPercent, pricePerNight, discountPercent: Float?
    let images: [RoomImage]?
    let bedTypes: [BookingCatBedType]?
    let noOfOccupant: String?
    let hasPrivateBathroom: String?
    let quantity: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case images, bedTypes
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
        case quantity
    }
}
//
//// MARK: - Bed Type
struct BookingCatBedType: Codable {
    let id: String?
    let name: String?
    let description: String?
    let quantity: String?
}

struct RoomImage: Codable{
    let url: String?
}

//// MARK: - Review
//struct Review: Codable {
//    let id, note, createdAt: String?
//    let rating: String?
//    let user: User?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case createdAt = "created_at"
//        case rating
//        case note
//        case user
//    }
//}
//
////struct Review: Codable {
////    let id, firstName, lastName, email: String?
////    let phoneCode, phoneNumber: String?
////
////    enum CodingKeys: String, CodingKey {
////        case id
////        case firstName = "first_name"
////        case lastName = "last_name"
////        case email
////        case phoneCode = "phone_code"
////        case phoneNumber = "phone_number"
////    }
////}
//
//// MARK: - Boat Booking
//struct BoatBooking: Codable {
//    let boat: FavouriteBoat?
//    let total: Float
//    let summary: String?
//    let status: String
//    let cruiseLength: String
//    let bookingType: String
//    let noOfPeople: String
//    let bookingDate, bookingTime, hostID: String
//    let boatDestination: BoatDestination
//    let subCategory: BoatBookingSubCategory
//    let createdAt: String
//
//    enum CodingKeys: String, CodingKey {
//        case boat, total, summary, status
//        case cruiseLength = "cruise_length"
//        case bookingType = "booking_type"
//        case noOfPeople = "no_of_people"
//        case bookingDate = "booking_date"
//        case bookingTime = "booking_time"
//        case hostID = "host_id"
//        case boatDestination = "boat_destination"
//        case subCategory = "sub_category"
//        case createdAt = "created_at"
//    }
//}
//
//struct BoatDestination: Codable {
//    let id, name: String?
//    let price: String?
//}

//// MARK: - Beach House Booking
//struct BeachHouseBooking: Codable {
//    let id, hostID: String?
//    let beachHouseRoom: BookingBeachHouseRoom?
//    let beachHouse: BookingBeachHouse?
//    let checkingDate, checkoutDate, checkingTime, checkoutTime: String?
//    let noOfPeople: String?
//    let status: String?
//    let summary: String?
//    let units: String?
//    let total: Float?
//    let createdAt: String?
//    let adminCharge: Float?
//    let cleaningFee: String?
//    let noOfNights: Int?
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case hostID = "host_id"
//        case beachHouseRoom = "beach_house_room"
//        case beachHouse = "beach_house"
//        case checkingDate = "checking_date"
//        case checkoutDate = "checkout_date"
//        case checkingTime = "checking_time"
//        case checkoutTime = "checkout_time"
//        case noOfPeople = "no_of_people"
//        case status, summary, units, total
//        case createdAt = "created_at"
//        case adminCharge = "admin_charge"
//        case cleaningFee = "cleaning_fee"
//        case noOfNights = "no_of_nights"
//    }
//}
//
//struct BookingBeachHouseRoom: Codable {
//    let id, name, description: String?
//    let pricePerDay, dayDiscountPercent, pricePerNight, discountPercent: Float?
//    let images: [Image]?
//    let bedTypes: [BookingBedType]?
//    let noOfOccupant: String?
//    let hasPrivateBathroom: String?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case pricePerDay = "price_per_day"
//        case dayDiscountPercent = "day_discount_percent"
//        case pricePerNight = "price_per_night"
//        case discountPercent = "discount_percent"
//        case images, bedTypes
//        case noOfOccupant = "no_of_occupant"
//        case hasPrivateBathroom = "has_private_bathroom"
//    }
//}
//
//struct BookingBeachHouse: Codable {
//    let id, name, description, aboutOwner: String
//    let listingPrice, discountPercent: Float?
//    let image: String?
//    let locations: Location?
//    let availabilities: Availabilities?
//    let rating: Double?
//
//    enum CodingKeys: String, CodingKey {
//        case id, name, description
//        case aboutOwner = "about_owner"
//        case listingPrice = "listing_price"
//        case discountPercent = "discount_percent"
//        case image, locations, availabilities, rating
//    }
//}
//
//// MARK: - BoatBookingSubCategory
//struct BoatBookingSubCategory: Codable {
//    let id, name, description: String
//    let image, icon: String?
//}
//
//struct Destination: Codable {
//    let id, name: String?
//    let price: String?
//}


// MARK: - Sub Category
struct SubCategory: Codable {
    let id: String
    let name: String
    let description: String
    let image: String?
    let icon: String?
}

// MARK: - Listing
struct Listing: Codable {
    let id: String
    let name: String
    let description: String
    let aboutOwner: String?
    let pricePerDay: Float?
    let dayDiscountPercent: Float?
    let listingPrice: Float?
    let discountPercent: Float?
    let checkInFrom: String?
    let checkInTo: String?
    let checkOutFrom: String?
    let pricePerNight: Float?
    let checkOutTo: String?
    let bookingType: String?
    let noOfPassengers: String?
//    let noOfChildren: String?
//    let noOfPets: String?
    let category: Category
    let subCategory: SubCategory
    let locations: Location?
    let availabilities: Availability?
    let images: [ImageURL]?
    let destinations: [Destination]?
    let minRoomPricePerDay: String?
    let minRoomPricePerNight: String?
    let userReviewed: Bool
    let rooms: [BookingRoom]?
    let rating: Double
    let userFavourite: Bool
    let owner: Owner?
    let amenities: [Amenity]?
    let languages: [Language]?
    let houseRules: [HouseRule]?
    let reviews: [Review]?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, category, locations, availabilities, images, destinations, rating, owner, amenities, languages, reviews
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
        case noOfPassengers = "no_of_passengers"
//        case noOfChildren = "no_of_children"
//        case noOfPets = "no_of_pets"
        case subCategory = "sub_category"
        case minRoomPricePerDay = "minRoomPricePerDay"
        case minRoomPricePerNight = "minRoomPricePerNight"
        case userReviewed, userFavourite, rooms
        case houseRules = "houseRules"
    }
}

// MARK: - Category
struct Category: Codable {
    let id: String
    let name: String
    let description: String
    let image: String?
    let icon: String?
}

// MARK: - Location
struct Location: Codable {
    let name: String?
    let jettyLocation: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case jettyLocation = "jetty_location"
    }
}

// MARK: - Availability
struct Availability: Codable {
    let availableFrom: String?
    let availableTo: String?
    
    enum CodingKeys: String, CodingKey {
        case availableFrom = "available_from"
        case availableTo = "available_to"
    }
}

// MARK: - Image URL
struct ImageURL: Codable {
    let url: String?
}

// MARK: - Destination
struct Destination: Codable {
    let id: String
    let name: String
    let price: String?
}

struct Destinations: Codable {
    let id: String
    let name: String
    let price: Float?
}


// MARK: - Owner
struct Owner: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String
    let dob: String?
    let roles: [String]?
    let isAccountVerified: Bool?
    let verificationStatus: String?
    let notificationSettings: [NotificationSetting]?
    let mfaEnabled: Bool?
    let mfaEmail: String?
    let mfaPhoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id, email, dob, roles
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
        case isAccountVerified, verificationStatus, notificationSettings
        case mfaEnabled = "mfa_enabled"
        case mfaEmail = "mfa_email"
        case mfaPhoneNumber = "mfa_phone_number"
    }
}

// MARK: - Notification Setting
//struct NotificationSetting: Codable {
//    let id: String
//    let title: String
//    let description: String
//    let status: Bool
//}

// MARK: - Amenity
struct Amenity: Codable {
    let id: String
    let name: String
    let icon: String?
    let amenityType: String
    let propertyType: String
}

// MARK: - Language
struct Language: Codable {
    let id: String?
    let name: String
}

// MARK: - House Rule
//struct HouseRule: Codable {
//    let name: String
//    let description: String?
//}

// MARK: - Review
struct Review: Codable {
    let id: String
    let user: ReviewUser?
    let rating: String
    let note: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, user, rating, note
        case createdAt = "created_at"
    }
}

// MARK: - Review User
struct ReviewUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneCode: String
    let phoneNumber: String
    let dob: String
    let roles: [String]
    
    enum CodingKeys: String, CodingKey {
        case id, email, dob, roles
        case firstName = "first_name"
        case lastName = "last_name"
        case phoneCode = "phone_code"
        case phoneNumber = "phone_number"
    }
}

// MARK: - Boat Booking
struct BoatBooking: Codable {
    let bookingId: String?
    let boat: Boat?
    let total: Double?
    let summary: String?
    let status: String?
    let cruiseLength: String?
    let bookingType: String?
    let noOfPeople: String?
    let bookingDate: String?
    let bookingTime: String?
    let hostId: String?
    let hostFirstName: String?
    let hostLastName: String?
    let hostEmail: String?
    let phoneNumber: String?
    let isHostAccountVerified: Bool?
    let boatDestination: Destinations?
    let subCategory: SubCategory?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case boat, total, summary, status
        case bookingId = "booking_id"
        case cruiseLength = "cruise_length"
        case bookingType = "booking_type"
        case noOfPeople = "no_of_people"
        case bookingDate = "booking_date"
        case bookingTime = "booking_time"
        case hostId = "host_id"
        case hostFirstName = "host_first_name"
        case hostLastName = "host_last_name"
        case hostEmail = "host_email"
        case phoneNumber = "phone_number"
        case isHostAccountVerified
        case boatDestination = "boat_destination"
        case subCategory = "sub_category"
        case createdAt = "created_at"
    }
}

// MARK: - Boat
struct Boat: Codable {
    let id: String
    let name: String
    let description: String?
    let locations: Location?
    let availabilities: Availability?
    let images: [ImageURL]?
    let destinations: [Destination]?
    let rating: Double?
}

// MARK: - Beach House Booking
struct BeachHouseBooking: Codable {
    let id: String
    let hostId: String
    let hostFirstName: String
    let hostLastName: String
    let hostEmail: String
    let phoneNumber: String
    let isHostAccountVerified: Bool
    let beachHouseRoom: BeachHouseRoom?
    let beachHouse: BeachHouse?
    let checkingDate: String
    let checkoutDate: String
    let checkingTime: String
    let checkoutTime: String
    let noOfPeople: String
    let status: String
    let summary: String?
    let units: String
    let total: Double
    let createdAt: String
    let adminCharge: Double
    let cleaningFee: String
    let noOfNights: Int
    
    enum CodingKeys: String, CodingKey {
        case id, status, summary, units, total
        case hostId = "host_id"
        case hostFirstName = "host_first_name"
        case hostLastName = "host_last_name"
        case hostEmail = "host_email"
        case phoneNumber = "phone_number"
        case isHostAccountVerified
        case beachHouseRoom = "beach_house_room"
        case beachHouse = "beach_house"
        case checkingDate = "checking_date"
        case checkoutDate = "checkout_date"
        case checkingTime = "checking_time"
        case checkoutTime = "checkout_time"
        case noOfPeople = "no_of_people"
        case createdAt = "created_at"
        case adminCharge = "admin_charge"
        case cleaningFee = "cleaning_fee"
        case noOfNights = "no_of_nights"
    }
}

// MARK: - Beach House Room
struct BeachHouseRoom: Codable {
    let id: String
    let name: String?
    let description: String?
    let pricePerDay: Float?
    let dayDiscountPercent: Float?
    let pricePerNight: Float?
    let discountPercent: Float?
    let images: [ImageURL]?
    let bedTypes: [BedType]?
    let noOfOccupant: String?
    let hasPrivateBathroom: String?
    let quantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, images, quantity
        case pricePerDay = "price_per_day"
        case dayDiscountPercent = "day_discount_percent"
        case pricePerNight = "price_per_night"
        case discountPercent = "discount_percent"
        case bedTypes = "bedTypes"
        case noOfOccupant = "no_of_occupant"
        case hasPrivateBathroom = "has_private_bathroom"
    }
}

// MARK: - Bed Type
struct BedType: Codable {
    let id: String
    let name: String?
    let description: String?
    var quantity: String?
}

// MARK: - Beach House
struct BeachHouse: Codable {
    let id: String
    let name: String?
    let description: String?
    let aboutOwner: String?
    let listingPrice: Float?
    let discountPercent: Double?
    let minRoomPricePerDay: String?
    let minRoomPricePerNight: String?
    let image: String?
    let locations: Location?
    let availabilities: Availability?
    let rating: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, locations, availabilities, rating
        case aboutOwner = "about_owner"
        case listingPrice = "listing_price"
        case discountPercent = "discount_percent"
        case minRoomPricePerDay, minRoomPricePerNight
    }
}
