//
//  MessagesCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 16/09/2024.
//

import Foundation
import UIKit


class MessagesCoordinator: Coordinator{
    override func start() {
        let vc: MessagesView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Messages", image: Assets.messages_menu.image, tag: 3)
        vc.tabBarItem.accessibilityIdentifier = "message"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func backToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        UIApplication.shared.windows.first?.rootViewController = Dashboard()
    }
}

