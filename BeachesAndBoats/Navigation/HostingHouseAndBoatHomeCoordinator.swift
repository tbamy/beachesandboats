//
//  HostingHouseAndBoatHomeCoordinator.swift
//  BeachesAndBoats
//
//  Created by WEMA on 10/01/2025.
//

import Foundation
import UIKit

class HostingHouseAndBoatHomeCoordinator: Coordinator {
    
    override func start() {
        let vc: ListingDashboard = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), tag: 0)
        vc.tabBarItem.accessibilityIdentifier = "Home"
        vc.coordinator = self
        push(viewController: vc)
    }
}
