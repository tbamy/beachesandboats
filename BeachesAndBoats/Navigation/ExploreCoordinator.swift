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
    
    func gotoMakePayment(bookingResponse: BeachHouseBookingResponse){
        let vc: MakePaymentView = .fromNib()
        vc.coordinator = self
//        vc.accessCode = accessCode
        vc.bookingResponse = bookingResponse
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoMakeBoatPayment(bookingResponse: BoatBookingResponse){
        let vc: MakeBoatPaymentView = .fromNib()
        vc.coordinator = self
//        vc.accessCode = accessCode
        vc.bookingResponse = bookingResponse
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
    
    func gotoFindChef(){
        let vc: FindChefView = .fromNib()
        vc.coordinator = self
//        vc.images = images
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoFindBouncer(){
        let vc: FindBouncerView = .fromNib()
        vc.coordinator = self
//        vc.images = images
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoFindDj(){
        let vc: FindDJView = .fromNib()
        vc.coordinator = self
//        vc.images = images
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRecommentdations(data: FindServiceProviderResponse, provider: String ){
        let vc: RecommendationsView = .fromNib()
        vc.coordinator = self
        vc.data = data
        vc.provider = provider
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoServiceProviderDetails(data: FindProviderResponseData, provider: String ){
        let vc: ServiceProviderDetailsView = .fromNib()
        vc.coordinator = self
        vc.data = data
        vc.provider = provider
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChat(data: StartConversationData){
        let vc: ChatView = .fromNib()
        vc.coordinator = self
        vc.data = data
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
    
    func switchToBookingCoordinator(){
        navigationController = BaseNavigationController(rootViewController: BookingsView())
        let coordinator = BookingsCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    
}

