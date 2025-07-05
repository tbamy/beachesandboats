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
//    private let transparentButton = UIButton()
    private var coordinator: AccountCoordinator?


    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingModal.dismiss()
        
        setupTabBar()
        setupMiddleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        positionMiddleButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure proper button positioning after view layout
        positionMiddleButton()
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.barTintColor = .white
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
        let coordinator = HostingServiceHomeCoordinator(navigationController: navController, completion: nil)
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
        let coordinator = HostingServiceEarningCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func MenuController() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = HostingServiceMenuCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    private func setupMiddleButton() {
        
        // Configure button appearance
        middleButton.frame.size = CGSize(width: 64, height: 64)
        middleButton.layer.cornerRadius = 32
        middleButton.backgroundColor = .B_B
        
//        transparentButton.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
//        transparentButton.backgroundColor = .clear
        
        if let user = UserSession.shared.userDetails, let userRoles = user.roles {
            let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
            let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
            
            let hostRoleStrings = hostRoles.map { $0.rawValue }
            let hasHostRole = userRoles.contains { hostRoleStrings.contains($0) }
            
            let serviceRoleStrings = serviceRoles.map { $0.rawValue }
            let hasServiceRole = userRoles.contains { serviceRoleStrings.contains($0) }
            
            if hasHostRole {
                middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
                middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
//                transparentButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
                
            } else if hasServiceRole {
                middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
                middleButton.addTarget(self, action: #selector(serviceBtnTapped), for: .touchUpInside)
//                transparentButton.addTarget(self, action: #selector(serviceBtnTapped), for: .touchUpInside)
            }
        }
        
        middleButton.tintColor = .white
        
        // Add shadow
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        middleButton.layer.shadowRadius = 10
        
        // Create coordinator for button actions
        let navController = BaseNavigationController()
        coordinator = AccountCoordinator(navigationController: navController)
        
        // Add button to view (not to tabBar)
        tabBar.addSubview(middleButton)
        tabBar.bringSubviewToFront(middleButton)
    }
    

    private func positionMiddleButton() {
        let centerX = tabBar.bounds.midX
        let centerY = tabBar.bounds.minY - 10
        
        middleButton.center = CGPoint(x: centerX, y: centerY)
//        transparentButton.center = middleButton.center
    }
    
    @objc func hostBtnTapped() {
        print("Host button tapped")
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found for selected tab")
            return
        }
        navController.delegate = self
        
        let coordinator = AccountCoordinator(navigationController: navController)
        coordinator.gotoSelectPropertyTypePrimaryHost(tag: 1, type: .primaryHost)
    }

    @objc func serviceBtnTapped() {
        print("Service button tapped")
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found for selected tab")
            return
        }
        navController.delegate = self

        let coordinator = AccountCoordinator(navigationController: navController)
        coordinator.gotoSelectServiceType()
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

extension ServiceDashboard: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let isRootViewController = navigationController.viewControllers.count == 1
        middleButton.isHidden = !isRootViewController

        if isRootViewController {
            DispatchQueue.main.async {
                self.positionMiddleButton()
            }
        }
    }
}


