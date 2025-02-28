//
//  AppDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/05/2024.
//

import UIKit
import PaystackCore
import IQKeyboardManagerSwift
//import PusherSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var coordinator: AppCoordinator?
    var window: UIWindow?
//    var pusher: Pusher!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupCoordinator(application)
        
        window?.overrideUserInterfaceStyle = .light
        
        IQKeyboardManager.shared.isEnabled = true
        IQKeyboardManager.shared.resignOnTouchOutside = true
        
        return true
    }

    //coordinator setup
    private func setupCoordinator(_ application: UIApplication) {
        let navController = BaseNavigationController()
        coordinator = AppCoordinator(navigationController: navController, completion: nil)
        coordinator?.start()
        
        window = AppWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }


}

