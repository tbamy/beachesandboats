//
//  InitialListingPromptView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/09/2024.
//

import UIKit

class InitialListingPromptView: BaseViewControllerPlain {
    
    var coordinator: AccountCoordinator?

    @IBOutlet weak var closeBtn: UIImageView!
    @IBOutlet weak var proceedBtn: PrimaryButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        closeBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTapped)))
        
    }
    
    @objc func closeTapped(_ sender: Any) {
        coordinator?.pop()
    }

    @IBAction func proceedClicked(_ sender: Any) {
        coordinator?.gotoWhatAreYou()
    }
    
}
