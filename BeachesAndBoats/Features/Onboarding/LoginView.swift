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
    
    var vm = LoginViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        let signUpGesture = UITapGestureRecognizer(target: self, action: #selector(gotoSignUp))
        signUpBtn.isUserInteractionEnabled = true
        signUpBtn.addGestureRecognizer(signUpGesture)
        emailAddress.text = AppStorage.username ?? ""
        
        bindNetwork()
    }
    
    @objc func gotoSignUp(){
        coordinator?.gotoSignup()
    }

    @IBAction func continueTapped(_ sender: Any) {
        if validateFields(){
            LoadingModal.show()
            let request = LoginRequest(email: emailAddress.text, password: password.text)
            vm.login(request: request)
        }
        
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: { [weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .loginSuccess(let response):
//                UserSession.shared.userDetails = response.user
                AppStorage.username = response.user?.email
                UserSession.shared.loginRes = response
                self?.coordinator?.goToDashboard()
            case .loginError(let error):
                MiddleModal.show(title: error.message ?? "", type: .error)
            }
            
            
        }).disposed(by: disposeBag)
    }
    
    func validateFields() -> Bool{
        if emailAddress.text.isEmpty {
            emailAddress.error = "Please enter Email Address"
            return false
        }
        else if password.text.isEmpty {
            password.error = "Please enter your Password"
            return false
        }
        
        return true
    }
    
}
