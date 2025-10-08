//
//  LoginAndSecurityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit
import RxSwift

class LoginAndSecurityView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var currentPasswordField: InputField!
    @IBOutlet weak var newPasswordField: InputField!
    @IBOutlet weak var addBtn: PlainOutlineButton!
    @IBOutlet weak var addAuthenticationView: UIView!
    @IBOutlet weak var authenticationDetailsView: UIView!
    @IBOutlet weak var phoneDetailsStack: UIStackView!
    @IBOutlet weak var emailDetailsStack: UIStackView!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    
    var email: String?
    var phoneNumber: String?
    var isEmail: Bool = false
    
    let vm = TwoFASecurityVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<TwoFASecurityVM.Input>()
    
    var confirmModal: ConfirmPhoneNumberModal?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login and Security"
       
        setup()
        bind()
        setupCustomNavigationButton()
    }
    
    func setup(){
        email = UserSession.shared.loginRes?.data?.user?.mfa_email
        phoneNumber = UserSession.shared.loginRes?.data?.user?.mfa_phone_number
        
        if let email = email, !email.isEmpty, let phoneNumber = phoneNumber, !phoneNumber.isEmpty{
            emailLbl.text = email
            phoneLbl.text = phoneNumber
            addAuthenticationView.isHidden = true
            authenticationDetailsView.isHidden = false
        }else{
            addAuthenticationView.isHidden = false
            authenticationDetailsView.isHidden = true
        }
    }

    @IBAction func editForEmail(_ sender: Any) {
        showEmailModal()
    }
    
    @IBAction func editForPhoneNo(_ sender: Any) {
        showPhoneModal()
    }
    
    func showEmailModal(){
        AddEmailAddressModal.show(on: view) { userEmail in
            print(userEmail ?? "")
            self.email = userEmail
            self.requestEmailOtp(email: userEmail)
        }
    }
    
    func showPhoneModal(){
        AddPhoneNumberModal.show(on: view) { userPhoneNumber in
            print(userPhoneNumber ?? "")
            self.phoneNumber = userPhoneNumber
            self.requestPhoneOtp(phone: userPhoneNumber)
        }
    }
    
    func requestEmailOtp(email: String?){
        LoadingModal.show(title: "Loading...")
        let request = TwoFAEmailSecurityRequest(email: email ?? "")
        self.input.onNext(.emailSecurity(request))
        self.isEmail = true
    }
    
    func requestPhoneOtp(phone: String?){
        LoadingModal.show(title: "Loading...")
        let request = TwoFAPhoneSecurityRequest(phoneNumber: phone ?? "")
        self.input.onNext(.phoneSecurity(request))
        self.isEmail = true
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        coordinator?.goto2FASecurityView()
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
    
    func showConfirmOtpModal(isEmail: Bool){
        confirmModal =  ConfirmPhoneNumberModal.show(on: self.view ?? UIView(), callBack: { otp in
            print(otp)
            if isEmail {
                self.completeVerificationForEmail(otp ?? "")
            }else{
                self.completeVerificationForPhoneNumber(otp ?? "")
            }
            
        }, isEmail: isEmail, delegate: self)
    }
}

extension LoginAndSecurityView{
    func bind() {
        vm.transform(input: input)
        vm.output.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            switch output {
            case .emailSecuritySuccess(let response):
                MiddleModal.show(subtitle: response.message ?? "", type: .success,  primaryText: "Continue", onConfirm: {
                    self?.showConfirmOtpModal(isEmail: self?.isEmail ?? false)
                })
               
            case .emailSecurityFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            case .phoneSecuritySuccess(let response):
                MiddleModal.show(subtitle: response.message ?? "", type: .success,  primaryText: "Continue", onConfirm: {
                    self?.showConfirmOtpModal(isEmail: self?.isEmail ?? false)
                })
            case .phoneSecurityFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
            case .completeTwoFASuccess(let response):
//                let loginSecurity = LoginAndSecurityView()
                MiddleModal.show(title: "Double authentication added successful", subtitle: response.message ?? "", type: .success, primaryText: "Done", onConfirm: {
                    self?.coordinator?.pop(animated: true)
                })
            case .completeTwoFAFailure(let error):
                MiddleModal.show(title: error.message ?? "", type: .error, onConfirm: {
                    self?.showConfirmOtpModal(isEmail: self?.isEmail ?? false)
                })
            }
        }).disposed(by: disposeBag)
        
        vm.changePasswordOutput.subscribe(onNext: { [weak self] output in
            LoadingModal.dismiss()
            
            switch output {
            case .changePasswordSuccess(let response):
                self?.updateUserDetails(with: response)
            case .changePasswordFailed(let error):
                Toast.show(message: error.message ?? "Error updating password")
            }
        }).disposed(by: disposeBag)
    }
    
    func updateUserDetails(with: UpdateProfileResponse){
        UserSession.shared.userDetails = with.data
        Toast.show(message: with.message ?? "Password Successfully Updated")
    }
    
    func validateFields() -> Bool{
//        if currentPasswordField.text.isEmpty {
//            currentPasswordField.error = "Please enter your Address"
//            return false
//        }
//        else 
        if newPasswordField.text.isEmpty {
            newPasswordField.error = "Please enter your New Password"
            return false
        }
        
        return true
    }
}

extension LoginAndSecurityView{
    func setupCustomNavigationButton() {
        let customButton = UIButton(type: .custom)
        customButton.setTitle("Save", for: .normal)
        customButton.tintColor = .beachBlue
        customButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }
    
    @objc func saveButtonTapped() {
        if validateFields(){
            LoadingModal.show()
            let request = ChangePasswordRequest(current_password: currentPasswordField.text, new_password: newPasswordField.text)
            input.onNext(.changePassword(request))
        }
    }
}

extension LoginAndSecurityView: GestureRecognizer {
    func changePhoneNumberTapped() {
        print("Change phone/email tapped")
        // Dismiss modal and re-show AddPhoneNumberModal or AddEmailAddressModal
        confirmModal?.dismiss()
        
        if isEmail {
            showEmailModal()
        }else{
            showPhoneModal()
        }
        
    }
    
    func resendCodeTapped() {
        print("Resend code tapped")
        confirmModal?.dismiss()
        if isEmail {
            requestEmailOtp(email: self.email)
        }else{
            requestPhoneOtp(phone: self.phoneNumber)
        }
    }
}
