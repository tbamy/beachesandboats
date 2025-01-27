//
//  BankDetailsView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import UIKit

class BankDetailsView: BaseViewControllerPlain {
    
    @IBOutlet weak var bankNameField: InputField!
    @IBOutlet weak var accountNumberField: InputField!
    @IBOutlet weak var bankDropDownField: DropDown!
    
    var coordinator: HostingServiceEarningCoordinator?
    
    var country: String = ""
    var paymentMethod: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Payment Settings"

    }

    @IBAction func saveBtnTapped(_ sender: Any) {
        if validateFields() {
            
        }
    }
    
}

//MARK: - Field Validation
extension BankDetailsView {
    func validateFields() -> Bool {
        let bank = bankNameField.validate(rules: [Rule(.isEmpty, "Enter a bank")])
        let accNo = accountNumberField.validate(rules: [Rule(.isEmpty, "Enter a acoount number")])
        let bankDropdown = bankDropDownField.validate(rules: [Rule(.isEmpty, "Select a bank")])
        return bank && accNo && bankDropdown
    }
}

