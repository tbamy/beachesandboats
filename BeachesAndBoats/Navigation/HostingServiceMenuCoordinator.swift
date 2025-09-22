//
//  MenuCoordinator.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import Foundation
import UIKit
class HostingServiceMenuCoordinator: Coordinator {
    
    var isComingFromHostingSideHouseAndBoat: Bool = false
    
    override func start() {
        let vc: MenuView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(named: "menuIcon"), tag: 3)
        vc.tabBarItem.accessibilityIdentifier = "Menu"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoSafetyView() {
        let vc: SafetyAndGuideView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoManageProfile() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        coordinator.gotoManageAccountView()
    }
    
    func gotoPayment() {
        let coordinator = HostingServiceEarningCoordinator(navigationController: self.navigationController)
        coordinator.gotoCountryPaymentView()
    }
    
    func gotoNotification() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        coordinator.gotoNotificationSettings()
    }
    
    func gotoLoginAndSecurity() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        coordinator.gotoLoginAndSecurityView()
    }
    
    func gotoVerifyAccountView() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        coordinator.gotoVerifyAccountView()
    }
    
    func gotoContactSupport() {
        let coordinator = AccountCoordinator(navigationController: self.navigationController)
        coordinator.gotoContactSupportView()
    }

    
    func gotoEarningView() {
        if isComingFromHostingSideHouseAndBoat {
            let coordinator = HostingServiceEarningCoordinator(navigationController: self.navigationController)
            coordinator.isComingFromHostingSideHouseAndBoat = true
            coordinator.start()
        } else {
            guard let tabBarController = self.navigationController?.tabBarController,
                  let tabs = tabBarController.viewControllers else {
                print("TabBarController or its view controllers are nil")
                return
            }
            
            // Find the index of the tab with the "Earnings" identifier
            if let earningTabIndex = tabs.firstIndex(where: {
                $0.tabBarItem.accessibilityIdentifier == "Earnings"
            }) {
                tabBarController.selectedIndex = earningTabIndex
            } else {
                print("Earnings tab not found")
            }
        }
       
    }
    
    func goToHomeDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = Dashboard()
        }
    }


    //MARK: - Edit Property
    
    
    func gotoEditPropertiesListView() {
        let vc: EditPropertiesListView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBeachHouseOptionsView(id: String?) {
        let vc: EditBeachHouseOptionsView = .fromNib()
        vc.coordinator = self
        vc.id = id
        push(viewController: vc)
    }
    
    func gotoEditPropertyNameView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditPropertyNameView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAddressView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditPropertyAddressView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAvailableDatesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditPropertyAvailableDatesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditPropertyAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAdditionalAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditPropertyAdditionalAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditAboutYouLanguageView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditAboutYouLanguageView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditAboutYouDescriptionView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditAboutYouDescriptionView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditHouseRulesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditHouseRulesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditHouseDetailsView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditHouseDetailsView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditCheckInAndOutRulesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditCheckInAndOutRulesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomsListView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?, details: GetBeachData?) {
        let vc: EditRoomsListView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.details = details
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditListRoomsView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?, id: String?, details: GetBeachData?) {
        let vc: EditListRoomsView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.details = details
        vc.room = room
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?, id: String?, details: GetBeachData?) {
        let vc: EditRoomAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.details = details
        vc.room = room
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomPriceView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?, id: String?, details: GetBeachData?) {
        let vc: EditRoomPriceView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.details = details
        vc.room = room
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomPricePerDayView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?, id: String?, details: GetBeachData?) {
        let vc: EditRoomPricePerDayView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.details = details
        vc.room = room
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditUploadImageView(beachData: BeachDatas?, request: CreateBeachListingRequest?, currentImages: [String], id: String?, roomId: String? = nil) {
        let vc: EditHouseUploadImageView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.currentImages = currentImages
        vc.id = id
        vc.roomId = roomId
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditEntireApartmentPriceView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditEntireApartmentPriceView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditEntireApartmentPricePerDayView(beachData: BeachDatas?, request: CreateBeachListingRequest?, id: String?) {
        let vc: EditEntireApartmentPricePerDayView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.id = id
        vc.coordinator = self
        push(viewController: vc)
    }
    
    
    func popToOptionsScreen() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers.reversed() {
                if viewController is EditBeachHouseOptionsView {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }

    
    func popToRoomsListScreen() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers.reversed() {
                if viewController is EditRoomsListView {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
    
//MARK: - Edit Boat
    
    func gotoEditBoatOptionsView(id: String?) {
        let vc: EditBoatOptionsView = .fromNib()
        vc.coordinator = self
        vc.id = id
        push(viewController: vc)
    }
    
    func gotoEditBoatTypeView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatTypeView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatNameView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatNameView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatAddressView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatAddressView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatAvailableDatesView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatAvailableDatesView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatFacilitiesView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatFacilitiesView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatAdditionalAmenitiesView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatAdditionalAmenitiesView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatAboutYouLanguageView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatAboutYouLanguageView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatAboutYouDescriptionView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatAboutYouDescriptionView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatRulesView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatRulesView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatTravelLocationView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, boatType: String?) {
        let vc: EditBoatTravelLocationView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditBoatUploadImageView(boatData: BoatDatas?, request: CreateBoatListingRequest?, id: String?, details: GetBoatData?, boatType: String?) {
        let vc: EditBoatUploadImageView = .fromNib()
        vc.createBoatListing = request
        vc.boatData = boatData
        vc.details = details
        vc.id = id
        vc.boatType = boatType
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func popToBoatOptionsScreen() {
        if let navigationController = navigationController {
            for viewController in navigationController.viewControllers.reversed() {
                if viewController is EditBoatOptionsView {
                    navigationController.popToViewController(viewController, animated: true)
                    break
                }
            }
        }
    }
 
}
