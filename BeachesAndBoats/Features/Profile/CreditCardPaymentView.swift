//
//  CreditCardPaymentView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class CreditCardPaymentView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var cardNameField: InputField!
    @IBOutlet weak var cardNumberField: InputField!
    @IBOutlet weak var expirationField: InputField!
    @IBOutlet weak var cvvField: InputField!
    @IBOutlet weak var addCardBtn: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Pay with credit card"
    }

    @IBAction func addCardTapped(_ sender: Any) {
        
    }

}
