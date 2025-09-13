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
    case CreateBeachListing(data: CreateBeachListingRequest?)
    case CreateServiceListing(data: CreateServiceListingRequest)
    case CreateBoatListing(data: CreateBoatListingRequest?)
    case ChefDishes(propertyType: String = "services")
    case EditBeach(data: CreateBeachListingRequest?, id: String)
    case EditBoat(data: CreateBoatListingRequest?, id: String)
    case deleteBeachRoom(id: String)
    case deleteBoat(id: String)
    case deleteBeach(id: String)
    
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
        case .EditBeach(_, let id):
            return String(format: Urls.editBeach.rawValue, id)
        case .EditBoat(_, let id):
            return String(format: Urls.editBoat.rawValue, id)
        case .deleteBeachRoom(id: let id):
            return String(format: Urls.deleteBeachRoom.rawValue, id)
        case .deleteBoat(id: let id):
            return String(format: Urls.deleteBoat.rawValue, id)
        case .deleteBeach(id: let id):
            return String(format: Urls.deleteBeachHouse.rawValue, id)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .BeachData, .ChefDishes, .BoatData:
            return .get
        case .CreateBeachListing, .CreateBoatListing, .CreateServiceListing:
            return .post
        case .EditBeach:
            return .post
        case .EditBoat:
            return .post
        case .deleteBeachRoom, .deleteBoat, .deleteBeach:
            return .delete
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
            let multipartData = beachListingRequest(data: data, isEdit: false)
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
           let multipartData = boatListingRequest(data: data)
            return .uploadMultipart(multipartData)

        case .EditBeach(data: let data, _):
            let multipartData = beachListingRequest(data: data, isEdit: true)
            return .uploadMultipart(multipartData)
            
        case .EditBoat(data: let data, _):
            let multipartData = boatListingRequest(data: data)
            return .uploadMultipart(multipartData)
        case .deleteBeachRoom(id: let id):
            return .requestPlain
        case .deleteBoat(id: let id):
            return .requestPlain
        case .deleteBeach(id: let id):
            return .requestPlain
        }
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
    func boatListingRequest(data: CreateBoatListingRequest?) -> [MultipartFormData] {
        var multipartData: [MultipartFormData] = []
        
        guard let data = data else { return multipartData }

        // Append standard fields
        let fields: [String: Any?] = [
            "name": data.name,
            "description": data.description,
            "about_owner": data.aboutOwner,
            "no_of_passengers": data.noOfPassengers,
//            "category_id": data.categoryId,
            "sub_category_id": data.subCategoryId,
            "jetty_location": data.jettyLocation,
            "location_name": data.locationName,
            "available_from": data.availableFrom,
            "available_to": data.availableTo
        ]
        
        for (key, value) in fields {
            if let value = value {
                if let stringValue = "\(value)".data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }
        }

        // Append amenities
        data.amenities?.enumerated().forEach { index, amenity in
            if let amenityData = amenity.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(amenityData), name: "amenities[\(index)]"))
            }
        }

        // Append languages
        data.languages?.enumerated().forEach { index, language in
            if let languageData = language.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(languageData), name: "languages[\(index)]"))
            }
        }

        // Append house rules
        data.houseRules?.enumerated().forEach { index, rule in
            if let ruleData = rule.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(ruleData), name: "houserules[\(index)]"))
            }
        }

        // Append destinations
        data.destinations?.enumerated().forEach { index, destination in
            if let idData = destination.destinationId?.data(using: .utf8),
               let priceData = "\(destination.pricePerHour ?? 0)".data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(idData), name: "destinations[\(index)][destination_id]"))
                multipartData.append(MultipartFormData(provider: .data(priceData), name: "destinations[\(index)][price_per_hour]"))
            }
        }

        // Append images
        data.images?.enumerated().forEach { index, imageData in
            multipartData.append(
                MultipartFormData(
                    provider: .data(imageData),
                    name: "images[\(index)]",
                    fileName: "image_\(index).jpg",
                    mimeType: "image/jpeg"
                )
            )
        }

        return multipartData
    }

    
    func beachListingRequest(data: CreateBeachListingRequest?, isEdit: Bool = false) -> [MultipartFormData]{
        var multipartData: [MultipartFormData] = []
        
        guard let data = data else { return multipartData }

        // Append standard fields as form data
        let fields: [String: Any?] = [
            "name": data.name,
            "description": data.description,
            "about_owner": data.aboutOwner,
            "overnight_check_in": data.overnightCheckIn,
            "overnight_check_out": data.overnightCheckOut,
            "day_check_in": data.dayCheckIn,
            "day_check_out": data.dayCheckOut,
            "category_id": data.categoryId,
            "sub_category_id": data.subCategoryId,
            "booking_type": data.bookingType,
            "location_name" : data.locationName,
            "jetty_location" : data.jettyLocation,
            "additional_house_rules" : data.additionalHouseRules,
            "is_private_stay": data.isPrivateStay,
            "available_from": data.availableFrom,
            "available_to": data.availableTo,
            "role_type": data.roleType,
            "listing_price": data.listingPrice,
            "discount_percent": data.discountPercent,
            "price_per_day": data.pricePerDay,
            "day_discount_percent": data.dayDiscountPercent,
            "no_of_rooms" : data.noOfRooms,
            "no_of_guests" : data.noOfGuests,
            "no_of_beds" : data.noOfBeds,
            "no_of_bathrooms" : data.noOfBathrooms
        ]
        
        for (key, value) in fields {
            if let value = value {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }
        }


        // Handle array fields (amenities, languages, houseRules)
        data.amenities?.enumerated().forEach { index, amenity in
            if let amenityData = amenity.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(amenityData), name: "amenities[\(index)]"))
            }
        }
        
        data.languages?.enumerated().forEach{ index, language in
            if let languageData = language.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(languageData), name: "languages[\(index)]"))
            }
        }
        
        data.houseRules?.enumerated().forEach{ index, rule in
            if let ruleData = rule.data(using: .utf8) {
                multipartData.append(MultipartFormData(provider: .data(ruleData), name: "houserules[\(index)]"))
            }
        }
        
        for (imageIndex, imageData) in data.images?.enumerated() ?? [].enumerated() {
            multipartData.append(
                MultipartFormData(
                    provider: .data(imageData),
                    name: "images[\(imageIndex)]",
                    fileName: "\(data.name?.lowercased() ?? "listing")_\(imageIndex).jpg",
                    mimeType: "image/jpeg"
                )
            )
        }

        // Handle rooms array
        if let rooms = data.rooms {
            for (roomIndex, room) in rooms.enumerated() {
                // Include room ID for edit operations
                if isEdit, let roomId = room.id {
                    if let idData = roomId.data(using: .utf8) {
                        multipartData.append(MultipartFormData(provider: .data(idData), name: "rooms[\(roomIndex)][id]"))
                    }
                }
                
                if let nameData = room.name?.data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(nameData), name: "rooms[\(roomIndex)][name]"))
                }
                if let descriptionData = room.description?.data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(descriptionData), name: "rooms[\(roomIndex)][description]"))
                }

                multipartData.append(MultipartFormData(provider: .data(String(room.quantity ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][quantity]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.pricePerNight ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][price_per_night]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.discountPercent ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][discount_percent]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.pricePerDay ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][price_per_day]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.dayDiscountPercent ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][day_discount_percent]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.noOfOccupant ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][no_of_occupant]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.hasPrivateBathroom ?? 0).data(using: .utf8)!), name: "rooms[\(roomIndex)][has_private_bathroom]"))

                // Room Amenities
                room.roomAmenities?.enumerated().forEach { amenityIndex, roomAmenity in
                    if let amenityData = roomAmenity.data(using: .utf8) {
                        multipartData.append(MultipartFormData(provider: .data(amenityData), name: "rooms[\(roomIndex)][room_amenities][\(amenityIndex)]"))
                    }
                }

                // Bed Types
                room.bedTypes?.enumerated().forEach { bedIndex, bedType in
                    if let idData = bedType.id.data(using: .utf8) {
                        multipartData.append(MultipartFormData(provider: .data(idData), name: "rooms[\(roomIndex)][bedTypes][\(bedIndex)][id]"))
                    }
                    multipartData.append(MultipartFormData(provider: .data(String(bedType.quantity ?? "").data(using: .utf8)!), name: "rooms[\(roomIndex)][bedTypes][\(bedIndex)][quantity]"))
                }

                // Room Images
//                for (imageIndex, imageData) in room.images?.enumerated() ?? [].enumerated() {
//                    multipartData.append(
//                        MultipartFormData(
//                            provider: .data(imageData),
//                            name: "rooms[\(roomIndex)][images][\(imageIndex)]",
//                            fileName: "room_image_\(roomIndex)_\(imageIndex).jpg",
//                            mimeType: "image/jpeg"
//                        )
//                    )
//                }
                
                if !isEdit {
                    for (imageIndex, imageData) in room.images?.enumerated() ?? [].enumerated() {
                        multipartData.append(
                            MultipartFormData(
                                provider: .data(imageData),
                                name: "rooms[\(roomIndex)][images][\(imageIndex)]",
                                fileName: "room_image_\(roomIndex)_\(imageIndex).jpg",
                                mimeType: "image/jpeg"
                            )
                        )
                    }
                }
            }
        }
            print("Multipart Data: \(multipartData)")
        
        return multipartData
    }
   
}
