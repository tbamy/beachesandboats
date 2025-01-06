//
//  ManageAccountView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class ManageAccountView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    @IBOutlet weak var firstNameField: InputField!
    @IBOutlet weak var lastNameField: InputField!
    @IBOutlet weak var emailAddressField: InputField!
    @IBOutlet weak var phoneNumberField: InputField!
    @IBOutlet weak var saveBtn: PrimaryButton!
    
    let userData = UserSession.shared.loginRes?.data?.user
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Manage Account"
        setupCustomNavigationButton()
        setupDetails()
    }
    
    func setupDetails(){
        emailAddressField.isUserInteractionEnabled = false
        phoneNumberField.isUserInteractionEnabled = false
        
        if let userInfo = userData{
            firstNameField.text = userInfo.first_name ?? ""
            lastNameField.text = userInfo.last_name ?? ""
            emailAddressField.text = userInfo.email ?? ""
            phoneNumberField.text = userInfo.phone_number ?? ""
        }
    }

     @IBAction func saveTapped(_ sender: Any) {
         
     }
    

}

extension ManageAccountView{
    func setupCustomNavigationButton() {
        let customButton = UIButton(type: .custom)
        customButton.setTitle("Save", for: .normal)
        customButton.tintColor = .beachBlue
        customButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        let customBarButtonItem = UIBarButtonItem(customView: customButton)
        navigationItem.rightBarButtonItem = customBarButtonItem
    }
}
