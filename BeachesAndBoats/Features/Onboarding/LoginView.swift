//
//  LoginView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit
import RxSwift

class LoginView: BaseViewControllerPlain {

    
    var coordinator: AppCoordinator?
    @IBOutlet weak var password: PasswordField!
    @IBOutlet weak var emailAddress: InputField!
    @IBOutlet weak var signUpBtn: UILabel!
    @IBOutlet weak var forgotPassword: UILabel!
    
    var vm = LoginViewModel()
    var disposeBag = DisposeBag()
    var phoneNumber = ""
    var resendOtp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let signUpGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSignUp))
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addGestureRecognizer(signUpGesture)
        
        forgotPassword.attributedText = forgotPassword.underlinedText("Forgot Password?", color: .B_B)
        let forgotPasswordGesture = UITapGestureRecognizer(target: self, action: #selector(gotoForgotPassword))
        forgotPassword.isUserInteractionEnabled = true
        forgotPassword.addGestureRecognizer(forgotPasswordGesture)
        emailAddress.text = AppStorage.username ?? ""
        
        bindNetwork()
    }
    
    @objc func gotoSignUp(){
        coordinator?.gotoSignup()
    }
    
    @objc func gotoForgotPassword(){
        coordinator?.gotoForgotPassword()
    }
    

    @IBAction func continueTapped(_ sender: Any) {
        if validateFields(){
            LoadingModal.show()
            let request = LoginRequest(email: emailAddress.text, password: password.text, device_id: UserDevice().imei)
            vm.login(request: request)
        }
        
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
                
            case .loginSuccess(let response):
//                UserSession.shared.userDetails = response.user
                if response.data?.switch_device == true || response.data?.user?.mfa_enabled == true{
                    self?.presentConfirmAccountModal()
                }else{
                    AppStorage.hasSignedIn = true
                    AppStorage.username = response.data?.user?.email
                    UserSession.shared.loginRes = response
                    self?.coordinator?.goToDashboard()
                }
            case .loginError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: Request Otp
//            case .confirmAccountSuccess(let response):
//                if self?.resendOtp == false{
//                    self?.presentConfirmAccountModal()
//                }else{
//                    Toast.show(message: response.message ?? "OTP sent successfully")
//                }
//            case .confirmAccountError(let error):
//                print(error)
//                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: Verify Otp
            case .verifyOtpSuccess(let response):
                AppStorage.hasSignedIn = true
                AppStorage.username = response.data?.user?.email
                UserSession.shared.loginRes = response
                self?.coordinator?.goToDashboard()
            case .verifyOtpError(let error):
                Toast.show(message: error.message ?? "Invalid OTP")
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    func validateFields() -> Bool{
        let validEmail = emailAddress.validate(rules: [Rule(.isValidEmail, "Please enter a valid Email Address")])
        let notEmptyEmail = emailAddress.validate(rules: [Rule(.isEmpty, "Please enter Email Address")])
        let notEmptyPassword = password.validate(rules: [Rule(.isEmpty, "Please enter your Password")])
        
        return validEmail && notEmptyEmail && notEmptyPassword
    }
    
}


extension LoginView: ModalTransitionDelegate{
    func presentUserInformationModal(userInfo: SignUpRequest) {
        print("")
    }
    
    func presentCreatePasswordModal() {
        print("")
    }
    
    func presentConfirmAccountModal() {
        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self, purpose: .switchDevice)
    }
    
    
}

extension LoginView: OTPDelegate{
    func resendOTP() {
        resendOtp = true
//        requestOTP()
        
    }
    
    func userOTP(otp: String?, keepSignIn: Bool) {
        print(otp ?? "No otp")
        let request = VerifyLoginOtpRequest(email: emailAddress.text, otp_code: otp, device_id: UserDevice().imei)
        LoadingModal.show()
        vm.verifyOtp(request: request)
    }
    
    
}
