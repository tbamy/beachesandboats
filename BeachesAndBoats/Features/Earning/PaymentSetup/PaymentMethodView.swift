//
//  PaymentMethodView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import UIKit

class PaymentMethodView: BaseViewControllerPlain {
    
    @IBOutlet weak var bankCheckBox: CheckboxButton!
    
    var coordinator: HostingServiceEarningCoordinator?
    var country: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "Payment Settings"

    }


    @IBAction func continueBtnTapped(_ sender: Any) {
        if bankCheckBox.isChecked == false {
            Toast.show(message: "Kindly select payment method")
        } else {
            coordinator?.gotoBankDetails(countrySelected: country, paymentMethod: "Bank")
        }
    }
}
