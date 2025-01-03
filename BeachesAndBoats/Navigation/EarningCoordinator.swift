//
//  EarningCoordinator.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import Foundation
import UIKit

class EarningCoordinator: Coordinator {
    
    override func start() {
        let vc: EarningsView = .fromNib()
        vc.tabBarItem = UITabBarItem(title: "Earnings", image: UIImage(named: "earningsIcon"), tag: 3)
        vc.tabBarItem.accessibilityIdentifier = "Earnings"
        vc.coordinator = self
        push(viewController: vc)
    }
    
    func gotoHistoryView() {
        let vc: WithdrawalMainView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoCountryPaymentView() {
        let vc: PaymentSetupView = .fromNib()
        vc.coordinator = self
        vc.hidesBottomBarWhenPushed = true
        push(viewController: vc)
    }
    
    func gotoPaymentMethod(countrySelected: String) {
        let vc: PaymentMethodView = .fromNib()
        vc.coordinator = self
        vc.country = countrySelected
        push(viewController: vc)
    }
    
    func gotoBankDetails(countrySelected: String, paymentMethod: String) {
        let vc: BankDetailsView = .fromNib()
        vc.coordinator = self
        vc.country = countrySelected
        vc.paymentMethod = paymentMethod
        push(viewController: vc)
    }
    
//    func gotoServiceHostingDetailsView(data: BeachHouseBookingDetails) {
//        let vc: ServiceHostingDetailsView = .fromNib()
//        vc.coordinator = self
//        vc.bookingServiceDetails = data
//        push(viewController: vc)
//    }
//    
//    func gotoServiceHostingDetailsView() {
//        let vc: ServiceHostingDetailsView = .fromNib()
//        vc.coordinator = self
////        vc.bookingServiceDetails = data
//        push(viewController: vc)
//    }
//    
//    
    func gotoServiceDashboard() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }),
           let tabBarController = window.rootViewController as? ServiceDashboard {
            tabBarController.selectedIndex = 1
        }
    }
}
