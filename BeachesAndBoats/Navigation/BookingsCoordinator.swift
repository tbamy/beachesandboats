//
//  BookingsCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit


class BookingsCoordinator: Coordinator{
    override func start() {
        let vc: BookingsView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Bookings", image: Assets.bookings_menu.image, tag: 2)
        vc.tabBarItem.accessibilityIdentifier = "booking"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoBoatBookingDetails(booking: BoatBookingsPast, upcomingBookings: Bool = false){
        let vc: BoatBookingDetailsView = .fromNib()
        vc.coordinator = self
        vc.booking = booking
//        vc.boatDetails = boatDetails
        vc.isupcomingBooking = upcomingBookings
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBeachHouseBookingDetails(booking: BeachHouseBookingsPast, upcomingBookings: Bool = false){
        let vc: BeachBookingDetailsView = .fromNib()
        vc.coordinator = self
        vc.booking = booking
//        vc.beachDetails = beachDetails
        vc.isupcomingBooking = upcomingBookings
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = Dashboard()
        }

    }
    
    func gotoAllPhotos(images: [String]){
        let coordinator = ExploreCoordinator(navigationController: self.navigationController)
        coordinator.gotoAllPhotos(images: images)
    }
    
    func gotoBeachDetails(id: String){
        let coordinator = ExploreCoordinator(navigationController: self.navigationController)
        coordinator.gotoBeachDetails(id: id)
    }
    
    func gotoBoatDetails(id: String){
        let coordinator = ExploreCoordinator(navigationController: self.navigationController)
        coordinator.gotoBoatDetails(id: id)
    }
    
//    func gotoChat(otherUser: String, conversationId: String){
//        let coordinator = ExploreCoordinator(navigationController: self.navigationController)
//        coordinator.gotoChat(otherUser: otherUser, conversationId: conversationId)
//    }
    
    func gotoChat(bookingId: String,otherUser: String, conversationId: String, propertyType:String){
        let coordinator = MessagesCoordinator(navigationController: self.navigationController)
//        coordinator.gotoChat(otherUser: otherUser, conversationId: conversationId)
        coordinator.gotoChat(bookingId: bookingId, otherUser: otherUser, conversationId: conversationId, propertyType: propertyType)
    }
    
}

