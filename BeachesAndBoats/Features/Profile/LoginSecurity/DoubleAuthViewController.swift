//
//  DoubleAuthViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 14/05/2024.
//

import UIKit

class DoubleAuthViewController: UIViewController {
    
    @IBOutlet weak var gmailContainer: UIView!
    @IBOutlet weak var phoneContainer: UIView!
    
    var coordinator: AppCoordinator?
    var state: SecurityState?
    let bottomModal = PhoneNumberBottomModal()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Login and Security")
        gestureRecognizers()
    }
    
    func getState(_ state: SecurityState) {
        switch state {
        case .gmail:
            print("gmail")
            displayBottomModal(with: .gmail)
            
        case .phone:
            print("phone")
            displayBottomModal(with: .phone)
        }
    }
    
    func gestureRecognizers() {
        let gmail = UITapGestureRecognizer(target: self, action: #selector(gmailTapped))
        gmailContainer.isUserInteractionEnabled = true
        gmailContainer.addGestureRecognizer(gmail)
       
        
        let phone = UITapGestureRecognizer(target: self, action: #selector(phoneTapped))
        phoneContainer.isUserInteractionEnabled = true
        phoneContainer.addGestureRecognizer(phone)
    }
    
    @objc func gmailTapped() {
        state = .gmail
        getState(.gmail)
    }
    
    @objc func phoneTapped() {
        state = .phone
        getState(.phone)
    }
    
    func displayBottomModal(with state: SecurityState) {
        let phoneBottomModal = PhoneNumberBottomModal()
        phoneBottomModal.state = state
        phoneBottomModal.phoneDelegate = self
        phoneBottomModal.modalPresentationStyle = .overCurrentContext
        phoneBottomModal.modalTransitionStyle = .coverVertical
        present(phoneBottomModal, animated: true, completion: nil)
    }
}

extension DoubleAuthViewController: PhoneNumberBottomModalDelegate {
    func presentOTPModal() {
        let phone = PhoneNumberBottomModal()
        phone.state = state
        if let phoneState = phone.state {
            print("State is \(phoneState)")
            if phoneState == .phone {
                let otpModal = otpBottomModalViewController()
                otpModal.authState = "Change phone number"
                otpModal.modalPresentationStyle = .overCurrentContext
                otpModal.modalTransitionStyle = .coverVertical
                present(otpModal, animated: false, completion: nil)
            } else {
                let otpModal = otpBottomModalViewController()
                otpModal.authState = "Change email address"
                otpModal.modalPresentationStyle = .overCurrentContext
                otpModal.modalTransitionStyle = .coverVertical
                present(otpModal, animated: false, completion: nil)
            }
        }
    }
}

enum SecurityState {
    case gmail, phone
}
