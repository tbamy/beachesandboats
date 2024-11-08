//
//  BookingsCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit


class BookingsCoordinator: Coordinator{
    override func start() {
        let vc: BookingsView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Bookings", image: Assets.bookings_menu.image, tag: 2)
        vc.tabBarItem.accessibilityIdentifier = "booking"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = Dashboard()
        }

    }
}

