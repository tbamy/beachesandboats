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
}
