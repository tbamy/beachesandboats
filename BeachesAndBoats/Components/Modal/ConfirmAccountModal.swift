//
//  ConfirmAccountModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

public protocol OTPDelegate {
    func userOTP(otp: String?)
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
    
    var otpDelegate: OTPDelegate?
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
    
    @IBAction func proceedTapped(_ sender: Any) {
        if validateOtpField(){
            otpDelegate?.userOTP(otp: otpField.text)
        }
        
    }
    
    @objc func closeTapped(_ sender: Any) {
        ConfirmAccountModal.dismiss()
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
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
    }
    
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
