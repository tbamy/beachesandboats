//
//  ProfilePaymentView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class ProfilePaymentView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var paymentMethodsStack: UIStackView!
    @IBOutlet weak var yourPaymentsStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Payments"
        
        paymentMethodsStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentMethodsTapped(_ :))))
        yourPaymentsStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(yourPaymentsTapped(_ :))))
    }

    @objc func paymentMethodsTapped(_ sender: UITapGestureRecognizer){
        PaymentMethodModal.show(callBack: { [weak self] goto in
            if goto == "Card"{
                self?.coordinator?.gotoinitialListingView()
            }else{
                self?.coordinator?.gotoinitialListingView()
            }
        })
    }
    
    @objc func yourPaymentsTapped(_ sender: UITapGestureRecognizer){
        
    }


}
