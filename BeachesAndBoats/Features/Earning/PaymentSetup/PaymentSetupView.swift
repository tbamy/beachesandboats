//
//  PaymentSetupView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import UIKit

class PaymentSetupView: BaseViewControllerPlain {
    
    @IBOutlet weak var countryDropdownField: DropDown!
    
    var coordinator: HostingServiceEarningCoordinator?
    var selectedCountry: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = "Payment Settings"
        
       countryDropDown()
    }
    
    func countryDropDown() {
        countryDropdownField.items = Countries.countriesWithCodes.map { country in
            PickerItem(name: country.name, value: country.code)
        }
    }

    @IBAction func continueBtnTapped(_ sender: Any) {
        if validateFields() {
            coordinator?.gotoPaymentMethod(countrySelected: countryDropdownField.text)
        }
    }
    
}

//MARK: - Field Validation
extension PaymentSetupView {
    func validateFields() -> Bool {
        let country = countryDropdownField.validate(rules: [Rule(.isEmpty, "Select a country")])
        return country
    }
}
