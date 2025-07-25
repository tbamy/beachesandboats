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
    
    var user = UserSession.shared.userDetails
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
    
    // Using enum for better type safety
    enum SelectionType {
        case primary
        case secondary
        case service
        case none
    }
    
    var selected: SelectionType = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func setupTapped(_ sender: Any) {
        coordinator?.backToDashboard()
    }
    
    func setup(){
        // navigationItem.hidesBackButton = true
        proceedBtn.isEnabled = false
        
        // Set corner radius for all views
        [primaryHostView, secondaryHostView, serviceProviderView].forEach {
            $0?.layer.cornerRadius = 8
        }
        
        // Add gesture recognizers
        primaryHostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(primaryHostSelected)))
        secondaryHostView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondaryHostSelected)))
        serviceProviderView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(serviceProviderSelected)))
    }
    
    func validateHostRole() -> Bool {
        guard let userRoles = user?.roles else { return false }
        
        let hostRoleStrings = hostRoles.map { $0.rawValue }
        return userRoles.contains { hostRoleStrings.contains($0) }
    }
    
    func validateServiceRole() -> Bool {
        guard let userRoles = user?.roles else { return false }
        
        let serviceRoleStrings = serviceRoles.map { $0.rawValue }
        return userRoles.contains { serviceRoleStrings.contains($0) }
    }
    
    @IBAction func proceedTapped(_ sender: Any) {
        switch selected {
        case .primary:
            if validateServiceRole() {
                Toast.show(message: "You are already a service provider, you cannot list properties")
            } else {
                coordinator?.gotoSelectPropertyTypePrimaryHost(tag: 2, type: .primaryHost)
            }
            
        case .secondary:
            if validateServiceRole() {
                Toast.show(message: "You are already a service provider, you cannot list properties")
            } else {
                coordinator?.gotoSelectPropertyTypeSecondaryHost()
            }
            
        case .service:
            if validateHostRole() {
                Toast.show(message: "You are already a host, you cannot be service provider")
            } else {
                coordinator?.gotoSelectServiceType()
            }
            
        case .none:
            // Handle case where nothing is selected (shouldn't happen since button is disabled)
            break
        }
    }
    
    // Helper function to reset all view backgrounds
    private func resetViewBackgrounds() {
        primaryHostView.backgroundColor = .white
        secondaryHostView.backgroundColor = .white
        serviceProviderView.backgroundColor = .white
    }
    
    @objc func primaryHostSelected() {
        selected = .primary
        resetViewBackgrounds()
        primaryHostView.backgroundColor = .bBLight
        proceedBtn.isEnabled = true
    }
    
    @objc func secondaryHostSelected() {
        selected = .secondary
        resetViewBackgrounds()
        secondaryHostView.backgroundColor = .bBLight
        proceedBtn.isEnabled = true
    }
    
    @objc func serviceProviderSelected() {
        selected = .service
        resetViewBackgrounds()
        serviceProviderView.backgroundColor = .bBLight
        proceedBtn.isEnabled = true
    }
}
