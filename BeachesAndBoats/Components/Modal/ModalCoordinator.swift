//
//  ModalDelegate.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/06/2024.
//

//import UIKit
//
//public protocol ModalTransitionDelegate: AnyObject {
//    func presentUserInformationModal(email: String, phone: String)
//    func presentCreatePasswordModal(userInfo: SignUpRequest)
//    func presentConfirmAccountModal()
//}
//
//class ModalCoordinator: UIViewController, ModalTransitionDelegate, OTPDelegate, InfoDelegate {
//    func userInfo(info: SignUpRequest) {
//        //srfr
//    }
//    
//    func presentCreatePasswordModal(userInfo: SignUpRequest) {
//        CreatePasswordModal.startCreatePasswordModal(on: view, userInfo: userInfo, delegate: self, transitionDelegate: self)
//    }
//    
//    func presentConfirmAccountModal() {
//        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self)
//    }
//    
//    func userOTP(otp: String?) {
//        // Handle OTP if necessary
//    }
//    
//    func presentUserInformationModal(email: String, phone: String) {
//        UserInformationModal.startUserInformationModal(on: view, email: email, phone: phone, transitionDelegate: self)
//    }
//    
//    func start() {
//        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self)
//    }
//}

