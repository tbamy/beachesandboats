//
//  HostingDashboard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/11/2024.
//

import Foundation

import UIKit

class HostingDashboard: UITabBarController {
    
    private let middleButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        setupMiddleButton()
    }

    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = .beachBlue // For selected item color
        tabBar.unselectedItemTintColor = .gray // For unselected items
        tabBar.isTranslucent = false
        
        // Set up each tab item
        let homeVC = UIViewController()
        homeVC.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let messagesVC = UIViewController()
        messagesVC.tabBarItem = UITabBarItem(title: "Listings", image: UIImage(systemName: "message"), tag: 1)
        
        let earningsVC = UIViewController()
        earningsVC.tabBarItem = UITabBarItem(title: "Messages", image: UIImage(systemName: "wallet.pass"), tag: 2)
        
        let menuVC = UIViewController()
        menuVC.tabBarItem = UITabBarItem(title: "Menu", image: UIImage(systemName: "line.horizontal.3"), tag: 3)
        
        viewControllers = [homeVC, messagesVC, UIViewController(), earningsVC, menuVC]
    }

    private func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 71, height: 71)
        middleButton.layer.cornerRadius = 50
        middleButton.backgroundColor = .systemBlue
        middleButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        middleButton.tintColor = .white
        
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        middleButton.layer.shadowRadius = 10
        
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        
        tabBar.addSubview(middleButton)
        
        // Position the button in the center of the tab bar
        middleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            middleButton.centerXAnchor.constraint(equalTo: tabBar.centerXAnchor),
            middleButton.centerYAnchor.constraint(equalTo: tabBar.topAnchor, constant: -16) // Adjust as needed
        ])
    }

    @objc private func middleButtonTapped() {
        // Handle middle button action
        let composeVC = UIViewController() // Replace with your desired view controller
        composeVC.view.backgroundColor = .white
        composeVC.modalPresentationStyle = .fullScreen
        present(composeVC, animated: true, completion: nil)
    }
}
