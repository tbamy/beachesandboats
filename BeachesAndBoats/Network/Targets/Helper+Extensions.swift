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
            "category_id": category_id,
            "sub_cat_id": sub_cat_id,
            "guest_booking_id": guest_booking_id,
            "name": name,
            "description": description,
            "country": country,
            "state": state,
            "city": city,
            "street_address": street_address,
            "from_when": from_when,
            "to_when": to_when,
            "brief_introduction": brief_introduction,
            "check_in_start": check_in_start,
            "check_in_end": check_in_end,
            "check_out_start": check_out_start,
            "check_out_end": check_out_end,
            "full_apartment_cost": full_apartment_cost,
            "full_apartment_discount": full_apartment_discount,
            "full_apartment_amount_to_earn": full_apartment_amount_to_earn
        ]
        
        // Convert arrays to JSON-compatible strings
        dict["amenities"] = amenities.joined(separator: ",")
        dict["preferred_languages"] = preferred_languages.joined(separator: ",")
        dict["house_rules"] = house_rules.joined(separator: ",")

        // Handle nested roominfo array
        dict["roominfo"] = roominfo.map { room in
            [
                "id": room.id,
                "name": room.name,
                "description": room.description,
                "amenities": room.amenities.joined(separator: ","),
                "price_per_night": room.price_per_night,
                "discount": room.discount,
                "amount_to_earn": room.amount_to_earn,
                "number_of_guests": room.number_of_guests,
                "number_of_rooms": room.number_of_rooms,
                "number_of_beds": room.number_of_beds
            ]
        }
        
        return dict
    }
}

