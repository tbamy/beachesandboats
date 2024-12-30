//
//  SignupView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit
import RxSwift

class SignupView: BaseViewControllerPlain{

    var coordinator: AppCoordinator?
    @IBOutlet weak var phoneNumber: PhoneField!
    @IBOutlet weak var emailAddress: InputField!
    @IBOutlet weak var loginBtn: UILabel!
    
    
    var vm = ConfirmAccountViewModel()
    var disposeBag = DisposeBag()
    var email: String?
    var phone: String?
    var userInfo: SignUpRequest?
    var resendOtp: Bool = false
    var keepSignedIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(gotoLogin))
        loginBtn.isUserInteractionEnabled = true
        loginBtn.addGestureRecognizer(loginGesture)
        
        bindNetwork()
        
    }

    @IBAction func continueTapped(_ sender: Any) {
//        userInfo = SignUpRequest(first_name: "Earl", last_name: "Tbam", dob: "", phone_code: "", phone: "", email: "", password: "", password_confirmation: "ch")
//        if let userInfo = userInfo{
//            CreatePasswordModal.startCreatePasswordModal(on: view, userInfo: userInfo, delegate: self, transitionDelegate: self)
//        }
        if validateFields(){
            email = emailAddress.text
            phone = "+234\(phoneNumber.text)"
            requestOTP()
        }
    }
    
    func requestOTP(){
        LoadingModal.show()
        let request = ConfirmAccountRequest(phone_number: phone, email: email)
        print(request)
        vm.confirmAccount(request: request)
    }
    
    
    @objc func gotoLogin(){
        coordinator?.gotoLogin()
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            guard let self = self else { return }
            
            LoadingModal.dismiss()
            switch response {
                //MARK: Request Otp
            case .confirmAccountSuccess(let response):
                if resendOtp == false{
                    presentConfirmAccountModal()
                }else{
                    Toast.show(message: response.message ?? "OTP sent successfully")
                }
            case .confirmAccountError(let error):
                print(error)
                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: Otp Verification
            case .verifyCodeSuccess(_):
                let info = SignUpRequest(first_name: "", last_name: "", email: email, birthday: "", password: "", password_confirmation: "", keep_signed_in: keepSignedIn, phone_number: phone, device_id: UserDevice().imei)
                ConfirmAccountModal.dismiss()
                presentUserInformationModal(userInfo: info)
            case .verifyCodeError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: SignUp
            case .signUpSuccess(let response):
                AppStorage.hasSignedUp = true
                AppStorage.username = email
                UserSession.shared.loginRes = response
                MiddleModal.show(title: response.message ?? "Registration Successful", type: .success, onConfirm: navigateToHome)
            case .signUpError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    func navigateToHome(){
        coordinator?.goToDashboard()
    }
    
    func validateFields() -> Bool{
        if phoneNumber.text.isEmpty {
            phoneNumber.error = "Please enter Phone Number"
            return false
        }else if emailAddress.text.isEmpty {
            emailAddress.error = "Please enter Email Address"
            return false
        }
        else if phoneNumber.text.count != 10 {
            phoneNumber.error = "Please enter a valid Phone number"
            return false
        }
        
        return true
    }

}

extension SignupView: OTPDelegate{
    func resendOTP() {
        resendOtp = true
        requestOTP()
        
    }
    
    func userOTP(otp: String?, keepSignIn: Bool) {
        print(otp ?? "No otp")
        self.keepSignedIn = keepSignIn
        let request = VerifyCodeRequest(otp_code: otp, email: email)
        LoadingModal.show()
        vm.verifyCode(request: request)
    }
    
}

extension SignupView: InfoDelegate{
    func userInfo(info: SignUpRequest) {
        print(info)
        userInfo = info
        presentCreatePasswordModal()
    }
}

extension SignupView: CreateAccountDelegate{
    func signUpInfo(info: SignUpRequest) {
        print(info)
        userInfo = info
        LoadingModal.show()
        vm.signUp(profileRequest: info)
    }
}

extension SignupView: ModalTransitionDelegate{
    func presentCreatePasswordModal() {
        UserInformationModal.dismiss()
        if let userInfo = userInfo{
            CreatePasswordModal.startCreatePasswordModal(on: view, userInfo: userInfo, delegate: self, transitionDelegate: self)
        }
    }

    func presentConfirmAccountModal() {
        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self, purpose: .createAccount)
    }

    func presentUserInformationModal(userInfo: SignUpRequest) {
        ConfirmAccountModal.dismiss()
        UserInformationModal.startUserInformationModal(on: view, info: userInfo, delegate: self, transitionDelegate: self)
    }
            
    
    
}
