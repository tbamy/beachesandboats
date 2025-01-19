//
//  BookingTarget.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 21/12/2024.
//

import Foundation
import Moya

enum BookingTarget{
    case GetBookingCategories(page: String)
    case AddOrUpdateReview
    case AddOrUpdateFavourite
    case CreateBeachHouseBooking(CreateBeachHouseBookingRequest)
    case CreateBoatBooking(CreateBoatBookingRequest)
    case BookingConfiguration
    case AllDishes
    case FindChefByDishes
    case BookServiceProvider
    case UpdateProviderBookingDate
    case FindBouncers
    case FindDj
}

extension BookingTarget: BaseTarget{
    var path: String {
        switch self {
        
        case .GetBookingCategories(page: let page):
            return Urls.getBookingCategories.rawValue
        case .AddOrUpdateReview:
            return Urls.addOrUpdateReview.rawValue
        case .AddOrUpdateFavourite:
            return Urls.addOrUpdateFavourite.rawValue
        case .CreateBeachHouseBooking:
            return Urls.createBeachHouseBooking.rawValue
        case .CreateBoatBooking:
            return Urls.createBoatBooking.rawValue
        case .BookingConfiguration:
            return Urls.bookingConfiguration.rawValue
        case .AllDishes:
            return Urls.allDishes.rawValue
        case .FindChefByDishes:
            return Urls.findChefByDishes.rawValue
        case .BookServiceProvider:
            return Urls.bookServiceProvider.rawValue
        case .UpdateProviderBookingDate:
            return Urls.updateProviderBookingDate.rawValue
        case .FindBouncers:
            return Urls.findBouncers.rawValue
        case .FindDj:
            return Urls.findDj.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        
        case .GetBookingCategories(page: let page):
            return .get
        case .AddOrUpdateReview:
            return .post
        case .AddOrUpdateFavourite:
            return .post
        case .CreateBeachHouseBooking(_):
            return .post
        case .CreateBoatBooking(_):
            return .post
        case .BookingConfiguration:
            return .get
        case .AllDishes:
            return .get
        case .FindChefByDishes:
            return .get
        case .BookServiceProvider:
            return .post
        case .UpdateProviderBookingDate:
            return .post
        case .FindBouncers:
            return .get
        case .FindDj:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        
        case .GetBookingCategories(page: let page):
            return .requestParameters(
                parameters: ["page": page],
                encoding: URLEncoding.queryString
            )
        case .AddOrUpdateReview:
            return .requestPlain
        case .AddOrUpdateFavourite:
            return .requestPlain
        case .CreateBeachHouseBooking(let request):
            return .requestJSONEncodable(request)
        case .CreateBoatBooking(let request):
            return .requestJSONEncodable(request)
        case .BookingConfiguration:
            return .requestPlain
        case .AllDishes:
            return .requestPlain
        case .FindChefByDishes:
            return .requestPlain
        case .BookServiceProvider:
            return .requestPlain
        case .UpdateProviderBookingDate:
            return .requestPlain
        case .FindBouncers:
            return .requestPlain
        case .FindDj:
            return .requestPlain
        }
    }
    
    
}

