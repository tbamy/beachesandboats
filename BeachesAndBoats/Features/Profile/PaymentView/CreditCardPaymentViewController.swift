//
//  CreditCardPaymentViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 13/05/2024.
//

import UIKit

class CreditCardPaymentViewController: UIViewController {
    
    @IBOutlet weak var creditCardStack: UIStackView!
    @IBOutlet weak var addCard: UIButton!
    @IBOutlet weak var addPayPal: UIButton!
    @IBOutlet weak var payPalStack: UIStackView!
    
    var coordinator: AppCoordinator?
    
    var hideCreditCardStack: Bool = false
    var hidepayPalStack: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Pay with credit card")
        creditCardStack.isHidden = hideCreditCardStack
        payPalStack.isHidden = hidepayPalStack

    }
}
