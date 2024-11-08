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
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
    
}

