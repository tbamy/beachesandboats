//
//  LoginAndSecurityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class LoginAndSecurityView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var currentPasswordField: InputField!
    @IBOutlet weak var newPasswordField: InputField!
    @IBOutlet weak var addBtn: PlainOutlineButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login and Security"
       
    }


    @IBAction func addBtnTapped(_ sender: Any) {
        
    }
}
