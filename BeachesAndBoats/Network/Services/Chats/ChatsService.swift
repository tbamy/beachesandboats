//
//  ChatsService.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import Foundation

protocol ChatsService {
    func getUpcomingBooking(completion: @escaping(Result<ServiceReservations, ErrorResponse>) -> Void)
    
}
