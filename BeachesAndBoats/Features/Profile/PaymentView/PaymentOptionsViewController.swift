//
//  PaymentOptionsViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 12/05/2024.
//

import UIKit

protocol PaymentOptionsDelegate: AnyObject {
    func creditCard()
    func payPal()
}

class PaymentOptionsViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var creditCardContainer: UIView!
    @IBOutlet weak var payPalContainer: UIView!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var payContainer: UIView!
    
    let paymentMethod = CreditCardPaymentViewController()
    var coordinator: AppCoordinator?

    weak var delegate: PaymentOptionsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        viewContainer.layer.cornerRadius = 15
        
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)

        
        let close = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(close)
        
        let creditCard = UITapGestureRecognizer(target: self, action: #selector(creditCardTapped))
        creditCardContainer.isUserInteractionEnabled = true
        creditCardContainer.addGestureRecognizer(creditCard)
        
        let payPal = UITapGestureRecognizer(target: self, action: #selector(payPalTapped))
        payPalContainer.isUserInteractionEnabled = true
        payPalContainer.addGestureRecognizer(payPal)

    }
    
    @objc func closeTapped() {
        dismiss(animated: true)
    }
    
    @objc func creditCardTapped() {
        delegate?.creditCard()
        
//        coordinator?.gotopaymentView()
        print("Credit CARD")
        
    }
    
    @objc func payPalTapped() {
//        paymentMethod.hidepayPalStack = true
        delegate?.payPal()
        
//        coordinator?.gotopaymentView()
        print("Paypal")
    }
  
}
