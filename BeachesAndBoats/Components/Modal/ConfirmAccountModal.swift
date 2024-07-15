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

public class ConfirmAccountModal: BaseXib {
    
    let nibName = "ConfirmAccountModal"
    
    @IBOutlet weak var otpField: InputField!
    @IBOutlet weak var close: UIImageView!
    
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
        dismissAndPresentNextModal()
    }
    
    @objc func closeTapped(_ sender: Any) {
        dismiss()
    }
    
    private func dismissAndPresentNextModal() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
            self?.transitionDelegate?.presentUserInformationModal()
        })
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
            
    
    func setup() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissal))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
        close.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
    }
    
    @objc func handleDismissal() {
        dismiss()
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
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
}
