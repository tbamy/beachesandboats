//
//  ProfileView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 05/10/2024.
//

import UIKit

class ProfileView: UIViewController {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var manageProfileStack: UIStackView!
    @IBOutlet weak var savedStack: UIStackView!
    @IBOutlet weak var paymentStack: UIStackView!
    @IBOutlet weak var notificationStack: UIStackView!
    @IBOutlet weak var securityStack: UIStackView!
    @IBOutlet weak var supportStack: UIStackView!
    @IBOutlet weak var guidebookStack: UIStackView!
    @IBOutlet weak var listPropertyStack: UIStackView!
    @IBOutlet weak var switchStack: UIStackView!
    @IBOutlet weak var logoutStack: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Account"
        addGestureRecognizers()
    }
    
    func addGestureRecognizers(){
        manageProfileStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(manageProfileAction)))
        savedStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(savedAction)))
        paymentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(paymentAction)))
        notificationStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(notificationAction)))
        securityStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(securityAction)))
        supportStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(supportAction)))
        guidebookStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(guideBookAction)))
        listPropertyStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(listPropertyAction)))
        switchStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchAction)))
        logoutStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutAction)))
    }
    
    @objc func manageProfileAction(){
        coordinator?.gotoManageAccountView()
    }
    
    @objc func savedAction(){
        
    }
    
    @objc func paymentAction(){
        coordinator?.gotoProfilePaymentView()
    }
    
    @objc func notificationAction(){
        coordinator?.gotoNotificationSettings()
    }
    
    @objc func securityAction(){
        coordinator?.gotoLoginAndSecurityView()
    }
    
    @objc func supportAction(){
        
    }
    
    @objc func guideBookAction(){
        
    }
    
    @objc func listPropertyAction(){
        coordinator?.gotoinitialListingView()
    }
    
    @objc func switchAction(){
        
    }
    
    @objc func logoutAction(){
        
    }


}
