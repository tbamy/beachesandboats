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
    case AddOrUpdateReview(AddReviewRequest)
    case AddOrUpdateFavourite(AddFavouriteRequest)
    case CreateBeachHouseBooking(CreateBeachHouseBookingRequest)
    case CreateBoatBooking(CreateBoatBookingRequest)
    case BookingConfiguration
    case AllDishes
    case FindChefByDishes(dishIds: String)
    case BookServiceProvider
    case UpdateProviderBookingDate
    case FindBouncers(gender: String)
    case FindDj
    case PaymentCallback(reference: String)
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
        case .PaymentCallback(reference: let reference):
            return Urls.paymentCallback.rawValue
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
        case .PaymentCallback(reference: let reference):
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
        case .AddOrUpdateReview(let request):
            return .requestJSONEncodable(request)
        case .AddOrUpdateFavourite(let request):
            return .requestJSONEncodable(request)
        case .CreateBeachHouseBooking(let request):
            return .requestJSONEncodable(request)
        case .CreateBoatBooking(let request):
            return .requestJSONEncodable(request)
        case .BookingConfiguration:
            return .requestPlain
        case .AllDishes:
            return .requestPlain
        case .FindChefByDishes(let dishIds):
            return .requestParameters(
                parameters: ["dish_ids": dishIds],
                encoding: URLEncoding.queryString
            )
        case .BookServiceProvider:
            return .requestPlain
        case .UpdateProviderBookingDate:
            return .requestPlain
        case .FindBouncers(let gender):
            return .requestParameters(
                parameters: ["gender": gender],
                encoding: URLEncoding.queryString
            )
        case .FindDj:
            return .requestPlain
        case .PaymentCallback(reference: let reference):
            return .requestParameters(
                parameters: ["reference": reference],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    
}

