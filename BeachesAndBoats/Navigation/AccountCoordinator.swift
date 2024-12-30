//
//  AccountCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit

class AccountCoordinator: Coordinator{
    
    override func start() {
        let vc: ProfileView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Account", image: Assets.account_menu.image, tag: 4)
        vc.tabBarItem.accessibilityIdentifier = "account"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    //MARK: BeachHouse Listing
    
    func gotoinitialListingView(){
        let vc: InitialListingPromptView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoWhatAreYou(){
        let vc: WhatAreYouView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoSelectPropertyTypePrimaryHost(tag: Int, type: HostType){
        let vc: SelectPropertyTypePrimaryHost = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        vc.tag = tag
        vc.hostType = type
        push(viewController: vc)
    }
    
    func gotoSelectPropertyTypeSecondaryHost(){
        let vc: SelectPropertyTypeSecondaryHost = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoSelectServiceType(){
        let vc: SelectServiceType = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoSelectHouseTypeView(type: HostType){
        let vc: SelectHouseTypeView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        vc.hostType = type
        push(viewController: vc)
    }
    
    func gotoHouseTypeListView(beachData: BeachDatas, cat: String, type: HostType){
        let vc: HouseTypeListView = .fromNib()
        vc.cat = cat
        vc.beachData = beachData
        vc.hostType = type
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoHouseSizeListView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: HouseSizeListView = .fromNib()
        vc.coordinator = self
        vc.beachData = beachData
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPropertyNameView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: PropertyNameView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPropertyAddressView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: PropertyAddressView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPropertyAvailableDatesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: PropertyAvailableDatesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPropertyAmenitiesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: PropertyAmenitiesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPropertyAdditionalAmenitiesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: PropertyAdditionalAmenitiesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoAboutYouLanguageView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: AboutYouLanguageView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoAboutYouDescriptionView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: AboutYouDescriptionView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoHouseRulesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: HouseRulesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoCheckInAndOutRulesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: CheckInAndOutRulesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoListRoomsView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: ListRoomsView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRoomAmenitiesView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: RoomAmenitiesView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRoomPriceView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: RoomPriceView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoUploadImageView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: UploadImageView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoRoomsListView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: RoomsListView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoEntireApartmentPriceView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: EntireApartmentPriceView = .fromNib()
        vc.beachData = beachData
        vc.coordinator = self
        vc.createBeachListing = createBeachListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoListBeachSuccessView(beachData: BeachDatas, createBeachListingData: CreateBeachListingRequest){
        let vc: ListBeachSuccessView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    
    //MARK: Bouncer Listing
    
    func gotoBouncerInformationView(){
        let vc: BouncerInformationView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBouncerGenderView(createServiceListingData: CreateServiceListingRequest){
        let vc: BouncerGenderView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBouncerUploadProfileImageView(createServiceListingData: CreateServiceListingRequest){
        let vc: BouncerUploadProfileImageView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBouncerAvailableDatesView(createServiceListingData: CreateServiceListingRequest){
        let vc: BouncerAvailableDatesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBouncerPriceView(createServiceListingData: CreateServiceListingRequest){
        let vc: BouncerPriceVIew = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBouncerUploadImagesView(createServiceListingData: CreateServiceListingRequest){
        let vc: BouncerUploadImagesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    //MARK: Chef Listing
    
    
    func gotoChefInformationView(){
        let vc: ChefInformationView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChefUploadProfileImageView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefUploadProfileImageView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChefAvailableDatesView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefAvailableDatesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChefDishesListViewView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefDIshesListView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChefPriceView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefPriceView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoChefUploadFoodImagesView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefUploadFoodImagesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    //MARK: DJ Listing
    
    func gotoDJInformationView(){
        let vc: DJInformationVIew = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoDJUploadProfileImageView(createServiceListingData: CreateServiceListingRequest){
        let vc: DJUploadProfileImageView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoDJAvailableDatesView(createServiceListingData: CreateServiceListingRequest){
        let vc: DJAvailableDatesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoDJPriceViewView(createServiceListingData: CreateServiceListingRequest){
        let vc: ChefUploadFoodImagesView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoDJUploadInstrumentsView(createServiceListingData: CreateServiceListingRequest){
        let vc: DJUploadInstrumentsView = .fromNib()
        vc.coordinator = self
        vc.createServiceListing = createServiceListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    func gotoServiceListingSuccessView(){
        let vc: ServiceListingSuccessView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoListingSuccessView(type: Int){
        let vc: ListingSuccessView = .fromNib()
        vc.coordinator = self
        vc.type = type
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
    //MARK: Boat Listing
    
    func gotoBoatHouseTypeView(){
        let vc: BoatHouseTypeView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatNameView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatNameView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatAvailableDatesView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatAvailableDatesView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatFacilitiesView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatFacilitiesView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatAdditionalAmenitiesView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatAdditionalAmenitiesView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatAboutYouLanguageView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatAboutYouLanguageView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatAboutYouDescriptionView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatAboutYouDescriptionView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatRulesView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatRulesView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatPeopleRules(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatPeopleRules = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatAddressView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatAddressView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoTravelLocationView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: TravelLocationView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoBoatUploadImageView(boatData: BoatDatas, createBoatListingData: CreateBoatListingRequest, boatType: String){
        let vc: BoatUploadImageView = .fromNib()
        vc.boatData = boatData
        vc.boatType = boatType
        vc.coordinator = self
        vc.createBoatListing = createBoatListingData
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    
//MARK: Profile Management
    
    func gotoManageAccountView(){
        let vc: ManageAccountView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoProfilePaymentView(){
        let vc: ProfilePaymentView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoCreditCardPaymentView(){
        let vc: CreditCardPaymentView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPaypalPaymentView(){
        let vc: PaypalPaymentView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoLoginAndSecurityView(){
        let vc: LoginAndSecurityView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func goto2FASecurityView(){
        let vc: _FASecurityView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoNotificationSettings(){
        let vc: NotificationSettingsView = .fromNib()
        vc.coordinator = self
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
    
    func backToHostingDashboard() {
        navigationController = BaseNavigationController(rootViewController: HostingDashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = HostingDashboard()
        }

    }
    
    func backToServiceDashboard() {
        navigationController = BaseNavigationController(rootViewController: ServiceDashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = ServiceDashboard()
        }

    }
}
