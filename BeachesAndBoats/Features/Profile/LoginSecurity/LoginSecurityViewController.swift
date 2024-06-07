//
//  LoginSecurityViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 13/05/2024.
//

import UIKit

class LoginSecurityViewController: UIViewController {
    
    
    @IBOutlet weak var noAuth: UIStackView!
    @IBOutlet weak var authAvailable: UIStackView!
    @IBOutlet weak var phoneAuth: UILabel!
    @IBOutlet weak var emailAuth: UILabel!
    
    
    @IBOutlet weak var authButton: UIButton!
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Login and Security", navigationSubtitle: nil, rightIcon: nil, secondRightIcon: nil)
        
//        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Login and Security", rightIcon: nil)
        setup()
        
    }
    
    func setup() {
        authButton.layer.borderWidth = 0.5
        authButton.layer.borderColor = UIColor.black.cgColor
        authButton.layer.cornerRadius = 8
        
        if phoneAuth.text == "Label" || emailAuth.text == "Label" {
            authAvailable.isHidden = true
        } else {
            noAuth.isHidden = true
            authAvailable.isHidden = false
        }
    }
    
    
    @IBAction func authButtonTapped(_ sender: Any) {
        coordinator?.gotoAuthView()
    }
    
    @IBAction func phoneAuthEditClick(_ sender: Any) {
    }
    
    
    @IBAction func emailAuthClicked(_ sender: Any) {
    }
    
    
}

    


