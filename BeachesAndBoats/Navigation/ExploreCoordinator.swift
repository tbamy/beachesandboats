//
//  ExploreCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit


class ExploreCoordinator: Coordinator{
    override func start() {
        let vc: HomeView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Explore", image: Assets.explore_menu.image, tag: 0)
        vc.tabBarItem.accessibilityIdentifier = "explore"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoBeachDetails(details: Listing){
        let vc: BeachDetailsView = .fromNib()
        vc.coordinator = self
        vc.beachDetails = details
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatDetails(details: Listing){
        let vc: BoatDetailsView = .fromNib()
        vc.coordinator = self
        vc.boatDetails = details
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBookingRoomsListView(listing: Listing, booking: CreateBeachHouseBookingRequest){
        let vc: BookingRoomsListView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRoomDetailsView(listing: Listing, booking: CreateBeachHouseBookingRequest, room: BookingRoom){
        let vc: RoomDetailsView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.room = room
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoConfirmBookingView(listing: Listing, booking: CreateBeachHouseBookingRequest, roomId: String){
        let vc: ConfirmBookingView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.roomId = roomId
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoMakePayment(accessCode: String){
        let vc: MakePaymentView = .fromNib()
        vc.coordinator = self
        vc.accessCode = accessCode
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoAllPhotos(images: [String]){
        let vc: AllPhotosView = .fromNib()
        vc.coordinator = self
        vc.images = images
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
    
}

