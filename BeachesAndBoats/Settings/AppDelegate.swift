//
//  AppDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/05/2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var coordinator: AppCoordinator?
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupCoordinator(application)
        return true
    }

    //coordinator setup
    private func setupCoordinator(_ application: UIApplication) {
        let navController = BaseNavigationController()
        coordinator = AppCoordinator(navigationController: navController, completion: nil)
//        coordinator?.start()
//        coordinator?.gotoProfile()
//        coordinator?.gotoPayments()
//        coordinator?.gotoLoginSecurityView()
//        coordinator?.gotoOTP()
//        coordinator?.gotoBooking()
//        coordinator?.gotoBookingDetails()
        coordinator?.gotoHomePage()
        
        
        window = AppWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }


}

