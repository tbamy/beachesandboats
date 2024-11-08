//
//  PaypalPaymentView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class PaypalPaymentView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var paypalEmailField: InputField!
    @IBOutlet weak var addPaypalBtn: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pay with paypal"
    }

    @IBAction func addPaypalTapped(_ sender: Any) {
        
    }

}
