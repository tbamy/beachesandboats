//
//  ListingTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import Foundation
import Moya

enum ListingTarget {
    case BeachData
    case BoatData
//    case CreateBeachListing(data: [String: Any], file: Data, fileName: String)
    case CreateBeachListing(data: CreateBeachListingRequest)
    case CreateServiceListing(data: CreateServiceListingRequest)
    case CreateBoatListing(data: CreateBoatListingRequest)
    case ChefDishes
}

extension ListingTarget: BaseTarget {
    var path: String {
        switch self {
        case .BeachData:
            return Urls.beachData.rawValue
        case .CreateBeachListing:
            return Urls.createBeach.rawValue // Assuming you have a submit form URL in Urls
        case .ChefDishes:
            return Urls.chefDishes.rawValue
        case .BoatData:
            return Urls.boatData.rawValue
        case .CreateServiceListing(data: let data):
            return Urls.createService.rawValue
        case .CreateBoatListing(data: let data):
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
        case .BeachData, .ChefDishes, .BoatData:
            return .requestPlain
        case .CreateBeachListing(let data):
            var multipartData: [MultipartFormData] = []
            
            // Append standard fields as form data
            let fields: [String: Any] = [
                "category_id": data.category_id,
                "sub_cat_id": data.sub_cat_id,
                "guest_booking_id": data.guest_booking_id,
                "name": data.name,
                "description": data.description,
                "country": data.country,
                "state": data.state,
                "city": data.city,
                "street_address": data.street_address,
                "from_when": data.from_when,
                "to_when": data.to_when,
                "brief_introduction": data.brief_introduction,
                "check_in_start": data.check_in_start,
                "check_in_end": data.check_in_end,
                "check_out_start": data.check_out_start,
                "check_out_end": data.check_out_end,
                "full_apartment_cost": data.full_apartment_cost,
                "full_apartment_discount": data.full_apartment_discount,
                "full_apartment_amount_to_earn": data.full_apartment_amount_to_earn
            ]
            
            for (key, value) in fields {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }

            // Handle array fields (amenities, preferred_languages, house_rules)
            for (index, item) in data.amenities.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(item.data(using: .utf8)!), name: "amenities[\(index)]"))
            }
            for (index, item) in data.preferred_languages.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(item.data(using: .utf8)!), name: "preferred_languages[\(index)]"))
            }
            for (index, item) in data.house_rules.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(item.data(using: .utf8)!), name: "house_rules[\(index)]"))
            }
            
            // Handle roominfo array with nested RoomData objects
            for (roomIndex, room) in data.roominfo.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(String(room.id).data(using: .utf8)!), name: "roominfo[\(roomIndex)][id]"))
                multipartData.append(MultipartFormData(provider: .data(room.name.data(using: .utf8)!), name: "roominfo[\(roomIndex)][name]"))
                multipartData.append(MultipartFormData(provider: .data(room.description.data(using: .utf8)!), name: "roominfo[\(roomIndex)][description]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.price_per_night).data(using: .utf8)!), name: "roominfo[\(roomIndex)][price_per_night]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.discount).data(using: .utf8)!), name: "roominfo[\(roomIndex)][discount]"))
                multipartData.append(MultipartFormData(provider: .data(String(room.amount_to_earn).data(using: .utf8)!), name: "roominfo[\(roomIndex)][amount_to_earn]"))
                multipartData.append(MultipartFormData(provider: .data(room.number_of_guests.data(using: .utf8)!), name: "roominfo[\(roomIndex)][number_of_guests]"))
                multipartData.append(MultipartFormData(provider: .data(room.number_of_rooms.data(using: .utf8)!), name: "roominfo[\(roomIndex)][number_of_rooms]"))
                multipartData.append(MultipartFormData(provider: .data(room.number_of_beds.data(using: .utf8)!), name: "roominfo[\(roomIndex)][number_of_beds]"))
                
                // Handle room amenities array
                for (amenityIndex, amenity) in room.amenities.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(amenity.data(using: .utf8)!), name: "roominfo[\(roomIndex)][amenities][\(amenityIndex)]"))
                }
                
                // Handle room images array
                for (imageIndex, imageData) in room.room_images.enumerated() {
                    multipartData.append(MultipartFormData(provider: .data(imageData), name: "roominfo[\(roomIndex)][room_images][\(imageIndex)]", fileName: "room_image_\(roomIndex)_\(imageIndex).jpg", mimeType: "image/jpeg"))
                }
            }

            return .uploadMultipart(multipartData)
            
        case .CreateServiceListing(data: let data):
            var multipartData: [MultipartFormData] = []
            
            // Append standard fields as form data
            let fields: [String: Any] = [
                "name": data.name,
                "description": data.description,
                "from_when": data.from_when,
                "to_when": data.to_when,
                "price": data.price,
                "type": data.type,
                "gender": data.gender
            ]
            
            for (key, value) in fields {
                if let stringValue = String(describing: value).data(using: .utf8) {
                    multipartData.append(MultipartFormData(provider: .data(stringValue), name: key))
                }
            }
            
            // Append profile image
            multipartData.append(MultipartFormData(provider: .data(data.profile_image), name: "profile_image", fileName: "profile_image.jpg", mimeType: "image/jpeg"))

            // Append dishes array
            for (index, dish) in data.dishes.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(dish.data(using: .utf8)!), name: "dishes[\(index)]"))
            }
            
            // Append sample images array
            for (index, imageData) in data.sample_images.enumerated() {
                multipartData.append(MultipartFormData(provider: .data(imageData), name: "sample_images[\(index)]", fileName: "sample_image_\(index).jpg", mimeType: "image/jpeg"))
            }
            
            return .uploadMultipart(multipartData)
                        
                        
        case .CreateBoatListing(data: let data):
            
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String: String]? {
        return ["Content-type": "multipart/form-data"]
    }
    
    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
    
   
}
