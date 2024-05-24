//
//  PhoneNumberBottomModal.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 14/05/2024.
//

import UIKit

protocol PhoneNumberBottomModalDelegate: AnyObject {
    func presentOTPModal()
}


class PhoneNumberBottomModal: UIViewController {
    
    @IBOutlet weak var modalContainer: UIView!
    @IBOutlet weak var sendOTPBtn: UIButton!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var gmailStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    
    var state: SecurityState?
    weak var phoneDelegate: PhoneNumberBottomModalDelegate?
    @IBOutlet weak var authType: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        gestureRecongizers()
        ViewlTopCornerRadius.shared.applyTopBorderRadius(to: modalContainer, radius: 20)

    }
    
    func setup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        modalContainer.layer.cornerRadius = 20
        sendOTPBtn.layer.cornerRadius = 10
        
        guard let state = state else {return}
        
        switch state {
        case .gmail:
            authType.text = "Add email address"
            phoneStack.isHidden = true
            gmailStack.isHidden = false
        case .phone:
            authType.text = "Add phone number"
            phoneStack.isHidden = false
            gmailStack.isHidden = true
        }
    }
    
    func gestureRecongizers() {
        let close = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(close)
    }
    
    @objc func closeTapped() {
        dismiss(animated: true, completion: nil)
    }


    @IBAction func sendOTPTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
        self.phoneDelegate?.presentOTPModal()
        
    }
    

}
