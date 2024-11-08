//
//  AppCoordinator.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

final class AppCoordinator: Coordinator{
    override func start(){
        gotoWelcome()
//        gotoCalendarTest()
    }
    
    func gotoWelcome(){
        let vc: WelcomeScreen = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoWalkthrough(){
        let vc: WalkthroughView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoLogin(){
        let vc: LoginView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoSignup(){
        let vc: SignupView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoCalendarTest(){
        let vc: CalendarTestView = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func goToDashboard() {
        navigationController = BaseNavigationController(rootViewController: Dashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = Dashboard()
        }

    }
    
    func gotoHostingDashboard(){
        navigationController = BaseNavigationController(rootViewController: HostingDashboard())
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.rootViewController = HostingDashboard()
        }
    }
}
