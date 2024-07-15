//
//  SignupView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

class SignupView: BaseViewControllerPlain {

    var coordinator: AppCoordinator?
    @IBOutlet weak var phoneNumber: PhoneField!
    @IBOutlet weak var emailAddress: InputField!
    
    var delegate: OTPDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true

        
    }

    @IBAction func continueTapped(_ sender: Any) {
//        ConfirmAccountModal.startConfirmModal(on: view, delegate: self)
        coordinator?.startModalCoordinator()
    }

}

extension SignupView: OTPDelegate{
    func userOTP(otp: String?) {
        print(otp ?? "No otp")
    }
    
}
