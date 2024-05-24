//
//  otpBottomModalViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 14/05/2024.
//

import UIKit

class otpBottomModalViewController: UIViewController {
    
    @IBOutlet weak var otpStack: UIStackView!
    @IBOutlet weak var changePhoneOrEmail: UIButton!
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var heading: UILabel!
    
    var coordinator: AppCoordinator?
    var state: SecurityState?
    var authState = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizer()
        setup()

    }
    
    func setup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        
        changePhoneOrEmail.setTitle(authState, for: .normal)
        
        guard let state = state else { return }
        switch state {
        case .gmail:
            heading.text = "gmmo"
            changePhoneOrEmail.titleLabel?.text = "Change email address"
        case .phone:
            heading.text = "phono"
            changePhoneOrEmail.titleLabel?.text = "Change phone number"
        }
        
    }
    
    func gestureRecognizer() {
       closeView(for: closeIcon)
    }
}
