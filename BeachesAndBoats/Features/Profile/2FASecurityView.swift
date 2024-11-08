//
//  2FASecurityView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

class _FASecurityView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var gmailStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Login and Security"

        gmailStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(gmailTapped(_ :))))
        phoneStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(phoneTapped(_ :))))
    }

    @objc func gmailTapped(_ sender: UITapGestureRecognizer){
        
    }
    
    @objc func phoneTapped(_ sender: UITapGestureRecognizer){
        
    }

}
