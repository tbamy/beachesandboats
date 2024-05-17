//
//  ContactSupportViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 16/05/2024.
//

import UIKit

class ContactSupportViewController: UIViewController {
    
    @IBOutlet weak var callSupportContainer: UIView!
    @IBOutlet weak var chatSupportContainer: UIView!
    @IBOutlet weak var sendEmailContainer: UIView!
    
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Contact customer support")
        setup()
    }
    
    func setup() {
        let call = UITapGestureRecognizer(target: self, action: #selector(callTapped))
        callSupportContainer.isUserInteractionEnabled = true
        callSupportContainer.addGestureRecognizer(call)
        
        let chat = UITapGestureRecognizer(target: self, action: #selector(chatTapped))
        chatSupportContainer.isUserInteractionEnabled = true
        chatSupportContainer.addGestureRecognizer(chat)
        
        let email = UITapGestureRecognizer(target: self, action: #selector(emailTapped))
        sendEmailContainer.isUserInteractionEnabled = true
        sendEmailContainer.addGestureRecognizer(email)
    }
    
    @objc func callTapped() {
        let callView = CallViewController()
        callView.modalPresentationStyle = .overCurrentContext
        callView.modalTransitionStyle = .coverVertical
        present(callView, animated: true)
    }
    
    @objc func chatTapped() {
        let chatView = ChatViewController()
        chatView.modalPresentationStyle = .automatic
//        chatView.modalTransitionStyle = .coverVertical
        present(chatView, animated: true)
    }
    
    @objc func emailTapped() {
       print("Email view is shown")
    }



}
