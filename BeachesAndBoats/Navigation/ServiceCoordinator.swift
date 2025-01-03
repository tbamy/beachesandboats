//
//  ServiceCoordinator.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import Foundation
import UIKit

class ServiceCoordinator: Coordinator {
    
    override func start() {
        let vc: ServiceHostingHomeView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), tag: 0)
        vc.tabBarItem.accessibilityIdentifier = "Home"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoServiceHostingDetailsView(data: BeachHouseBookingDetails) {
        let vc: ServiceHostingDetailsView = .fromNib()
        vc.coordinator = self
        vc.bookingServiceDetails = data
        push(viewController: vc)
    }
    
    func gotoServiceHostingDetailsView() {
        let vc: ServiceHostingDetailsView = .fromNib()
        vc.coordinator = self
//        vc.bookingServiceDetails = data
        push(viewController: vc)
    }
    
    
    func gotoMessageView() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let tabBarController = window.rootViewController as? ServiceDashboard {
            tabBarController.selectedIndex = 1
        }
    }
}
