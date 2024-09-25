//
//  ConfirmAccountModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

public protocol OTPDelegate {
    func userOTP(otp: String?)
    func resendOTP()
}

public protocol ModalTransitionDelegate: AnyObject {
    func presentUserInformationModal(userInfo: SignUpRequest)
    func presentCreatePasswordModal()
    func presentConfirmAccountModal()
}

public class ConfirmAccountModal: BaseXib {
    
    let nibName = "ConfirmAccountModal"
    
    @IBOutlet weak var otpField: InputField!
    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var checkboxBtn: CheckboxButton!
    @IBOutlet weak var resendCodeBtn: UILabel!
    @IBOutlet weak var timeCountdown: UILabel!
    @IBOutlet weak var timeStack: UIStackView!
    
    var otpDelegate: OTPDelegate?
    weak var transitionDelegate: ModalTransitionDelegate?
    private var countdownTimer: CountdownTimer!
    
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
    
    @IBAction func proceedTapped(_ sender: Any) {
        if validateOtpField(){
            otpDelegate?.userOTP(otp: otpField.text)
        }
        
    }
    
    @objc func closeTapped(_ sender: Any) {
        ConfirmAccountModal.dismiss()
    }
    
    func setupCountdown(){
        countdownTimer = CountdownTimer(minutes: 1)
    
        countdownTimer.start(
            updateHandler: { [weak self] timeString in
                self?.timeCountdown.text = timeString
            },
            completion: { [weak self] in
                self?.timeStack.isHidden = true
                self?.resendCodeBtn.isHidden = false
            }
        )
                
    }
    
    func validateOtpField() -> Bool {
        if otpField.text.isEmpty {
            otpField.error = "Please enter PIN"
            return false
        }
        else if otpField.text.count < otpField.numberOfCharacters {
            otpField.error = "Please enter a valid PIN"
            return false
        }
        
        return true
    }

    
//    func dismiss() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
//            self?.frame.origin.y = Helpers.screenHeight
//            self?.layoutIfNeeded()
//        }, completion: { [weak self] _ in
//            self?.superview?.removeFromSuperview()
//        })
//        
//    }
    
    public static func dismiss() {
        if let subviews = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.subviews {
            for view in subviews {
                for v in view.subviews {
                    if v is ConfirmAccountModal {
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
        

            
    
    func setup() {
        resendCodeBtn.isHidden = true
        resendCodeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resendOtpTapped)))
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
    }
    
    @objc func resendOtpTapped(){
        otpDelegate?.resendOTP()
        timeStack.isHidden = false
        resendCodeBtn.isHidden = true
    }
    
//    func sendOtp(){
//        LoadingModal.show()
//        let request = OTPandPasscodeRequest(phoneNumber: phoneNumber, adminPhoneNumber: adminPhoneNumber, emailAddress: email, name: name, customerId: customerId, purpose: .MultipleSignatoryApproverSoftTokenRequestOtp, deliveryType: .PhoneNumber, purposeReference: purpose)
//        
//        input.onNext(.oTPandPasscodeRequest(request))
//    }
    
    @objc func handleDismissal() {
        ConfirmAccountModal.dismiss()
    } 
    
    public static func startConfirmModal(on view: UIView, delegate otpDel: OTPDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = ConfirmAccountModal()
        modal.otpDelegate = otpDel
        modal.transitionDelegate = transDel
        
        modal.layer.cornerRadius = 20
        modal.backgroundColor = .white
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(backDrop)
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
}