//
//  HostingTarget.swift
//  BeachesAndBoats
//
//  Created by WEMA on 30/12/2024.
//

import Foundation
import Moya

enum HostingTarget{
    case GetHostBooking
}

extension HostingTarget: BaseTarget{
    var path: String {
        switch self {
        case .GetHostBooking:
            return Urls.getUpcomingBooking.rawValue
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .GetHostBooking:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .GetHostBooking:
            return .requestPlain
        }
    }
}
