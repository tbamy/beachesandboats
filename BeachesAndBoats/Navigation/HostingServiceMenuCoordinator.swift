//
//  MenuCoordinator.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import Foundation
import UIKit
class HostingServiceMenuCoordinator: Coordinator {
    
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
    
    func gotoContactSupport() {
        let vc: ContactSupportView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoEarningView() {
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

    
//    func gotoEarningView() {
//        guard let tabBarController = self.navigationController?.tabBarController,
//              let tabs = tabBarController.viewControllers else {
//            print("TabBarController or its view controllers are nil")
//            return
//        }
//        
//        // Find the navigation controller for the "Earnings" tab
//        if let earningNavController = tabs.first(where: {
//            $0.tabBarItem.accessibilityIdentifier == "Earnings"
//        }) as? UINavigationController {
//            
//            // Create and push the EarningsView
//            let vc: EarningsView = .fromNib()
//            vc.tabBarItem.accessibilityIdentifier = "Earnings"
////            vc.coordinator = self
//            earningNavController.pushViewController(vc, animated: true)
//            
//            // Switch the tab to "Earnings"
//            tabBarController.selectedIndex = tabs.firstIndex(of: earningNavController) ?? 0
//        } else {
//            print("Earnings tab navigation controller not found")
//        }
//    }


}
