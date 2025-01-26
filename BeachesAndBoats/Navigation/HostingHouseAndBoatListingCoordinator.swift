//
//  HostingHouseAndBoatListingCoordinator.swift
//  BeachesAndBoats
//
//  Created by WEMA on 10/01/2025.
//

import Foundation
import UIKit

class HostingHouseAndBoatListingCoordinator: Coordinator {
    override func start() {
        let vc: HostListingVC = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Listings", image: UIImage(named: "listingIcon"), tag: 1)
        vc.tabBarItem.accessibilityIdentifier = "Listings"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func presentSortView() {
        let vc: HostListingSortView = .fromNib()
        vc.coordinator = self
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.modalPresentationStyle = .fullScreen
        present(viewController: navigationVC)
    }
}
