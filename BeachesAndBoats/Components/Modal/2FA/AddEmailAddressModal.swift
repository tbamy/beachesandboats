//
//  AddEmailAddressModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class AddEmailAddressModal: BaseXib {

    @IBOutlet weak var close: UIImageView!
    @IBOutlet weak var emailField: InputField!
    @IBOutlet weak var sendBtn: PrimaryButton!
    

    let nibName = "AddEmailAddressModal"
    
    var callback: (String?) -> Void = { _ in }
    
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
    }
    
    @objc func handleDismiss(_ sender: UITapGestureRecognizer) {
        dismiss()
    }
    
    @objc func sendTapped(){
        if validate() {
            callback(emailField.text)
            dismiss()
        }
        
    }
    
    func validate() -> Bool{
        if emailField.text.isEmpty  {
            emailField.error = "Please enter Email Address"
            return false
        } else if !isValidEmail(emailField.text) {
            emailField.error = "Please enter a valid email"
            return false
        }
        
        return true
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

}

extension AddEmailAddressModal{
    
    public static func show(callBack: @escaping (String?) -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = AddEmailAddressModal()
        modal.callback = callBack
        
        modal.backgroundColor = .background.lighter(by: 17)
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.4
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
