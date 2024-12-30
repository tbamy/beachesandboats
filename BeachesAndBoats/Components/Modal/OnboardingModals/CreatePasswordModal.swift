//
//  CreatePasswordModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit


public protocol CreateAccountDelegate {
    func signUpInfo(info: SignUpRequest)
}

class CreatePasswordModal: BaseXib {
    
    @IBOutlet weak var MustNotContainNameImg: UIImageView!
    @IBOutlet weak var MustNotContainNameLabel: UILabel!
    @IBOutlet weak var createPasswordBtn: PrimaryButton!
    @IBOutlet weak var mustBe8CharactersLongImg: UIImageView!
    @IBOutlet weak var mustBe8CharactersLongLabel: UILabel!
    @IBOutlet weak var confirmPasswordField: PasswordField!
    @IBOutlet weak var mustContainSymbolImg: UIImageView!
    @IBOutlet weak var mustContainSymbolLabel: UILabel!
//    @IBOutlet weak var bothPasswordsMustMatchImg: UIImageView!
    @IBOutlet weak var mustNotHaveSpaceImg: UIImageView!
    @IBOutlet weak var mustNotHaveSpaceLabel: UILabel!
    @IBOutlet weak var newPasswordField: PasswordField!
    @IBOutlet weak var backBtn: UIImageView!
    @IBOutlet weak var passwordStrengthLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    var validator: ValidatorRule = .isEqualTo
    
    var passAllChecks = true
    
    var nibName = "CreatePasswordModal"
    var userInfo: SignUpRequest?
    var createAccountDelegate: CreateAccountDelegate?
    
    var userEmail: String?
    var userFullName: String?
    
    weak var transitionDelegate: ModalTransitionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func getNibName() -> String? {
        return nibName
    }
    

    func setup(){
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
        createPasswordBtn.isEnabled = false
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
        
        
        if let email = userEmail, let name = userFullName {
            validator = .containsSubstring
            let lowercasedPassword = password.lowercased()
            var containsNameOrEmail = false
            
            for namePart in name.lowercased().split(separator: " ") {
                if validator.execute(lowercasedPassword, String(namePart)) {
                    containsNameOrEmail = true
                    break
                }
            }
            
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
    
            
    
    @objc func backBtnTapped(_ sender: Any) {
        CreatePasswordModal.dismiss()
        let info = SignUpRequest(first_name: userInfo?.first_name, last_name: userInfo?.last_name, email: userInfo?.email, birthday: userInfo?.birthday, password: userInfo?.password, password_confirmation: userInfo?.password_confirmation, keep_signed_in: userInfo?.keep_signed_in, phone_number: userInfo?.phone_number, device_id: userInfo?.device_id)
    
        transitionDelegate?.presentUserInformationModal(userInfo: info)
    }

   
    
    @objc func checkPassword() {
        
        passAllChecks = true
        
        validator = .containsSubstring
        if let email = userEmail, let name = userFullName {
            let lowercasedPassword = newPasswordField.text.lowercased()
            let nameComponents = name.lowercased().split(separator: " ")
            
            var containsNameOrEmail = false
            
            for namePart in nameComponents {
                if validator.execute(lowercasedPassword, String(namePart)) {
                    containsNameOrEmail = true
                    break
                }
            }
            
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
            createPasswordBtn.isEnabled = true
        } else {
            print("Password: \(newPasswordField.text) - Confirm Password: \(confirmPasswordField.text)")
            createPasswordBtn.isEnabled = false
        }
    }
    
    @IBAction func continueBtnAction(_ sender: Any) {
        
        let request = SignUpRequest(first_name: userInfo?.first_name, last_name: userInfo?.last_name, email: userInfo?.email, birthday: userInfo?.birthday, password: newPasswordField.text, password_confirmation: confirmPasswordField.text, keep_signed_in: userInfo?.keep_signed_in, phone_number: userInfo?.phone_number, device_id: userInfo?.device_id)
        
        createAccountDelegate?.signUpInfo(info: request)
    }
    

}


extension CreatePasswordModal{
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let subviews = keyWindow.subviews
            for view in subviews {
                for v in view.subviews {
                    if v is CreatePasswordModal {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                            v.frame.origin.y = Helpers.screenHeight
                            view.layoutIfNeeded()
                        }, completion: { _ in
                            view.removeFromSuperview()
                        })
                    }
                }
            }
        }
    }
    
    public static func startCreatePasswordModal(on view: UIView, userInfo: SignUpRequest, delegate del: CreateAccountDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = CreatePasswordModal()
        modal.createAccountDelegate = del
        modal.transitionDelegate = transDel
        modal.userInfo = userInfo
        modal.userEmail = userInfo.email
        modal.userFullName = "\(userInfo.first_name ?? "") \(userInfo.last_name ?? "")"
        
        modal.layer.cornerRadius = 20
        modal.backgroundColor = .white
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
}
