//
//  HostingService.swift
//  BeachesAndBoats
//
//  Created by WEMA on 30/12/2024.
//

import Foundation

protocol HostingService {
    func getUpcomingBooking(completion: @escaping(Result<ServiceReservations, ErrorResponse>) -> Void)
}
