//
//  AppDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/05/2024.
//

import UIKit
import PaystackCore
//import

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var coordinator: AppCoordinator?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupCoordinator(application)
        
        _ = try? PaystackBuilder
              .newInstance
              .setKey("pk_test_86bef2313897f8e69fa1067e9bb722f400883417")
              .build()
        
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

