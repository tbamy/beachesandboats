//
//  WhatAreYouView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/09/2024.
//

import UIKit

class WhatAreYouView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    @IBOutlet weak var primaryHostView: UIView!
    @IBOutlet weak var secondaryHostView: UIView!
    @IBOutlet weak var serviceProviderView: UIView!
    @IBOutlet weak var proceedBtn: PrimaryButton!
    
    var selected: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    
    func setup(){
        navigationItem.hidesBackButton = true
        proceedBtn.isEnabled = false
        primaryHostView.layer.cornerRadius = 8
        secondaryHostView.layer.cornerRadius = 8
        serviceProviderView.layer.cornerRadius = 8
        primaryHostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(primaryHostSelected)))
        secondaryHostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondaryHostSelected)))
        serviceProviderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(serviceProviderSelected)))
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        switch selected {
        case "Primary":
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
        case "Secondary":
            coordinator?.gotoSelectPropertyTypeSecondaryHost()
        case "Service":
            coordinator?.gotoSelectServiceType()
        default:
            coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
        }
        
    }
    
    @objc func primaryHostSelected(){
        selected = "Primary"
        primaryHostView.backgroundColor = .bBLight
        secondaryHostView.backgroundColor = .white
        serviceProviderView.backgroundColor = .white
        proceedBtn.isEnabled = true
    }
    
    @objc func secondaryHostSelected(){
        selected = "Secondary"
        primaryHostView.backgroundColor = .white
        secondaryHostView.backgroundColor = .bBLight
        serviceProviderView.backgroundColor = .white
        proceedBtn.isEnabled = true
    }
    
    @objc func serviceProviderSelected(){
        selected = "Service"
        primaryHostView.backgroundColor = .white
        secondaryHostView.backgroundColor = .white
        serviceProviderView.backgroundColor = .bBLight
        proceedBtn.isEnabled = true
    }

}
