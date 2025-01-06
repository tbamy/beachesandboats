//
//  2FASecurityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit
import RxSwift

class TwoFASecurityView: BaseViewControllerPlain {
    
    @IBOutlet weak var gmailStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    
    var coordinator: AccountCoordinator?

    let vm = TwoFASecurityVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<TwoFASecurityVM.Input>()
    
    var email: String? = ""
    var phoneNumber: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login and Security"

        gmailStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gmailTapped(_ :))))
        phoneStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapped(_ :))))
        bind()
    }

    @objc func gmailTapped(_ sender: UITapGestureRecognizer){
        AddEmailAddressModal.show { userEmail in
            print(userEmail ?? "")
            self.email = userEmail
            LoadingModal.show(title: "Loading...")
            let request = TwoFAEmailSecurityRequest(email: userEmail ?? "")
            self.input.onNext(.emailSecurity(request))
        }
    }
    
    @objc func phoneTapped(_ sender: UITapGestureRecognizer){
        AddPhoneNumberModal.show { userPhoneNumber in
            print(userPhoneNumber ?? "")
            self.phoneNumber = userPhoneNumber
            LoadingModal.show(title: "Loading...")
            let request = TwoFAPhoneSecurityRequest(phoneNumber: userPhoneNumber ?? "")
            self.input.onNext(.phoneSecurity(request))
        }
    }
    
    func completeVerificationForPhoneNumber(_ otpCode: String) {
        LoadingModal.show(title: "Processing")
        let request = TwoFACompleteVerificationRequest(phoneNumber: phoneNumber, otpCode: otpCode)
        input.onNext(.completeTwoFA(request))
    }
    
    func completeVerificationForEmail(_ otpCode: String) {
        LoadingModal.show(title: "Processing")
        let request = TwoFACompleteVerificationRequest(email: email, otpCode: otpCode)
        input.onNext(.completeTwoFA(request))
    }

}

//MARK: - Binding
extension TwoFASecurityView {
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .emailSecuritySuccess(let response):
                MiddleModal.show(subtitle: response.message ?? "", type: .success,  primaryText: "Continue", onConfirm: {
                    ConfirmPhoneNumberModal.show(callBack: { otp in
                        print(otp)
                        self?.completeVerificationForEmail(otp ?? "")
                    }, isPhoneNumber: false)
                })
               
            case .emailSecurityFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .phoneSecuritySuccess(let response):
                MiddleModal.show(subtitle: response.message ?? "", type: .success,  primaryText: "Continue", onConfirm: {
                    ConfirmPhoneNumberModal.show(callBack: { otp in
                        print(otp)
                        self?.completeVerificationForPhoneNumber(otp ?? "")
                    }, isPhoneNumber: true)
                })
            case .phoneSecurityFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            case .completeTwoFASuccess(let response):
                let loginSecurity = LoginAndSecurityView()
                MiddleModal.show(title: "Double authentication added successful", subtitle: response.message ?? "", type: .success, primaryText: "Done", onConfirm: {
                    self?.coordinator?.pop(animated: true)
                })
            case .completeTwoFAFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}
