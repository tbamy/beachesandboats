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
    
    func gotoBeachDetails(id: String){
        let vc: BeachDetailsView = .fromNib()
        vc.coordinator = self
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatDetails(id: String){
        let vc: BoatDetailsView = .fromNib()
        vc.coordinator = self
        vc.id = id
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBookingRoomsListView(listing: GetBeachData, booking: CreateBeachHouseBookingRequest){
        let vc: BookingRoomsListView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRoomDetailsView(units: Int, listing: GetBeachData, booking: CreateBeachHouseBookingRequest, room: BeachRoom){
        let vc: RoomDetailsView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.room = room
        vc.units = units
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoConfirmBookingView(units: Int, listing: GetBeachData, booking: CreateBeachHouseBookingRequest, roomId: String){
        let vc: ConfirmBookingView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.roomId = roomId
        vc.units = units
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoConfirmBoatBookingView(listing: GetBoatData, booking: CreateBoatBookingRequest, destination: Destination){
        let vc: ConfirmBoatBookingView = .fromNib()
        vc.coordinator = self
        vc.listing = listing
        vc.booking = booking
        vc.selectedDestination = destination
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoConfirmServiceBookingView(paymentData: PaymentData, bookingDetail: InvoiceBookingDetails){
        let vc: ConfirmServiceBookingView = .fromNib()
        vc.coordinator = self
        vc.paymentData = paymentData
        vc.bookingDetail = bookingDetail
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
    
    func gotoMakeServicePayment(paymentData: PaymentData?, bookingDetail: InvoiceBookingDetails?){
        let vc: MakeServicePaymentView = .fromNib()
        vc.coordinator = self
//        vc.accessCode = accessCode
        vc.paymentData = paymentData
        vc.bookingDetail = bookingDetail
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
    
    func gotoFindChef(propertyType: String, bookingId: String){
        let vc: FindChefView = .fromNib()
        vc.coordinator = self
        vc.propertyType = propertyType
        vc.bookingId = bookingId
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoFindBouncer(propertyType: String, bookingId: String){
        let vc: FindBouncerView = .fromNib()
        vc.coordinator = self
        vc.propertyType = propertyType
        vc.bookingId = bookingId
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoFindDj(propertyType: String, bookingId: String){
        let vc: FindDJView = .fromNib()
        vc.coordinator = self
        vc.propertyType = propertyType
        vc.bookingId = bookingId
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRecommentdations(propertyType: String, bookingId: String, data: FindServiceProviderResponse, provider: String ){
        let vc: RecommendationsView = .fromNib()
        vc.coordinator = self
        vc.propertyType = propertyType
        vc.bookingId = bookingId
        vc.data = data
        vc.provider = provider
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoServiceProviderDetails(propertyType: String, bookingId: String, data: FindProviderResponseData, provider: String ){
        let vc: ServiceProviderDetailsView = .fromNib()
        vc.coordinator = self
        vc.propertyType = propertyType
        vc.bookingId = bookingId
        vc.data = data
        vc.provider = provider
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
//    func gotoChat(otherUser: String, conversationId: String){
//        let vc: ChatView = .fromNib()
//        vc.coordinator = self
////        vc.messages = data
//        vc.otherUser = otherUser
//        vc.conversationId = conversationId
////        vc.hidesBottomBarWhenPushed = true
//        push(viewController: vc)
//    }
    
    func gotoChat(bookingId: String,otherUser: String, conversationId: String, propertyType:String){
        let coordinator = MessagesCoordinator(navigationController: self.navigationController)
//        coordinator.gotoChat(otherUser: otherUser, conversationId: conversationId)
        coordinator.gotoChat(bookingId: bookingId, otherUser: otherUser, conversationId: conversationId, propertyType: propertyType)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
    
    func switchToBookingCoordinator() {
        let newNavController = BaseNavigationController()
        let coordinator = BookingsCoordinator(navigationController: newNavController)
        coordinator.start()

        if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
            tabBarController.viewControllers?[2] = newNavController
            tabBarController.selectedIndex = 2
        }
    }

}

