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
    
    func gotoProfile() {
        let vc: ProfileViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoManageAccount() {
        let vc: ManageAccountViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoPayments() {
        let vc: PaymentViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotopaymentView() {
        let vc: CreditCardPaymentViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoLoginSecurityView() {
        let vc: LoginSecurityViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoAuthView() {
        let vc: DoubleAuthViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoOTP() {
        let vc: otpBottomModalViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoContactSupport() {
        let vc: ContactSupportViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoNotification() {
        let vc: NotificationViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoSafetyAndGuidelines() {
        let vc: SafetyAndGuidelinesViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoBooking() {
        let vc: BookingViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoBookingDetails(data: BookingProperties) {
        let vc: BookingDetailsViewController = .fromNib()
        vc.coordinator = self
        vc.getData = data
        vc.pastBooking = true
        vc.navigationController?.setNavigationBarHidden(true, animated: true)
        push(viewController: vc)
    }
    
    func gotoPastBookingDetails(data: BookingProperties) {
        let vc: BookingDetailsViewController = .fromNib()
        vc.coordinator = self
        vc.getData = data
        vc.upcomingBooking = true
        vc.navigationController?.setNavigationBarHidden(true, animated: true)
        push(viewController: vc)
    }
    
    func gotoTopRatedDetails(data: TopRatedProperties) {
        let vc: BookingDetailsViewController = .fromNib()
        vc.coordinator = self
        vc.getTopRatedData = data
        vc.continueBooking = "Continue Booking"
        vc.upcomingBooking = true
        vc.navigationController?.setNavigationBarHidden(true, animated: true)
        push(viewController: vc)
    }
    
    func gotoHomePage() {
        let vc: HomePageViewController = .fromNib()
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoBoatDetails(data: TopRatedProperties) {
        let vc: BoatDetailsViewController = .fromNib()
        vc.coordinator = self
        vc.getBoatTopRatedData = data
//        vc.navigationController?.setNavigationBarHidden(true, animated: true)
        push(viewController: vc)
    }

    func gotoConfirmBooking() {
        let vc: ConfirmBookingViewController = .fromNib()
        vc.coordinator = self
        vc.navigationController?.setNavigationBarHidden(false, animated: false)
        push(viewController: vc)
    }
}
