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
            
            let userInfo = SignUpRequest(first_name: firstname.text, last_name: lastname.text, email: emailAddress, birthday: birthday.text, password: "", password_confirmation: "", keep_signed_in: userInfo?.keep_signed_in, phone_number: phoneNumber, device_id: UserDevice().imei)
            
            infoDelegate?.userInfo(info: userInfo)
            print("user info sent: \(userInfo)")
        }
    }
    
    @objc func backBtnTapped(_ sender: Any) {
        UserInformationModal.dismiss()
        if let signupView = transitionDelegate as? SignupView {
            signupView.currentModalState = .confirmAccount
            signupView.presentConfirmAccountModal()
        }
    }
    
    func valiidateFields() -> Bool{
        let validateFname = firstname.validate(rules: [Rule(.isEmpty, "First Name cannot be empty")])
        let validateLname = lastname.validate(rules: [Rule(.isEmpty, "Last Name cannot be empty")])
        let validateEmail = email.validate(rules: [Rule(.isEmpty, "Email cannot be empty")])
        let validateBirthday = birthday.validate(rules: [Rule(.isEmpty, "Birthday cannot be empty")])
        
        
        
        return validateFname && validateLname && validateEmail && validateBirthday
    }
    
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            print("Key window subviews before dismissal: \(keyWindow.subviews)")
            let allViews = keyWindow.subviews
            for view in allViews {
                if view.tag == 1001 || view.backgroundColor == .gray.withAlphaComponent(0.5) {
                    for subview in view.subviews {
                        if subview is UserInformationModal {
                            print("Found UserInformationModal in view hierarchy")
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                                subview.frame.origin.y = Helpers.screenHeight
                                view.layoutIfNeeded()
                            }, completion: { _ in
                                print("Removing backdrop: \(view)")
                                view.removeFromSuperview()
                            })
                            return
                        }
                    }
                    // Remove orphaned backdrop
                    print("Removing orphaned backdrop: \(view)")
                    view.removeFromSuperview()
                }
            }
            print("No UserInformationModal found in key window")
        } else {
            print("No key window found")
        }
    }
    
    //    public static func dismiss() {
    //        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
    //           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
    //            
    //            let subviews = keyWindow.subviews
    //            for view in subviews {
    //                for v in view.subviews {
    ////                    if v is UserInformationModal {
    //                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
    //                            v.frame.origin.y = Helpers.screenHeight
    //                            view.layoutIfNeeded()
    //                        }, completion: { _ in
    //                            view.removeFromSuperview()
    //                        })
    ////                    }
    //                }
    //            }
    //        }
    //    }
    
    func setup() {
        birthday.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
    }
    
    public static func startUserInformationModal(on view: UIView, info: SignUpRequest, delegate infoDel: InfoDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        backDrop.tag = 1001 // Unique tag for UserInformationModal backdrop
        
        let modal = UserInformationModal()
        modal.transitionDelegate = transDel
        modal.infoDelegate = infoDel
        modal.email.text = info.email ?? ""
        modal.firstname.text = info.first_name ?? ""
        modal.lastname.text = info.last_name ?? ""
        modal.birthday.selectedDate = info.birthday?.convertFromBackendDate(from: info.birthday ?? "")
        modal.emailAddress = info.email
        modal.phoneNumber = info.phone_number
        
        modal.layer.cornerRadius = 20
        modal.backgroundColor = .white
        modal.clipsToBounds = true
        
        backDrop.addSubview(modal)
        // Add to key window for consistency
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        } else {
            view.addSubview(backDrop) // Fallback to parent view if key window is unavailable
        }
        
        let height = Helpers.screenHeight * 0.9
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
}
    
//    public static func startUserInformationModal(on view: UIView, info: SignUpRequest, delegate infoDel: InfoDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
////        let backDrop = UIView(frame: Helpers.screen)
////        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
//        
//        let modal = UserInformationModal()
//        modal.transitionDelegate = transDel
//        modal.infoDelegate = infoDel
//        modal.email.text = info.email ?? ""
//        modal.firstname.text = info.first_name ?? ""
//        modal.lastname.text = info.last_name ?? ""
//        modal.birthday.selectedDate = info.birthday?.convertFromBackendDate(from: info.birthday ?? "")
//        modal.emailAddress = info.email
//        modal.phoneNumber = info.phone_number
//        
//        modal.layer.cornerRadius = 20
//        modal.backgroundColor = .white
//        modal.clipsToBounds = true
//        
//        let backDrop = UIView(frame: Helpers.screen)
//        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
//        backDrop.addSubview(modal)
//        view.addSubview(backDrop)
////        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: 800)
////        view.layoutIfNeeded()
////        
////        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
////            modal.frame.origin.y = Helpers.screenHeight  - 800 + modal.layer.cornerRadius
////            view.layoutIfNeeded()
////        }, completion: nil)
//        
////        backDrop.addSubview(modal)
////        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
////           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
////            keyWindow.addSubview(backDrop)
////        }
//        let height = Helpers.screenHeight * 0.9
//        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
//        backDrop.layoutIfNeeded()
//        
//        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
//            modal.frame.origin.y = Helpers.screenHeight - height
//            backDrop.layoutIfNeeded()
//        }, completion: nil)
//    }
//}

