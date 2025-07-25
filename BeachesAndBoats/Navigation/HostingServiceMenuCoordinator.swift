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
    
    func gotoEditPropertyNameView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditPropertyNameView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAddressView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditPropertyAddressView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAvailableDatesView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditPropertyAvailableDatesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditPropertyAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditPropertyAdditionalAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditPropertyAdditionalAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditAboutYouLanguageView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditAboutYouLanguageView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditAboutYouDescriptionView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditAboutYouDescriptionView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditHouseRulesView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditHouseRulesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditCheckInAndOutRulesView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditCheckInAndOutRulesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomsListView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditRoomsListView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditListRoomsView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?) {
        let vc: EditListRoomsView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.room = room
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomAmenitiesView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?) {
        let vc: EditRoomAmenitiesView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.room = room
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomPriceView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?) {
        let vc: EditRoomPriceView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.room = room
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditRoomPricePerDayView(beachData: BeachDatas?, request: CreateBeachListingRequest?, room: String?) {
        let vc: EditRoomPricePerDayView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.room = room
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditEntireApartmentPriceView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditEntireApartmentPriceView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEditEntireApartmentPricePerDayView(beachData: BeachDatas?, request: CreateBeachListingRequest?) {
        let vc: EditEntireApartmentPricePerDayView = .fromNib()
        vc.createBeachListing = request
        vc.beachData = beachData
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
 
}
