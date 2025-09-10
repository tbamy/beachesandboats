//
//  ForgotPasswordView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/02/2025.
//

import UIKit
import RxSwift

class ForgotPasswordView: BaseViewControllerPlain {

    var coordinator: AppCoordinator?
    
    
    @IBOutlet weak var emailAddress: InputField!
//    @IBOutlet weak var sendlinkBtn: PrimaryButton!
    
    let vm = ForgotPasswordVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ForgotPasswordVM.Input>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
    }

    @IBAction func sendLink(_ sender: Any) {
        if validateField(){
            LoadingModal.show()
            let request = ForgotPasswordRequest(email: emailAddress.text)
            input.onNext(.forgotPassword(request))
        }
        
    }
    
    func validateField() -> Bool{
        if emailAddress.text.isEmpty {
            emailAddress.error = "Please enter Email Address"
            return false
        }
        
        return true
    }
    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .forgotPasswordSuccess(let response):
                Toast.show(message: response.message ?? "An Otp has been sent to your email, Kindly provide the otp to reset your password", duration: 5)
                coordinator?.gotoResetPassword(userEmail: emailAddress.text)
                
            case .forgotPasswordFailed(let error):
                MiddleModal.show(title: "Oops", subtitle: error.message ?? "Error Occured", type: .error)
            }
        }).disposed(by: disposeBag)
    }

}
