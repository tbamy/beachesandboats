//
//  ModalDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/06/2024.
//

import UIKit

public protocol ModalTransitionDelegate: AnyObject {
    func presentUserInformationModal()
    func presentCreatePasswordModal()
}

class ModalCoordinator: UIViewController, ModalTransitionDelegate, OTPDelegate, InfoDelegate {
    func presentCreatePasswordModal() {
//        CreatePasswordModal.
    }
    
    
    func userOTP(otp: String?) {
        // Handle OTP if necessary
    }
    
    func userInfo(info: userInfoModel) {
        // Handle user information if necessary
    }
    
    func presentUserInformationModal() {
        UserInformationModal.startUserInformationModal(on: view, delegate: self, transitionDelegate: self)
    }
    
    func start() {
        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self)
    }
}

