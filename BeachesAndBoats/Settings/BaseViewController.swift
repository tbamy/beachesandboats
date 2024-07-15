//
//  BaseViewController.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class BaseViewController: UIViewController {
    let navigationBarAppearance = UINavigationBarAppearance()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setLightNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setLightNavigation()
    }
    
    func setDarkNavigation() {
//        navigationBarAppearance.backgroundImage = Assets.navbarBG.image
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: Fonts.getFont(name: .Medium, 18), .foregroundColor: UIColor.white]
        navigationController?.navigationBar.overrideUserInterfaceStyle = .dark
        navigationController?.navigationBar.barStyle = .black
        setupNavigation(backButton: Assets.backButton.image)
    }
    
    func setLightNavigation() {
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .white
        navigationBarAppearance.backgroundImage = nil
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: Fonts.getFont(name: .Medium, 18), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .default
        setupNavigation(backButton: Assets.backButton.image)
    }
    
    func setNavigationPlain() {
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .clear
        navigationBarAppearance.backgroundImage = nil
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: Fonts.getFont(name: .Medium, 18), .foregroundColor: UIColor.black]
        navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        navigationController?.navigationBar.barStyle = .default
        setupNavigation(backButton: Assets.backButton.image)
    }
    
    func setupNavigation(backButton: UIImage) {
        navigationBarAppearance.setBackIndicatorImage(Assets.backButton.image, transitionMaskImage: Assets.backButton.image)
        navigationController?.navigationBar.backIndicatorImage = backButton
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButton
        navigationBarAppearance.shadowImage = UIImage()
        navigationBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.setTitleVerticalPositionAdjustment(-4.5, for: .default)
        
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.compactAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        
        
        let tabBarApperance = UITabBarAppearance()
        tabBarApperance.configureWithOpaqueBackground()
        tabBarApperance.backgroundColor = UIColor.clear
        navigationController?.tabBarController?.tabBar.standardAppearance = tabBarApperance
        if #available(iOS 15.0, *) {
            navigationController?.tabBarController?.tabBar.scrollEdgeAppearance = tabBarApperance
        }
        
        navigationController?.navigationBar.barStyle = .black
    }
    
//    func setupBackButton(tint: UIColor) {
//        navigationController?.navigationBar.tintColor = tint
//        navigationItem.backBarButtonItem?.tintColor = tint
//        navigationController?.navigationBar.backIndicatorImage = Assets.backButton.image
//        navigationController?.navigationBar.backIndicatorTransitionMaskImage = Assets.backButton.image
//    }
}

class BaseViewControllerPlain: BaseViewController {
    
    override func viewDidLoad() {
        setNavigationPlain()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigationPlain()
    }
}


class BaseViewControllerDark: BaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        setDarkNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDarkNavigation()
    }
}
