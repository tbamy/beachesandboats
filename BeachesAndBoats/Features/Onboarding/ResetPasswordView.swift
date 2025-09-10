//
//  ResetPasswordView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/02/2025.
//

import UIKit
import RxSwift

class ResetPasswordView: BaseViewControllerPlain {
    var coordinator: AppCoordinator?
    
    @IBOutlet weak var MustNotContainNameImg: UIImageView!
    @IBOutlet weak var MustNotContainNameLabel: UILabel!
    @IBOutlet weak var resetPasswordBtn: PrimaryButton!
    @IBOutlet weak var mustBe8CharactersLongImg: UIImageView!
    @IBOutlet weak var mustBe8CharactersLongLabel: UILabel!
    @IBOutlet weak var confirmPasswordField: PasswordField!
    @IBOutlet weak var mustContainSymbolImg: UIImageView!
    @IBOutlet weak var mustContainSymbolLabel: UILabel!
//    @IBOutlet weak var bothPasswordsMustMatchImg: UIImageView!
    @IBOutlet weak var mustNotHaveSpaceImg: UIImageView!
    @IBOutlet weak var mustNotHaveSpaceLabel: UILabel!
    @IBOutlet weak var newPasswordField: PasswordField!
    @IBOutlet weak var otpField: InputField!
    @IBOutlet weak var passwordStrengthLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var validator: ValidatorRule = .isEqualTo
    
    var passAllChecks = true
    
    
    var userEmail: String?
//    var userFullName: String?
    
    let vm = ResetPasswordVM()
    let disposeBag = DisposeBag()
    let input = PublishSubject<ResetPasswordVM.Input>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setup()
    }
    

    func setup(){
        resetPasswordBtn.isEnabled = false
        progressView.setProgress(0.0, animated: false)
        newPasswordField.textField.addTarget(self, action: #selector(passwordFieldChanged(_:)), for: .editingChanged)
        confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordFieldChanged(_:)), for: .editingChanged)
    }
    
    @objc func passwordFieldChanged(_ sender: UITextField) {
        updatePasswordStrength(password: sender.text ?? "")
    }
    
    @objc func confirmPasswordFieldChanged(_ sender: UITextField) {
        checkConfirmPassword()
    }
    
    
    func updatePasswordStrength(password: String) {
        var strength: Float = 0.0
        
        if password.count >= 8 {
            strength += 0.25
        }
        
        if validator.containsSymbol(password) {
            strength += 0.25
        }
        
        if validator.containsNumber(password) {
            strength += 0.25
        }
        
        
        if let email = userEmail{
            validator = .containsSubstring
            let lowercasedPassword = password.lowercased()
            var containsNameOrEmail = false
            
//            for namePart in name.lowercased().split(separator: " ") {
//                if validator.execute(lowercasedPassword, String(namePart)) {
//                    containsNameOrEmail = true
//                    break
//                }
//            }
            
            if validator.execute(lowercasedPassword, email.lowercased()) {
                containsNameOrEmail = true
            }
            
            if !containsNameOrEmail {
                strength += 0.25
            }
        }

        
        checkPassword()
        progressView.setProgress(strength, animated: true)
        
        switch strength {
        case 0.0..<0.25:
            passwordStrengthLabel.text = "Very Weak"
            progressView.progressTintColor = .systemRed
        case 0.25..<0.5:
            passwordStrengthLabel.text = "Weak"
            progressView.progressTintColor = .systemOrange
        case 0.5..<0.75:
            passwordStrengthLabel.text = "Moderate"
            progressView.progressTintColor = .systemYellow
        case 0.76...1.0:
            passwordStrengthLabel.text = "Strong"
            progressView.progressTintColor = .systemGreen
        default:
            passwordStrengthLabel.text = ""
        }
    }

   
    
    @objc func checkPassword() {
        
        passAllChecks = true
        
        validator = .containsSubstring
        if let email = userEmail {
            let lowercasedPassword = newPasswordField.text.lowercased()
//            let nameComponents = name.lowercased().split(separator: " ")
            
            var containsNameOrEmail = false
            
//            for namePart in nameComponents {
//                if validator.execute(lowercasedPassword, String(namePart)) {
//                    containsNameOrEmail = true
//                    break
//                }
//            }
            
            if validator.execute(lowercasedPassword, email.lowercased()) {
                containsNameOrEmail = true
            }
            
            if containsNameOrEmail {
                MustNotContainNameImg.image = UIImage(named: "error_black")
                MustNotContainNameLabel.textColor = .black
                passAllChecks = false
            } else {
                MustNotContainNameImg.image = UIImage(named: "green_check")
                MustNotContainNameLabel.textColor = .systemGreen
            }
        }

        
//        validator = .isEqualTo
//        if !validator.isEqualTo(value1: newPasswordField.text, value2: confirmPasswordField.text) {
//            passAllChecks = false
//        }
        
        validator = .isLessThan
        if validator.isLessThan(value1: newPasswordField.text.count, value2: 8) {
            mustBe8CharactersLongImg.image = UIImage(named: "error_black")
            mustBe8CharactersLongLabel.textColor = .black
            passAllChecks = false
        } else {
            mustBe8CharactersLongImg.image = UIImage(named: "green_check")
            mustBe8CharactersLongLabel.textColor = .systemGreen
        }

        
        validator = .hasSymbol
        if validator.containsSymbol(newPasswordField.text) && validator.containsNumber(newPasswordField.text) {
            mustContainSymbolImg.image = UIImage(named: "green_check")
            mustContainSymbolLabel.textColor = .systemGreen
        } else {
            mustContainSymbolImg.image = UIImage(named: "error_black")
            mustContainSymbolLabel.textColor = .black
            passAllChecks = false
        }
                
        
        validator = .doesNotContainSpace
        if validator.doesNotContainSpace(newPasswordField.text) {
            mustNotHaveSpaceImg.image = UIImage(named: "green_check")
            mustNotHaveSpaceLabel.textColor = .systemGreen
        } else {
            mustNotHaveSpaceImg.image = UIImage(named: "error_black")
            mustNotHaveSpaceLabel.textColor = .black
            passAllChecks = false
        }
        
        print(passAllChecks)
//        if passAllChecks {
//            createPasswordBtn.isEnabled = true
//        } else {
//            print("Password: \(newPasswordField.text) - Confirm Password: \(confirmPasswordField.text)")
//            createPasswordBtn.isEnabled = false
//        }
    }
    
    @objc func checkConfirmPassword() {
        print("Checks: \(passAllChecks)")
//        passAllChecks = true
        
        checkPassword()
        
        validator = .isEqualTo
        if !validator.isEqualTo(value1: newPasswordField.text, value2: confirmPasswordField.text) {
            passAllChecks = false
        }else{
            passAllChecks = true
        }
        
        if passAllChecks {
            resetPasswordBtn.isEnabled = true
        } else {
//            print("Password: \(newPasswordField.text) - Confirm Password: \(confirmPasswordField.text)")
            resetPasswordBtn.isEnabled = false
        }
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        let request = ResetPasswordRequest(email: userEmail ?? "", otp_code: otpField.text, new_password: newPasswordField.text, new_password_confirmation: confirmPasswordField.text)
        LoadingModal.show()
        print(request)
        input.onNext(.resetPassword(request))
    }
    

    
    func bind(){
        vm.transform(input: input)

        vm.output.subscribe(onNext: {[weak self] event in
            guard let self = self else { return }
            LoadingModal.dismiss()
            switch event {
            case .resetPasswordSuccess(let response):
                Toast.show(message: response.message ?? "")
                coordinator?.gotoLogin()
                
            case .resetPasswordFailed(let error):
                MiddleModal.show(title: "Oops", subtitle: error.message ?? "Error Occured", type: .error)
            }
        }).disposed(by: disposeBag)
    }
}
