//
//  LoginView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class LoginView: BaseViewControllerPlain {

    
    var coordinator: AppCoordinator?
    @IBOutlet weak var password: PasswordField!
    @IBOutlet weak var emailAddress: InputField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }

    @IBAction func continueTapped(_ sender: Any) {
//        coordinator.goto
    }
    
}
