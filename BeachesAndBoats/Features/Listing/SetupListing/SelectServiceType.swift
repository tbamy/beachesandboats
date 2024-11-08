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

    @objc func chefTapped(_ sender: Any){
        coordinator?.gotoChefInformationView()
    }
    
    @objc func djTapped(_ sender: Any){
        coordinator?.gotoDJInformationView()
    }
    
    @objc func bouncerTapped(_ sender: Any){
        coordinator?.gotoBouncerInformationView()
    }
}
