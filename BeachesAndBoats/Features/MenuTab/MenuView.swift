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
    
    
    @IBOutlet weak var verificationStatusView: UIView!
    @IBOutlet weak var verificationStatusLabel: UILabel!
    
    let userRoles = UserSession.shared.userDetails?.roles
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    
    let verificationStatus = UserSession.shared.userDetails?.verificationStatus
    let isAccountVerified = UserSession.shared.userDetails?.isAccountVerified
    
    var coordinator: HostingServiceMenuCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"
        gestureRecognizers()
        
        verificationStatusView.layer.cornerRadius = 8
        verificationStatusLabel.textColor = .white
        
//        editPropertiesBtn.isHidden = validateServiceRole()
        
        switch verificationStatus {
        case "pending":
            verificationStatusLabel.text = "Under verification"
            verificationStatusView.backgroundColor = .systemYellow
    
        case "rejected":
            verificationStatusLabel.text = "Rejected"
            verificationStatusView.backgroundColor = .systemRed
        case "approved":
            verificationStatusLabel.text = "Verified"
            verifyAccBtn.isUserInteractionEnabled = false
            verificationStatusView.backgroundColor = .systemGreen
        default:
            verificationStatusView.isHidden = true
        }
    }
    
    func validateServiceRole() -> Bool {
        guard let userRoles = userRoles else { return false }
        
        let serviceRoleStrings = serviceRoles.map { $0.rawValue }
        return userRoles.contains { serviceRoleStrings.contains($0) }
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
            (logOutBtn, #selector(logoutTapped)),
        ]
        
        for (stackView, selector) in gestures {
            GestureRecognizerHelper.addTapGesture(to: stackView, target: self, action: selector)
        }
    }
    
    @objc func editPropertiesTapped() {
        coordinator?.gotoEditPropertiesListView()
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
        guard verificationStatus != "pending", verificationStatus != "approved" else { return }
        coordinator?.gotoVerifyAccountView()
    }
    
    @objc func cxSupportTapped() {
        coordinator?.gotoContactSupport()
    }
    
    @objc func logoutTapped() {
        UserSession.shared.performLogout()
    }
    

    @IBAction func switchBtnTapped(_ sender: Any) {
        coordinator?.goToHomeDashboard()
    }
    
    
}
