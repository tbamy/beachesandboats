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
            phone = phoneNumber.text
            LoadingModal.show()
            let request = ConfirmAccountRequest(phone_code: "234", phone_number: phoneNumber.text, email: emailAddress.text)
            print(request)
            vm.confirmAccount(request: request)
        }
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
            case .confirmAccountSuccess(_):
                presentConfirmAccountModal()
            case .confirmAccountError(let error):
                print(error)
                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: Otp Verification
            case .verifyCodeSuccess(_):
                let inf = SignUpRequest(first_name: "", last_name: "", dob: "", phone_code: "234", phone: phoneNumber.text, email: emailAddress.text, password: "", password_confirmation: "")
                ConfirmAccountModal.dismiss()
                presentUserInformationModal(userInfo: inf)
            case .verifyCodeError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
                
                //MARK: SignUp
            case .signUpSuccess(let response):
//                UserSession.shared.userDetails = response.user
                MiddleModal.show(title: response.message ?? "Registration Successful", type: .success, onConfirm: navigateToLogin)
            case .signUpError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
        }).disposed(by: disposeBag)
    }
    
    func navigateToLogin(){
        
        coordinator?.gotoLogin()
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
    func userOTP(otp: String?) {
        print(otp ?? "No otp")
        let request = VerifyCodeRequest(code: otp)
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
        ConfirmAccountModal.startConfirmModal(on: view, delegate: self, transitionDelegate: self)
    }

    func presentUserInformationModal(userInfo: SignUpRequest) {
        ConfirmAccountModal.dismiss()
        UserInformationModal.startUserInformationModal(on: view, info: userInfo, delegate: self, transitionDelegate: self)
    }
            
    
    
}
