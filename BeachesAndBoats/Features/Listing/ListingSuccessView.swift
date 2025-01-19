//
//  ListingSuccessView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import Kingfisher

class ListingSuccessView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var bubbles: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    var type: Int?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let url = URL(string: "https://s3-alpha-sig.figma.com/img/1970/28c4/200aadee125067c02a76e8556574fc64?Expires=1731888000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=dpEB9KYljQoTQD-iCnu1nGYgbkudvFqzLykmYhRn~9ApaCDmDph6nN1V9c1txAoj7lU145lCHT16xxhnOEeWJGn-M5WRq4rLtNFT2osnyW9NOpXyMsHRpTqE6-Ti~Kfeq6czm4s3mk3O8mLOrAviJIoFuR2LCerIa7LqlPNhY0bqLDxnMKpJjpF57dZ9OzZUkbvXYG8zcsNF8iWmfC-r53iM8KZ5vpScr03-ovXgmNSjwROxJKT79v4fIuxuCadRk0PY-ndlhDB0lMCDOCtSBJdsK4oOL-eCUyaWbQ0gKZocIKVg3LYcQsysgC~CxKVOg7gD~DwZpZeDV2dhWYEUfg__") {
            bubbles.kf.setImage(with: url)
        }
        
        switch type {
        case 1:
            image.image = UIImage(named: "boatListingSuccess")
        case 2:
            image.image = UIImage(named: "beachListingSuccess")
        default:
            image.image = UIImage(named: "beachListingSuccess")
        }
        
    }

    @IBAction func finishListing(_ sender: Any) {
        coordinator?.backToHostingDashboard()
    }
    
}

//enum ListingSuccessImage: Int {
//    case BeachHouse = 1
//    case Boat = 2
//}
