//
//  MenuView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import UIKit

class MenuView: UIViewController {
    
    @IBOutlet weak var editPropertiesBtn: UIStackView!
    @IBOutlet weak var earningBtn: UIStackView!
    @IBOutlet weak var safetyBtn: UIStackView!
    @IBOutlet weak var manageAccBtn: UIStackView!
    @IBOutlet weak var paymentBtn: UIStackView!
    @IBOutlet weak var notificationBtn: UIStackView!
    @IBOutlet weak var loginSecurityBtn: UIStackView!
    @IBOutlet weak var verifyAccBtn: UIStackView!
    @IBOutlet weak var cxSupportBtn: UIStackView!
    @IBOutlet weak var logOutBtn: UIStackView!
    
    var coordinator: HostingServiceMenuCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        gestureRecognizers()
    }
    
    func gestureRecognizers() {
        let gestures: [(UIStackView, Selector)] = [
            (editPropertiesBtn, #selector(editPropertiesTapped)),
            (earningBtn, #selector(earningTapped)),
            (safetyBtn, #selector(safetyTapped)),
            (manageAccBtn, #selector(manageAccTapped)),
            (paymentBtn, #selector(paymentTapped)),
            (notificationBtn, #selector(notificationTapped)),
            (loginSecurityBtn, #selector(loginSecurityTapped)),
            (verifyAccBtn, #selector(verifyAccTapped)),
            (cxSupportBtn, #selector(cxSupportTapped)),
        ]
        
        for (stackView, selector) in gestures {
            GestureRecognizerHelper.addTapGesture(to: stackView, target: self, action: selector)
        }
    }
    
    @objc func editPropertiesTapped() {
        
    }
    
    @objc func earningTapped() {
        coordinator?.gotoEarningView()
    }
    
    @objc func safetyTapped() {
        coordinator?.gotoSafetyView()
    }
    
    @objc func manageAccTapped() {
        coordinator?.gotoManageProfile()
    }
    
    @objc func paymentTapped() {
        coordinator?.gotoPayment()
    }
    
    @objc func notificationTapped() {
        coordinator?.gotoNotification()
    }
    
    @objc func loginSecurityTapped() {
        coordinator?.gotoLoginAndSecurity()
    }
    
    @objc func verifyAccTapped() {
        
    }
    
    @objc func cxSupportTapped() {
        coordinator?.gotoContactSupport()
    }
    

    @IBAction func switchBtnTapped(_ sender: Any) {
    }
    
    
}
