//
//  MakePaymentView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/01/2025.
//

import UIKit
import PaystackCore
import PaystackUI

class MakePaymentView: UIViewController {
    
    var coordinator: ExploreCoordinator?

    @IBOutlet weak var paymentStack: UIStackView!
  
    var accessCode: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        paymentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentTapped)))
    }
    
    @objc func paymentTapped(){
        let paystack = try? PaystackBuilder
               .newInstance
               .setKey("pk_test_86bef2313897f8e69fa1067e9bb722f400883417")
               .build()
        
        paystack?.presentChargeUI(on: self,
                                          accessCode: "transaction access code",
                                          onComplete: paymentDone)
    }


    func paymentDone(_ result: TransactionResult) {
        switch (result){
        case .completed(let details):
            print("Transaction completed with reference: \(details.reference)")
        case .cancelled:
            print("Transaction was cancelled")
        case .error(error: let error, reference: let reference):
            print("An error occured: \(error.message) with reference: \(String(describing: reference))")
        }
    }
}


