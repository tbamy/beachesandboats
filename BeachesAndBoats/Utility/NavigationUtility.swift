//
//  NavigationUtility.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 14/05/2024.
//

import Foundation
import UIKit

class NavigationUtility {
    static let shared = NavigationUtility()
    private init() {}
    
    func setupNavigation(for viewController: UIViewController, backIcon: UIImage?, navigationTitle: String, rightIcon: ((UIButton) -> Void)?) {
        let backButton = UIButton(type: .custom)
        let rightButton = UIButton(type: .custom)
        
        if let backIcon = backIcon {
            backButton.setImage(backIcon.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if let rightIcon = rightIcon {
            rightIcon(rightButton)
        }
        
        backButton.addTarget(viewController, action: #selector(viewController.popView), for: .touchUpInside)
    
        let backButtonItem = UIBarButtonItem(customView: backButton)
        viewController.navigationItem.leftBarButtonItem = backButtonItem
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        viewController.navigationItem.rightBarButtonItem = rightButtonItem
        //title navigation
        let customFont = UIFont(name: "MontserratRoman-SemiBold", size: 16)
        if let customFont = customFont {
            viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
        viewController.navigationItem.title = navigationTitle
    }
}

extension UIViewController {
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
}





