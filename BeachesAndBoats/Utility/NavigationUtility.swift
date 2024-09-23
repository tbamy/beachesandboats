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
    
    func setupNavigation(for viewController: UIViewController, backIcon: UIImage?, navigationTitle: String, navigationSubtitle: String?, rightIcon: ((UIButton) -> Void)?, secondRightIcon: ((UIButton) -> Void)?) {
        let backButton = UIButton(type: .custom)
        let rightButton = UIButton(type: .custom)
        let secondRightButton = UIButton(type: .custom)
        
        if let backIcon = backIcon {
            backButton.setImage(backIcon.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        if let rightIcon = rightIcon {
            rightIcon(rightButton)
        }
        if let secondRightIcon = secondRightIcon {
            secondRightIcon(secondRightButton)
        }
        
        backButton.addTarget(viewController, action: #selector(viewController.popView), for: .touchUpInside)
    
        let backButtonItem = UIBarButtonItem(customView: backButton)
        viewController.navigationItem.leftBarButtonItem = backButtonItem
        let rightButtonItem = UIBarButtonItem(customView: rightButton)
        let secondRightButtonItem = UIBarButtonItem(customView: secondRightButton)
        
        
        viewController.navigationItem.rightBarButtonItems = [rightButtonItem, secondRightButtonItem]
        
        //Title Navigation
        let titleView = createTitleView(title: navigationTitle, subtitle: navigationSubtitle)
        viewController.navigationItem.titleView = titleView
        
//        //title navigation
//        let customFont = UIFont(name: "MontserratRoman-SemiBold", size: 16)
//        if let customFont = customFont {
//            viewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
//        }
//        viewController.navigationItem.title = navigationTitle
    }
    
    private func createTitleView(title: String, subtitle: String?) -> UIView {
        let titleView = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "MontserratRoman-SemiBold", size: 16)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleView.addSubview(titleLabel)
        
        if let subtitle = subtitle {
            let subtitleLabel = UILabel()
            subtitleLabel.text = subtitle
            subtitleLabel.font = UIFont(name: "MontserratRoman-Regular", size: 12)
            subtitleLabel.textColor = .gray
            subtitleLabel.textAlignment = .center
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleView.addSubview(subtitleLabel)
            
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
                subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
                subtitleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
                subtitleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
                subtitleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: titleView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: titleView.trailingAnchor),
                titleLabel.bottomAnchor.constraint(equalTo: titleView.bottomAnchor)
            ])
        }
        return titleView
    }
}

extension UIViewController {
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
}





