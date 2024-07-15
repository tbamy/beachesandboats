//
//  UserInformationModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

public protocol InfoDelegate {
    func userInfo(info: userInfoModel)
}

public class UserInformationModal: BaseXib {
    
    let nibName = "UserInformationModal"
    
    @IBOutlet weak var firstname: InputField!
    @IBOutlet weak var lastname: InputField!
    @IBOutlet weak var birthday: DatePicker!
    @IBOutlet weak var email: InputField!
    @IBOutlet weak var backBtn: UIImageView!
    
    var infoDelegate: InfoDelegate?
    
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
        // Add actions for the continue button if needed
    }
    
    @objc func backBtnTapped(_ sender: Any) {
        dismiss()
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
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnTapped)))
    }
    
    @objc func handleDismissal() {
        dismiss()
    }
    
    public static func startUserInformationModal(on view: UIView, delegate del: InfoDelegate, transitionDelegate transDel: ModalTransitionDelegate) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = UserInformationModal()
        modal.infoDelegate = del
        
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

public struct userInfoModel {
    let firstName: String?
    let lastName: String?
    let birthday: String?
    let email: String?
}
