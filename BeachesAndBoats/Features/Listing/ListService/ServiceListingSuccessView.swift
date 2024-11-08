//
//  ServiceListingSuccessView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 05/11/2024.
//

import UIKit
import Kingfisher

class ServiceListingSuccessView: UIViewController {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var bubbles: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: "https://s3-alpha-sig.figma.com/img/1970/28c4/200aadee125067c02a76e8556574fc64?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=dpEB9KYljQoTQD-iCnu1nGYgbkudvFqzLykmYhRn~9ApaCDmDph6nN1V9c1txAoj7lU145lCHT16xxhnOEeWJGn-M5WRq4rLtNFT2osnyW9NOpXyMsHRpTqE6-Ti~Kfeq6czm4s3mk3O8mLOrAviJIoFuR2LCerIa7LqlPNhY0bqLDxnMKpJjpF57dZ9OzZUkbvXYG8zcsNF8iWmfC-r53iM8KZ5vpScr03-ovXgmNSjwROxJKT79v4fIuxuCadRk0PY-ndlhDB0lMCDOCtSBJdsK4oOL-eCUyaWbQ0gKZocIKVg3LYcQsysgC~CxKVOg7gD~DwZpZeDV2dhWYEUfg__") {
            bubbles.kf.setImage(with: url)
        }
    }

    @IBAction func finishListing(_ sender: Any) {
        coordinator?.backToHostingDashboard()
    }
    
}
