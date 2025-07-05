//
//  VerifyAccountView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 10/10/2024.
//

import UIKit

class VerifyAccountView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func verifyAccountTapped(_ sender: Any) {
        coordinator?.gotoVerificationFormView()
    }
}
