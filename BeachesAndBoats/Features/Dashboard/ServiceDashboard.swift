//
//  ServiceDashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 20/11/2024.
//

import Foundation

import UIKit

class ServiceDashboard: UITabBarController {
    
    private let middleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        
        setupTabBar()
//        setupMiddleButton()
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .beachBlue // For selected item color
        tabBar.unselectedItemTintColor = .gray // For unselected items
        tabBar.isTranslucent = false
        
//        // Set up each tab item
//        let homeVC = ServiceHostingHomeView()
//        let homeNavController = UINavigationController(rootViewController: homeVC)
//        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "homeIcon"), tag: 0)
//        
//        let messagesVC = MessagesView()
//        let messagesNavController = UINavigationController(rootViewController: messagesVC)
//        messagesVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(named: "messagesIcon"), tag: 1)
//        
//        let earningsVC = UIViewController()
//        earningsVC.tabBarItem = UITabBarItem(title: "Earnings", image: UIImage(named: "earningsIcon"), tag: 2)
//        
//        let menuVC = UIViewController()
//        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "line.horizontal.3"), tag: 3)
        
//        viewControllers = [homeVC, messagesVC, UIViewController(), earningsVC, menuVC]
        viewControllers = [ServiceHomeController(), MessageController(), UIViewController(), EarningController(), MenuController()]

    }
    
    func wrapInNavigationController(_ viewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: viewController)
    }
    
    func ServiceHomeController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = ServiceCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func MessageController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = MessagesCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
      
    func EarningController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = EarningCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func MenuController() -> UINavigationController {
        let navController = BaseNavigationController()
//        let coordinator = MessagesCoordinator(navigationController: navController, completion: nil)
//        coordinator.start()
        return navController
    }

//    private func setupMiddleButton() {
//        // Configure the middle button
//        middleButton.frame.size = CGSize(width: 64, height: 64)
//        middleButton.layer.cornerRadius = 32
//        middleButton.backgroundColor = .B_B
//        middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
//        middleButton.tintColor = .white
//        
//        // Add shadow
//        middleButton.layer.shadowColor = UIColor.black.cgColor
//        middleButton.layer.shadowOpacity = 0.3
//        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
//        middleButton.layer.shadowRadius = 10
//        
//        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
//        
//        // Add the button to the main view (not the tabBar)
//        view.addSubview(middleButton)
//        
//        // Position the button in the center of the tab bar
//        middleButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
//            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -15), // Adjust position if needed
//            middleButton.widthAnchor.constraint(equalToConstant: 64),  // Set width
//            middleButton.heightAnchor.constraint(equalToConstant: 64)  // Set height
//        ])
//                    
//    }
//
//    @objc private func middleButtonTapped() {
//        // Handle middle button action
//    }
}
