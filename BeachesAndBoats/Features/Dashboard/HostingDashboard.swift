//
//  HostingDashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

//import Foundation
//import UIKit
//
//class HostingDashboard: UITabBarController {
//    
//    private let middleButton = UIButton()
//    
//    private var coordinator: AccountCoordinator?
//
//
//    override func viewDidLoad() {
//        LoadingModal.dismiss()
//        super.viewDidLoad()
//        
//        setupTabBar()
//        setupMiddleButton()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        // Ensure proper button positioning after view layout
//        positionMiddleButton()
//    }
//
//    private func setupTabBar() {
//        tabBar.backgroundColor = .white
//        tabBar.barTintColor = .white
//        tabBar.tintColor = .beachBlue // For selected item color
//        tabBar.unselectedItemTintColor = .gray // For unselected items
//        tabBar.isTranslucent = false
//        
//        // Set up each tab item
////        let homeTab = ListingDashboard()
////        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
////        
////        let messagesVC = UIViewController()
////        messagesVC.tabBarItem = UITabBarItem(title: "Listings", image: UIImage(systemName: "message"), tag: 1)
////        
////        let earningsVC = UIViewController()
////        earningsVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "wallet.pass"), tag: 2)
////        
////        let menuVC = UIViewController()
////        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "line.horizontal.3"), tag: 3)
//        
////        viewControllers = [homeVC, messagesVC, UIViewController(), earningsVC, menuVC]
//        viewControllers = [homeTab(), listingTab(), UIViewController(), messagesTab(), menuTab()]
//    }
//    
//    private func setupMiddleButton() {
//            // Configure button appearance
//            middleButton.frame.size = CGSize(width: 64, height: 64)
//            middleButton.layer.cornerRadius = 32
//            middleButton.backgroundColor = .B_B
//            middleButton.isUserInteractionEnabled = true
//        middleButton.isEnabled = true
//            
//            if let user = UserSession.shared.userDetails, let userRoles = user.roles {
//                let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
//                let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
//                
//                let hostRoleStrings = hostRoles.map { $0.rawValue }
//                let hasHostRole = userRoles.contains { hostRoleStrings.contains($0) }
//                
//                let serviceRoleStrings = serviceRoles.map { $0.rawValue }
//                let hasServiceRole = userRoles.contains { serviceRoleStrings.contains($0) }
//                
//                if hasHostRole {
//                    middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
//                    middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
//                    middleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hostBtnTapped)))
//                } else if hasServiceRole {
//                    middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
//                    middleButton.addTarget(self, action: #selector(serviceBtnTapped), for: .touchUpInside)
//                    middleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(serviceBtnTapped)))
//                }else{
//                    middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
//                    middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
//                    middleButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hostBtnTapped)))
//                }
//            }
//            
//            middleButton.tintColor = .white
//            
//            // Add shadow
//            middleButton.layer.shadowColor = UIColor.black.cgColor
//            middleButton.layer.shadowOpacity = 0.3
//            middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
//            middleButton.layer.shadowRadius = 10
//            
//            // Create coordinator for button actions
//            let navController = BaseNavigationController()
//            coordinator = AccountCoordinator(navigationController: navController)
//            
//            // Add button to view (not to tabBar)
//            tabBar.addSubview(middleButton)
//            tabBar.bringSubviewToFront(middleButton)
//        }
//    
//    private func positionMiddleButton() {
//        middleButton.center = CGPoint(
//            x: tabBar.bounds.midX,
//            y: tabBar.bounds.minY - 10 // Adjust to sit slightly above the tab bar
//        )
//    }
//
//    
////    private func positionMiddleButton() {
////        let centerX = tabBar.bounds.midX
////        let centerY = tabBar.bounds.minY - 10
////        
////        middleButton.center = CGPoint(x: centerX, y: centerY)
////    }
//    
//    @objc func hostBtnTapped() {
//        print("Host button tapped")
//
//        guard let navController = selectedViewController as? UINavigationController else {
//            print("No navigation controller found")
//            return
//        }
//        navController.delegate = self
//        let coordinator = AccountCoordinator(navigationController: navController)
//        coordinator.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
//    }
//
//    @objc func serviceBtnTapped() {
//        print("Service button tapped")
//
//        guard let navController = selectedViewController as? UINavigationController else {
//            print("No navigation controller found")
//            return
//        }
//        navController.delegate = self
//
//        let coordinator = AccountCoordinator(navigationController: navController)
//        coordinator.gotoSelectServiceType()
//    }
//
//        
////    @objc func hostBtnTapped() {
////        print("Host button tapped")
////        let coordinator = AccountCoordinator(navigationController: self.navigationController)
////        coordinator.gotoSelectPropertyTypePrimaryHost(tag: 1, type: .primaryHost)
////    }
////        
////    @objc func serviceBtnTapped() {
////        print("Service button tapped")
////        let coordinator = AccountCoordinator(navigationController: self.navigationController)
////        coordinator.gotoSelectServiceType()
////    }
//    
//    func wrapInNavigationController(_ viewController: UIViewController) -> BaseNavigationController {
//        return BaseNavigationController(rootViewController: viewController)
//    }
//    
//    func homeTab() -> UINavigationController {
//        let navController = BaseNavigationController()
//        let coordinator = HostingHouseAndBoatHomeCoordinator(navigationController: navController, completion: nil)
//        coordinator.start()
//        return navController
//    }
//    
//    func listingTab() -> UINavigationController {
//        let navController = BaseNavigationController()
//        let coordinator = HostingHouseAndBoatListingCoordinator(navigationController: navController, completion: nil)
//        coordinator.start()
//        return navController
//    }
//      
//    func messagesTab() -> UINavigationController {
//        let navController = BaseNavigationController()
//        let coordinator = MessagesCoordinator(navigationController: navController, completion: nil)
//        coordinator.start()
//        return navController
//    }
//    
//    func menuTab() -> UINavigationController {
//        let navController = BaseNavigationController()
//        let coordinator = HostingServiceMenuCoordinator(navigationController: navController, completion: nil)
//        coordinator.isComingFromHostingSideHouseAndBoat = true
//        coordinator.start()
//        return navController
//    }
//
////    private func setupMiddleButton() {
////        middleButton.frame.size = CGSize(width: 71, height: 71)
////        middleButton.layer.cornerRadius = 50
////        middleButton.backgroundColor = .systemBlue
////        middleButton.setImage(UIImage(systemName: "pencil"), for: .normal)
////        middleButton.tintColor = .white
////        
////        middleButton.layer.shadowColor = UIColor.black.cgColor
////        middleButton.layer.shadowOpacity = 0.3
////        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
////        middleButton.layer.shadowRadius = 10
////        
////        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
////        
////        tabBar.addSubview(middleButton)
////        
////        // Position the button in the center of the tab bar
////        middleButton.translatesAutoresizingMaskIntoConstraints = false
////        NSLayoutConstraint.activate([
////            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
////            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16) // Adjust as needed
////        ])
////    }
////
////    @objc private func middleButtonTapped() {
////        // Handle middle button action
////        let composeVC = UIViewController() // Replace with your desired view controller
////        composeVC.view.backgroundColor = .white
////        composeVC.modalPresentationStyle = .fullScreen
////        present(composeVC, animated: true, completion: nil)
////    }
//}
//
//extension HostingDashboard: UINavigationControllerDelegate {
//    func navigationController(_ navigationController: UINavigationController,
//                              willShow viewController: UIViewController,
//                              animated: Bool) {
//        let isRootViewController = navigationController.viewControllers.count == 1
//        middleButton.isHidden = !isRootViewController
//
//        if isRootViewController {
//            DispatchQueue.main.async {
//                self.positionMiddleButton()
//            }
//        }
//    }
//}
//


import Foundation
import UIKit

class HostingDashboard: UITabBarController {
    
    private let middleButton = UIButton()
    
    private var coordinator: AccountCoordinator?

    override func viewDidLoad() {
        LoadingModal.dismiss()
        super.viewDidLoad()
        
        setupTabBar()
        setupMiddleButton()
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
        
        viewControllers = [homeTab(), listingTab(), UIViewController(), messagesTab(), menuTab()]
    }
    
    private func setupMiddleButton() {
        // Configure button appearance
        middleButton.frame.size = CGSize(width: 64, height: 64)
        middleButton.layer.cornerRadius = 32
        middleButton.backgroundColor = .B_B
        middleButton.isUserInteractionEnabled = true
        middleButton.isEnabled = true
        
        if let user = UserSession.shared.userDetails, let userRoles = user.roles {
            let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
            let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
            
            let hostRoleStrings = hostRoles.map { $0.rawValue }
            let hasHostRole = userRoles.contains { hostRoleStrings.contains($0) }
            
            let serviceRoleStrings = serviceRoles.map { $0.rawValue }
            let hasServiceRole = userRoles.contains { serviceRoleStrings.contains($0) }
            
            if hasHostRole {
                middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
                // FIXED: Remove duplicate gesture recognizer and target
                middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
            } else if hasServiceRole {
                middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
                // FIXED: Remove duplicate gesture recognizer and target
                middleButton.addTarget(self, action: #selector(serviceBtnTapped), for: .touchUpInside)
            } else {
                middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
                // FIXED: Remove duplicate gesture recognizer and target
                middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
            }
        }
        
        middleButton.tintColor = .white
        
        // Add shadow
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        middleButton.layer.shadowRadius = 10
        
        // FIXED: Create coordinator only once and store it as instance variable
        let navController = BaseNavigationController()
        coordinator = AccountCoordinator(navigationController: navController)
        
        // Add button to view (not to tabBar)
//        tabBar.addSubview(middleButton)
        view.addSubview(middleButton)
        tabBar.bringSubviewToFront(middleButton)
    }
    
    private func positionMiddleButton() {
        
        middleButton.center = CGPoint(
                x: tabBar.center.x,
                y: view.bounds.height - tabBar.frame.height / 2 - 30 // fine-tune this offset
            )
//        middleButton.center = CGPoint(
//            x: tabBar.bounds.midX,
//            y: tabBar.bounds.minY - 10 // Adjust to sit slightly above the tab bar
//        )
    }
    
    @objc func hostBtnTapped() {
        print("Host button tapped")
        
        // FIXED: Check if button is hidden first
        if middleButton.isHidden {
            print("Button is hidden, ignoring tap")
            return
        }
        
        // FIXED: Use the current selected navigation controller
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found")
            // FIXED: Fallback to creating a new navigation controller if needed
            let newNavController = BaseNavigationController()
            let coordinator = AccountCoordinator(navigationController: newNavController)
            coordinator.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
            present(newNavController, animated: true)
            return
        }
        
        navController.delegate = self
        let coordinator = AccountCoordinator(navigationController: navController)
        coordinator.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
    }

    @objc func serviceBtnTapped() {
        print("Service button tapped")
        
        // FIXED: Check if button is hidden first
        if middleButton.isHidden {
            print("Button is hidden, ignoring tap")
            return
        }
        
        // FIXED: Use the current selected navigation controller
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found")
            // FIXED: Fallback to creating a new navigation controller if needed
            let newNavController = BaseNavigationController()
            let coordinator = AccountCoordinator(navigationController: newNavController)
            coordinator.gotoSelectServiceType()
            present(newNavController, animated: true)
            return
        }

        navController.delegate = self
        let coordinator = AccountCoordinator(navigationController: navController)
        coordinator.gotoSelectServiceType()
    }
    
    func wrapInNavigationController(_ viewController: UIViewController) -> BaseNavigationController {
        return BaseNavigationController(rootViewController: viewController)
    }
    
    func homeTab() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = HostingHouseAndBoatHomeCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func listingTab() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = HostingHouseAndBoatListingCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
      
    func messagesTab() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = MessagesCoordinator(navigationController: navController, completion: nil)
        coordinator.start()
        return navController
    }
    
    func menuTab() -> UINavigationController {
        let navController = BaseNavigationController()
        let coordinator = HostingServiceMenuCoordinator(navigationController: navController, completion: nil)
        coordinator.isComingFromHostingSideHouseAndBoat = true
        coordinator.start()
        return navController
    }
}

extension HostingDashboard: UINavigationControllerDelegate {
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
