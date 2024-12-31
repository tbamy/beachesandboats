//
//  HostingServiceImplementation.swift
//  BeachesAndBoats
//
//  Created by WEMA on 30/12/2024.
//

import Foundation
import Moya

class HostingServiceImplementation: Provider<HostingTarget>, HostingService {
    func getUpcomingBooking(completion: @escaping (Result<ServiceReservations, ErrorResponse>) -> Void) {
        provider.request(.GetHostBooking){ completion( self.handleResult(result: $0)) }
    }
}
