//
//  UserInformationModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

public protocol InfoDelegate {
    func userInfo(info: SignUpRequest)
}

public class UserInformationModal: BaseXib {
    
    let nibName = "UserInformationModal"
    
    @IBOutlet weak var firstname: InputField!
    @IBOutlet weak var lastname: InputField!
    @IBOutlet weak var birthday: DatePicker!
    @IBOutlet weak var email: InputField!
    @IBOutlet weak var backBtn: UIImageView!
    
    var infoDelegate: InfoDelegate?
    weak var transitionDelegate: ModalTransitionDelegate?
    var userInfo: SignUpRequest?
    
    var phoneNumber: String?
    var emailAddress: String?
    
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
    
    @IBAction func continueTapped(_ sender: Any) {
        if valiidateFields(){
            let userinfo = SignUpRequest(first_name: firstname.text, last_name: lastname.text, dob: birthday.text.convertToBackendDate(from: birthday.text), phone_code: "+234", phone: phoneNumber, email: emailAddress, password: "", password_confirmation: "")
           
            infoDelegate?.userInfo(info: userinfo)
            print("user info sent: \(userinfo)")
        }
    }
    
    @objc func backBtnTapped(_ sender: Any) {
        UserInformationModal.dismiss()
        transitionDelegate?.presentConfirmAccountModal()
    }
    
    func valiidateFields() -> Bool{
        let validateFname = firstname.validate(rules: [Rule(.isEmpty, "First Name cannot be empty")])
        let validateLname = lastname.validate(rules: [Rule(.isEmpty, "Last Name cannot be empty")])
        let validateEmail = email.validate(rules: [Rule(.isEmpty, "Email cannot be empty")])
        let validateBirthday = birthday.validate(rules: [Rule(.isEmpty, "Birthday cannot be empty")])
        
        return validateFname && validateLname && validateEmail && validateBirthday
    }
    
    
//    func dismiss() {
//        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
//            self?.frame.origin.y = Helpers.screenHeight
//            self?.layoutIfNeeded()
//        }, completion: { [weak self] _ in
//            self?.superview?.removeFromSuperview()
//        })
//    }
    
    public static func dismiss() {
        if let subviews = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.subviews {
            for view in subviews {
                for v in view.subviews {
                    if v is UserInformationModal {
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
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
    }
    
    
    public static func startUserInformationModal(on view: UIView, info: SignUpRequest, delegate infoDel: InfoDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = UserInformationModal()
        modal.transitionDelegate = transDel
        modal.infoDelegate = infoDel
        modal.email.text = info.email ?? ""
        modal.firstname.text = info.first_name ?? ""
        modal.lastname.text = info.last_name ?? ""
        modal.birthday.selectedDate = info.dob?.convertFromBackendDate(from: info.dob ?? "")
        modal.emailAddress = info.email
        modal.phoneNumber = info.phone
        
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

