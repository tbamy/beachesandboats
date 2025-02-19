//
//  ContactSupportView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import UIKit

class ContactSupportView: UIViewController {
    
    @IBOutlet weak var callSupportStack: UIStackView!
    @IBOutlet weak var chatSupportStack: UIStackView!
    @IBOutlet weak var sendEmailStack: UIStackView!
    
    var coordinator: HostingServiceMenuCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Contact customer support"

        
    }


   

}
