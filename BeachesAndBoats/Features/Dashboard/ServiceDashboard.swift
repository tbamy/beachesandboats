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
    private var coordinator: AccountCoordinator?
    
    // ADDED: KVO observer for tab bar visibility changes
    private var tabBarObserver: NSKeyValueObservation?
    
    private func setupTabBarObserver() {
        // Observe tab bar hidden property changes
        tabBarObserver = tabBar.observe(\.isHidden, options: [.new, .old]) { [weak self] _, change in
            DispatchQueue.main.async {
                self?.updateMiddleButtonVisibility()
                self?.positionMiddleButton()
            }
        }
    }
    
    deinit {
        tabBarObserver?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LoadingModal.dismiss()
        
        setupTabBar()
        setupMiddleButton()
        setupTabBarObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Add small delay to ensure tab bar state is properly updated
        DispatchQueue.main.async {
            self.updateMiddleButtonVisibility()
            self.positionMiddleButton()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Double-check visibility after view appears
        updateMiddleButtonVisibility()
        positionMiddleButton()
    }
    
    // ADDED: Override viewWillDisappear to ensure proper cleanup
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide button when tab bar controller is about to disappear
        middleButton.isHidden = true
    }
    
    // ADDED: Check for tab bar visibility changes in viewWillTransition
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            // Animation block
        }) { _ in
            // Completion block
            self.updateMiddleButtonVisibility()
            self.positionMiddleButton()
        }
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
        
        viewControllers = [ServiceHomeController(), MessageController(), UIViewController(), EarningController(), MenuController()]
        
        // ADDED: Set up all navigation controllers as delegates
        setupNavigationDelegates()
    }
    
    // ADDED: Set up navigation controller delegates for all tabs
    private func setupNavigationDelegates() {
        for viewController in viewControllers ?? [] {
            if let navController = viewController as? UINavigationController {
                navController.delegate = self
            }
        }
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
                middleButton.addTarget(self, action: #selector(hostBtnTapped), for: .touchUpInside)
            } else if hasServiceRole {
                middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
                middleButton.addTarget(self, action: #selector(serviceBtnTapped), for: .touchUpInside)
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
        
        // Add button to the main view, not tabBar
        view.addSubview(middleButton)
        view.bringSubviewToFront(middleButton)
    }
    
    private func positionMiddleButton() {
        // Check tab bar visibility more thoroughly
        let tabBarIsVisible = !tabBar.isHidden && tabBar.alpha > 0
        
        guard tabBarIsVisible else {
            middleButton.isHidden = true
            return
        }
        
        // Calculate position relative to tab bar bounds
        let tabBarFrame = tabBar.frame
        middleButton.center = CGPoint(
            x: view.bounds.midX,
            y: tabBarFrame.minY - 10 // Position slightly above tab bar
        )
        
        // Ensure button stays on top after positioning
        view.bringSubviewToFront(middleButton)
    }
    
    // IMPROVED: Method to update button visibility based on tab bar state
    private func updateMiddleButtonVisibility() {
        // Check multiple conditions for tab bar visibility
        let tabBarIsVisible = !tabBar.isHidden && tabBar.alpha > 0
        let isRootLevel = isRootViewControllerVisible()
        
        let shouldShowButton = tabBarIsVisible && isRootLevel
        
        print("Tab bar visible: \(tabBarIsVisible), Root level: \(isRootLevel), Should show: \(shouldShowButton)")
        
        if shouldShowButton {
            middleButton.isHidden = false
            view.bringSubviewToFront(middleButton)
        } else {
            middleButton.isHidden = true
        }
    }
    
    // Helper method to check if we're on a root view controller
    private func isRootViewControllerVisible() -> Bool {
        guard let selectedNav = selectedViewController as? UINavigationController else {
            return true // If not a nav controller, assume it's root level
        }
        return selectedNav.viewControllers.count == 1
    }
    
    // ADDED: Override selectedViewController to detect tab changes
    override var selectedViewController: UIViewController? {
        didSet {
            DispatchQueue.main.async {
                self.updateMiddleButtonVisibility()
                self.positionMiddleButton()
            }
        }
    }
    
    // ADDED: Override selectedIndex to detect tab changes
    override var selectedIndex: Int {
        didSet {
            DispatchQueue.main.async {
                self.updateMiddleButtonVisibility()
                self.positionMiddleButton()
            }
        }
    }
    
    @objc func hostBtnTapped() {
        print("Host button tapped")
        
        if middleButton.isHidden {
            print("Button is hidden, ignoring tap")
            return
        }
        
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found")
            let newNavController = BaseNavigationController()
            let coordinator = AccountCoordinator(navigationController: newNavController)
            coordinator.gotoSelectPropertyTypePrimaryHost(tag: 1, type: .primaryHost)
            present(newNavController, animated: true)
            return
        }
        
        navController.delegate = self
        let coordinator = AccountCoordinator(navigationController: navController)
        coordinator.gotoSelectPropertyTypePrimaryHost(tag: 1, type: .primaryHost)
    }

    @objc func serviceBtnTapped() {
        print("Service button tapped")
        
        if middleButton.isHidden {
            print("Button is hidden, ignoring tap")
            return
        }
        
        guard let navController = selectedViewController as? UINavigationController else {
            print("No navigation controller found")
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
}

extension ServiceDashboard: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        let isRootViewController = navigationController.viewControllers.count == 1
        
        print("Navigation will show controller, stack count: \(navigationController.viewControllers.count), isRoot: \(isRootViewController)")
        
        // IMPROVED: Only update if this is the currently selected navigation controller
        guard navigationController == selectedViewController else {
            return
        }
        
        // Set button visibility immediately based on navigation stack
        if isRootViewController {
            // When going back to root, show the button
            DispatchQueue.main.async {
                self.updateMiddleButtonVisibility()
                self.positionMiddleButton()
            }
        } else {
            // When navigating away from root, hide the button
            middleButton.isHidden = true
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        let isRootViewController = navigationController.viewControllers.count == 1
        
        print("Navigation did show controller, stack count: \(navigationController.viewControllers.count), isRoot: \(isRootViewController)")
        
        // IMPROVED: Only update if this is the currently selected navigation controller
        guard navigationController == selectedViewController else {
            return
        }
        
        // Double-check visibility after navigation completes
        DispatchQueue.main.async {
            self.updateMiddleButtonVisibility()
            self.positionMiddleButton()
        }
    }
}
