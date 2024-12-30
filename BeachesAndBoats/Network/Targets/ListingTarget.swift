//
//  ListingTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation
import Moya

enum ListingTarget {
    case BeachData(propertyType: String = "beach")
    case BoatData(propertyType: String = "boat")
    case CreateBeachListing(data: CreateBeachListingRequest)
    case CreateServiceListing(data: CreateServiceListingRequest)
    case CreateBoatListing(data: CreateBoatListingRequest)
    case ChefDishes(propertyType: String = "services")
}

extension ListingTarget: BaseTarget {
    var path: String {
        switch self {
        case .BeachData:
            return Urls.propertiesData.rawValue
        case .CreateBeachListing:
            return Urls.createBeach.rawValue
        case .ChefDishes:
            return Urls.propertiesData.rawValue
        case .BoatData:
            return Urls.propertiesData.rawValue
        case .CreateServiceListing:
            return Urls.createService.rawValue
        case .CreateBoatListing:
            return Urls.createBoat.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .BeachData, .ChefDishes, .BoatData:
            return .get
        case .CreateBeachListing, .CreateBoatListing, .CreateServiceListing:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .BeachData(let propertyType), .ChefDishes(let propertyType), .BoatData(let propertyType):
            return .requestParameters(
                parameters: ["property_type": propertyType],
                encoding: URLEncoding.queryString
            )
        case .CreateBeachListing(let data):
            var multipartData: [MultipartFormData] = []

            // Append standard fields as form data
            let fields: [String: Any?] = [
                "name": data.name,
                "description": data.description,
                "about_owner": data.aboutOwner,
                "check_in_from": data.checkInFrom,
                "check_in_to": data.checkInTo,
                "check_out_from": data.checkOutFrom,
                "check_out_to": data.checkOutTo,
                "category_id": data.categoryId,
                "sub_category_id": data.subCategoryId,
                "booking_type": data.bookingType,
                "country": data.country,
                "state": data.state,
                "city": data.city,
                "street_name": data.streetName,
                "latitude": data.latitude,
                "longitude": data.longitude,
                "available_from": data.availableFrom,
                "available_to": data.availableTo,
                "role_type": data.roleType
            ]
            
            for (key, value) in fields {
                if let value = value {
                    if let stringValue = String(describing: value).data(using: .utf8) {
                        multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                    }
                }
            }

            // Handle array fields (amenities, languages, houseRules)
            for (index, amenity) in data.amenities.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(amenity.data(using: .utf8)!), name: "amenities[\(index)]"))
            }

            for (index, language) in data.languages.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(language.data(using: .utf8)!), name: "languages[\(index)]"))
            }

            for (index, rule) in data.houseRules.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(rule.data(using: .utf8)!), name: "houserules[\(index)]"))
            }

            // Handle rooms array
            for (roomIndex, room) in data.rooms.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(room.name.data(using: .utf8)!), name: "rooms[\(roomIndex)][name]"))
                multipartData.append(MultipartFormData(provider: .data(room.description.data(using: .utf8)!), name: "rooms[\(roomIndex)][description]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.quantity).data(using: .utf8)!), name: "rooms[\(roomIndex)][quantity]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.pricePerNight).data(using: .utf8)!), name: "rooms[\(roomIndex)][price_per_night]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.discountPercent).data(using: .utf8)!), name: "rooms[\(roomIndex)][discount_percent]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.noOfOccupant).data(using: .utf8)!), name: "rooms[\(roomIndex)][no_of_occupant]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.hasPrivateBathroom).data(using: .utf8)!), name: "rooms[\(roomIndex)][has_private_bathroom]"))

                // Handle room amenities
                for (amenityIndex, roomAmenity) in room.roomAmenities.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(roomAmenity.data(using: .utf8)!), name: "rooms[\(roomIndex)][room_amenities][\(amenityIndex)]"))
                }

                // Handle bed types
                for (bedIndex, bedType) in room.bedTypes.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(bedType.id.data(using: .utf8)!), name: "rooms[\(roomIndex)][bedTypes][\(bedIndex)][id]"))
                    multipartData.append(MultipartFormData(provider: .data(String(bedType.quantity).data(using: .utf8)!), name: "rooms[\(roomIndex)][bedTypes][\(bedIndex)][quantity]"))
                }

                // Handle room images
                for (imageIndex, imageData) in room.images?.enumerated() ?? [].enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "rooms[\(roomIndex)][images][\(imageIndex)]", fileName: "room_image_\(roomIndex)_\(imageIndex).jpg", mimeType: "image/jpeg"))
                }
            }

            return .uploadMultipart(multipartData)

            
        case .CreateServiceListing(data: let data):
            var multipartData: [MultipartFormData] = []

            // Append standard fields as form data
            let fields: [String: Any] = [
                "role_type": data.roleType,
                "name": data.name,
                "description": data.description,
                "category_id": data.categoryId,
                "available_from": data.availableFrom,
                "available_to": data.availableTo,
                "starting_price": data.startingPrice
            ]
            
            for (key, value) in fields {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }
            
            // Append images array
            for (index, imageData) in data.images.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "images[\(index)]",
                        fileName: "image_\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            
            //Append profile picture
            
            if let profilePictureData = data.profilePic {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(profilePictureData),
                        name: "profile_pic",
                        fileName: "profile_picture.jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
                    

            // Append optional dishes array
            if let dishes = data.dishes {
                for (index, dish) in dishes.enumerated() {
                    multipartData.append(
                        MultipartFormData(
                            provider: .data(dish.data(using: .utf8)!),
                            name: "dishes[\(index)]"
                        )
                    )
                }
            }

            // Append optional gender
            if let gender = data.gender {
                if let genderData = gender.data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(genderData), name: "gender"))
                }
            }

            return .uploadMultipart(multipartData)
            
        case .CreateBoatListing(data: let data):
            var multipartData: [MultipartFormData] = []

            // Append standard fields as form data
            let fields: [String: Any] = [
                "name": data.name,
                "description": data.description,
                "about_owner": data.aboutOwner,
                "no_of_adults": data.noOfAdults,
                "no_of_children": data.noOfChildren,
                "no_of_pets": data.noOfPets,
                "category_id": data.categoryId,
                "sub_category_id": data.subCategoryId,
                "country": data.country,
                "state": data.state,
                "street_name": data.streetName,
                "city": data.city,
                "available_from": data.availableFrom,
                "available_to": data.availableTo
            ]

            for (key, value) in fields {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }

            // Append amenities array
            for (index, amenity) in data.amenities.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(amenity.data(using: .utf8)!),
                        name: "amenities[\(index)]"
                    )
                )
            }

            // Append languages array
            for (index, language) in data.languages.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(language.data(using: .utf8)!),
                        name: "languages[\(index)]"
                    )
                )
            }

            // Append house rules array
            for (index, rule) in data.houseRules.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(rule.data(using: .utf8)!),
                        name: "houserules[\(index)]"
                    )
                )
            }

            // Append destinations array with nested Destination objects
            for (index, destination) in data.destinations.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(destination.destinationId.data(using: .utf8)!),
                        name: "destinations[\(index)][destination_id]"
                    )
                )
                multipartData.append(
                    MultipartFormData(
                        provider: .data(String(destination.pricePerHour).data(using: .utf8)!),
                        name: "destinations[\(index)][price_per_hour]"
                    )
                )
            }

            // Append images array
            for (index, imageData) in data.images.enumerated() {
                multipartData.append(
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "images[\(index)]",
                        fileName: "image_\(index).jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }

            return .uploadMultipart(multipartData)

        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
   
}
