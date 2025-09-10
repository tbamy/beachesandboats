//
//  SignupView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit
import RxSwift

class SignupView: BaseViewControllerPlain, AttributedLabelDelegate{

    var coordinator: AppCoordinator?
    @IBOutlet weak var phoneNumber: InputFieldWithLeftImg!
    @IBOutlet weak var emailAddress: InputField!
    @IBOutlet weak var loginBtn: UILabel!
    @IBOutlet weak var terms: AttributedLabel!
    
    
    var vm = ConfirmAccountViewModel()
    var disposeBag = DisposeBag()
    var email: String?
    var phone: String?
    var userInfo: SignUpRequest?
    var resendOtp: Bool = false
    var keepSignedIn: Bool = false
    
    enum ModalState {
        case none
        case confirmAccount
        case userInformation
        case createPassword
    }
    var currentModalState: ModalState = .none
            
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        phoneNumber.keyboardType = .numberPad
        let loginGesture = UITapGestureRecognizer(target: self, action: #selector(gotoLogin))
        loginBtn.isUserInteractionEnabled = true
        loginBtn.addGestureRecognizer(loginGesture)
        setupTerms()
        
        bindNetwork()
        
    }
    
    func setupTerms() {
        let text = "By continuing, you have read and agreed to our Terms and Conditions, Privacy Statement and Nondiscrimination Policy."
        terms.configure(text: text, links: [
            "Terms and Conditions, Privacy Statement": URL(string: "https://google.com")!,
            "Nondiscrimination Policy": URL(string: "https://google.com")!
        ])
        
        terms.delegate = self
                
    }
    
    
    func didTapOnLink(_ url: URL) {
        UIApplication.shared.open(url)
    }

    @IBAction func continueTapped(_ sender: Any) {
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
                AppStorage.hasSignedIn = true
                AppStorage.username = email
                
                let userData = LoginUser(user: response.data?.user, switch_device: false, access_token: response.data?.accessToken, refreshToken: response.data?.refreshToken)
                UserSession.shared.loginRes = LoginResponse(data: userData)
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
        LoadingModal.show()
        vm.signUp(profileRequest: info)
    }
}

extension SignupView: ModalTransitionDelegate {
    func presentConfirmAccountModal() {
        if currentModalState != .confirmAccount {
            currentModalState = .confirmAccount
            UserInformationModal.dismiss() // Clean up any existing UserInformationModal
            ConfirmAccountModal.dismiss() // Clean up any existing ConfirmAccountModal
            ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self, purpose: .createAccount)
        }
    }

    func presentUserInformationModal(userInfo: SignUpRequest) {
        if currentModalState != .userInformation {
            currentModalState = .userInformation
            ConfirmAccountModal.dismiss()
            UserInformationModal.dismiss()
            UserInformationModal.startUserInformationModal(on: view, info: userInfo, delegate: self, transitionDelegate: self)
        }
    }

    func presentCreatePasswordModal() {
        if currentModalState != .createPassword {
            currentModalState = .createPassword
            UserInformationModal.dismiss()
            ConfirmAccountModal.dismiss()
            if let userInfo = userInfo {
                CreatePasswordModal.startCreatePasswordModal(on: view, userInfo: userInfo, delegate: self, transitionDelegate: self)
            }
        }
    }
}
