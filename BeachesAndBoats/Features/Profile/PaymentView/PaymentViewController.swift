//
//  PaymentViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 12/05/2024.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var yourPaymentsLabel: UILabel!
    @IBOutlet weak var paymentMethodContainer: UIView!
    @IBOutlet weak var yourPaymentsContainer: UIView!
    
    let paymentMethod = CreditCardPaymentViewController()

    
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Payments", navigationSubtitle: nil, rightIcon: .none, secondRightIcon: nil)
        
//        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Payments", rightIcon: .none)
        setup()
        
    }
    
    func setup() {
        paymentMethodLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        yourPaymentsLabel.font = UIFont(name: "Montserrat-Regular", size: 14)
        
        let paymentMethod = UITapGestureRecognizer(target: self, action: #selector(paymentMethodTapped))
        paymentMethodContainer.isUserInteractionEnabled = true
        paymentMethodContainer.addGestureRecognizer(paymentMethod)
        
        let yourPayments = UITapGestureRecognizer(target: self, action: #selector(yourPaymentTapped))
        yourPaymentsContainer.isUserInteractionEnabled = true
        yourPaymentsContainer.addGestureRecognizer(yourPayments)
        
    }
    
    @objc func paymentMethodTapped() {
        let paymentBottomModal = PaymentOptionsViewController()
        paymentBottomModal.delegate = self
        paymentBottomModal.modalPresentationStyle = .overCurrentContext
        paymentBottomModal.modalTransitionStyle = .coverVertical
        present(paymentBottomModal, animated: true, completion: nil)
    }
    
    @objc func yourPaymentTapped() {
        print("I am")
    }
}

extension PaymentViewController: PaymentOptionsDelegate {
    
    func navigationTo() {
        let creditView = CreditCardPaymentViewController(nibName: "CreditCardPaymentViewController", bundle: nil)
        navigationController?.pushViewController(creditView, animated: true)
            dismiss(animated: true, completion: nil)
    }
    
    func creditCard() {
        paymentMethod.hidepayPalStack = true
        paymentMethod.hideCreditCardStack = false
        navigationTo()
    }
    
    func payPal() {
        paymentMethod.hideCreditCardStack = true
        paymentMethod.hidepayPalStack = false
        navigationTo()
    }
}
