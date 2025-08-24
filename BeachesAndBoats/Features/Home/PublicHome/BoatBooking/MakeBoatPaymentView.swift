//
//  MakeBoatPaymentView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/02/2025.
//

import UIKit
import PaystackCore
import PaystackUI
import RxSwift

class MakeBoatPaymentView: UIViewController {
    
    var coordinator: ExploreCoordinator?

    @IBOutlet weak var payButton: PrimaryButton!
    
    let vm = PaymentCallbackVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<PaymentCallbackVM.Input>()
  
//    var accessCode: String?
    var bookingResponse: BoatBookingResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pay with Paystack"
        
        bind()
        
        let amountToPay: Float = bookingResponse?.data?.bookingDetail?.total ?? 0
        let buttonTitle = "Pay (₦\(amountToPay))"
        payButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func payTapped(_ sender: Any) {
        guard let publicKey = Bundle.main.infoDictionary?["PAYSTACK_PUBLIC_KEY"] as? String else {
            return
        }
           
        let paystack = try? PaystackBuilder
               .newInstance
               .setKey(publicKey)
               .build()
        
        if let accessCode = bookingResponse?.data?.paymentData?.accessCode{
            paystack?.presentChargeUI(on: self,
                                              accessCode: accessCode,
                                              onComplete: paymentDone)
        }else{
            MiddleModal.show(title: "Oops!", subtitle: "Something went wrong during your booking.", type: .error, dismissable: true, dismissOnConfirm: true)
        }
    }



    func paymentDone(_ result: TransactionResult) {
        switch (result){
        case .completed(let details):
            print("Transaction completed with reference: \(details.reference)")
            input.onNext(.paymentCallback(reference: details.reference))
            MiddleModal.show(title: "Payment and booking made successfully!", type: .success, primaryText: "View Booking", secondaryText: "Done", dismissable: false, dismissOnConfirm: false, onConfirm: { self.gotoViewBooking() }, onCancel: { self.coordinator?.backToDashboard() })
        case .cancelled:
            MiddleModal.show(title: "An Error Occured", subtitle: "Payment was cancelled", type: .error, dismissable: true, dismissOnConfirm: true)
        case .error(error: let error, reference: let reference):
            MiddleModal.show(title: "An error occured", subtitle: error.message, type: .error, dismissable: true, dismissOnConfirm: true)
            print("An error occured: \(error.message) with reference: \(String(describing: reference))")
        }
    }
    
    func gotoViewBooking(){
        coordinator?.switchToBookingCoordinator()
    }
    
    func bind(){
        vm.transform(input: input)
        
        vm.output.subscribe(onNext: { data in
            LoadingModal.dismiss()
            switch data {
            case .paymentCallbackSuccess(_):
                print("Do Nothing")
            case .paymentCallbackFailed(_):
                print("Do Nothing")
            }
        }).disposed(by: disposeBag)
    }
}



