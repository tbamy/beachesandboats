//
//  Helper+Extensions.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 05/11/2024.
//

import Foundation


extension CreateBeachListingRequest {
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "name": name,
            "description": description,
            "about_owner": aboutOwner,
            "check_in_from": checkInFrom,
            "check_in_to": checkInTo,
            "check_out_from": checkOutFrom,
            "check_out_to": checkOutTo,
            "category_id": categoryId,
            "sub_category_id": subCategoryId,
            "booking_type": bookingType ?? "",
            "country": country,
            "state": state,
            "street_name": streetName,
            "city": city,
            "latitude": latitude ?? 0.0,
            "longitude": longitude ?? 0.0,
            "available_from": availableFrom,
            "available_to": availableTo,
            "amenities": amenities,
            "languages": languages,
            "houserules": houseRules,
            "role_type": roleType
        ]
        
        // Convert nested rooms array to dictionaries
        dict["rooms"] = rooms.map { room in
            var roomDict: [String: Any] = [
                "name": room.name,
                "description": room.description,
                "quantity": room.quantity,
                "room_amenities": room.roomAmenities,
                "price_per_night": room.pricePerNight,
                "discount_percent": room.discountPercent,
                "has_private_bathroom": room.hasPrivateBathroom,
                "no_of_occupant": room.noOfOccupant
            ]
            
            // Convert nested bedTypes array to dictionaries
            roomDict["bedTypes"] = room.bedTypes.map { bedType in
                return [
                    "id": bedType.id,
                    "quantity": bedType.quantity
                ]
            }
            
            // Add images if available
            if let images = room.images {
                roomDict["images"] = images.map { $0.base64EncodedString() }
            }
            
            return roomDict
        }
        
        return dict
    }
}
