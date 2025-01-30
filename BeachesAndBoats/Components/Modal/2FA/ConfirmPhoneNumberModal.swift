//
//  ConfirmPhoneNumberModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

protocol GestureRecognizer: AnyObject {
    func changePhoneNumberTapped()
    func resendCodeTapped()
}

class ConfirmPhoneNumberModal: BaseXib {

    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var pinFieldsStack: UIStackView!
    @IBOutlet weak var sendBtn: PrimaryButton!
    @IBOutlet weak var changePhoneNumber: UILabel!
    @IBOutlet weak var resendCode: UILabel!
    @IBOutlet var otpCode: [PinField]!
    
    weak var confirmPhoneNumberDelegate: GestureRecognizer?
    

    let nibName = "ConfirmPhoneNumberModal"
    
    var callback: (String?) -> Void = { _ in }
    var typeOfSecurity: String? = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        sendBtn.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss(_ :))))
        changePhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleChangePhoneNumber(_ :))))
        resendCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleResendCode(_ :))))
        configureFields()
        otpSetup()
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func handleChangePhoneNumber(_ sender: UITapGestureRecognizer) {
        confirmPhoneNumberDelegate?.changePhoneNumberTapped()
    }
    
    @objc func handleResendCode(_ sender: UITapGestureRecognizer) {
        confirmPhoneNumberDelegate?.resendCodeTapped()
    }
    
    func otpSetup() {
        for otp in otpCode {
            otp.textAlignment = .center
        }
    }
    
    @objc func sendTapped() {
        var otpString = ""
        
        for otp in otpCode {
            if let text = otp.text, !text.isEmpty {
                otpString += text
                otp.textAlignment = .center
            } else {
                print("Please enter all OTP fields")
                return
            }
        }
        
        print("Concatenated OTP: \(otpString)")
        callback(otpString)
        dismiss()
    }

    func configureFields() {
        // Loop through each view in the stack and set them up
//        for view in pinFieldsStack.subviews {
//            if let pinField = view as? PinField {
//                pinField.isUserInteractionEnabled = true
//                pinField.keyboardType = .numberPad
//                pinField.delegate = self
//            }
//        }
        for otp in otpCode {
            otp.isUserInteractionEnabled = true
            otp.keyboardType = .numberPad
            otp.delegate = self
        }
    }
            

}

extension ConfirmPhoneNumberModal: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return false }

        // If it's a backspace and text is empty, move to previous field
        if string.isEmpty {
            if currentText.isEmpty {
                moveToPreviousField(currentField: textField)
            }
            return true
        }
        
        // If user enters a character, move to the next field
        if currentText.count == 0 && string.count == 1 {
            textField.text = string
            moveToNextField(currentField: textField)
            return false // return false to prevent adding the character twice
        }

        return false
    }
    
    // Method to move to the next field
    func moveToNextField(currentField: UITextField) {
//        guard let currentIndex = pinFieldsStack.subviews.firstIndex(of: currentField) else { return }
        guard let currentIndex = otpCode.firstIndex(of: currentField as! PinField) else { return }
        if currentIndex < otpCode.count - 1 {
            otpCode[currentIndex + 1].becomeFirstResponder()

//            if let nextField = pinFieldsStack.subviews[currentIndex + 1] as? PinField {
//                nextField.becomeFirstResponder()
//            }
        }
    }

    // Method to move to the previous field
    func moveToPreviousField(currentField: UITextField) {
//        guard let currentIndex = pinFieldsStack.subviews.firstIndex(of: currentField) else { return }
        guard let currentIndex = otpCode.firstIndex(of: currentField as! PinField) else { return }
        if currentIndex > 0 {
            otpCode[currentIndex - 1].becomeFirstResponder()

//            if let previousField = pinFieldsStack.subviews[currentIndex - 1] as? PinField {
//                previousField.becomeFirstResponder()
//            }
        }
    }
            
}

extension ConfirmPhoneNumberModal{
    
    public static func show(callBack: @escaping (String?) -> Void, isPhoneNumber: Bool) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = ConfirmPhoneNumberModal()
        modal.callback = callBack
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        if isPhoneNumber {
            modal.changePhoneNumber.text = "Change email address"
            
        } else {
            modal.changePhoneNumber.text = "Change phone number"
        }
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.5
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
}
