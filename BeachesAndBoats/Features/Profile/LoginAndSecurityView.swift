//
//  LoginAndSecurityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class LoginAndSecurityView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var currentPasswordField: InputField!
    @IBOutlet weak var newPasswordField: InputField!
    @IBOutlet weak var addBtn: PlainOutlineButton!
    @IBOutlet weak var addAuthenticationView: UIView!
    @IBOutlet weak var authenticationDetailsView: UIView!
    @IBOutlet weak var phoneDetailsStack: UIStackView!
    @IBOutlet weak var emailDetailsStack: UIStackView!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login and Security"
       
    }

    @IBAction func editForEmail(_ sender: Any) {
    }
    
    @IBAction func editForPhoneNo(_ sender: Any) {
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        coordinator?.goto2FASecurityView()
    }
}
