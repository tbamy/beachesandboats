//
//  SelectServiceType.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/09/2024.
//

import UIKit

class SelectServiceType: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    @IBOutlet weak var chefBtn: UIImageView!
    @IBOutlet weak var djBtn: UIImageView!
    @IBOutlet weak var bouncerBtn: UIImageView!
    
    var user = UserSession.shared.userDetails
    let chefRole: HostType = .chef
    let djRole: HostType = .dj
    let bouncerRole: HostType = .bouncer
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }

    func setup(){
        chefBtn.isUserInteractionEnabled = true
        djBtn.isUserInteractionEnabled = true
        bouncerBtn.isUserInteractionEnabled = true

        chefBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chefTapped)))
        djBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(djTapped)))
        bouncerBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bouncerTapped)))
    }
    
    func isChef() -> Bool{
        if let userRoles = user?.roles{
            
            let chefString = chefRole.rawValue
            let hasChefRole = userRoles.contains { chefString.contains($0)}
            
            if hasChefRole{
                return true
            }
        }
        return false
    }
    
    func isDj() -> Bool{
        if let userRoles = user?.roles{
            
            let djString = djRole.rawValue
            let hasDjRole = userRoles.contains { djString.contains($0)}
            
            if hasDjRole{
                return true
            }
        }
        return false
    }
    
    func isBouncer() -> Bool{
        if let userRoles = user?.roles{
            
            let bouncerString = bouncerRole.rawValue
            let hasBouncerRole = userRoles.contains { bouncerString.contains($0)}
            
            if hasBouncerRole{
                return true
            }
        }
        return false
    }
    
    func validate() -> Bool{
        if isChef() || isDj() || isBouncer(){
            return false
        }
        return true
    }

    @objc func chefTapped(_ sender: Any){
        if validate(){
            coordinator?.gotoChefInformationView()
        }else{
            Toast.show(message: "You can only provide one service at a time")
        }
        
    }
    
    @objc func djTapped(_ sender: Any){
        if validate(){
            coordinator?.gotoDJInformationView()
        }else{
            Toast.show(message: "You can only provide one service at a time")
        }
        
    }
    
    @objc func bouncerTapped(_ sender: Any){
        if validate(){
            coordinator?.gotoBouncerInformationView()
        }else{
            Toast.show(message: "You can only provide one service at a time")
        }
        
    }
}
