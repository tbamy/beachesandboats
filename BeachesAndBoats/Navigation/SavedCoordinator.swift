//
//  SavedCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit


class SavedCoordinator: Coordinator{
    override func start() {
        let vc: SavedView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Saved", image: Assets.saved_menu.image, tag: 1)
        vc.tabBarItem.accessibilityIdentifier = "saved"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
}

