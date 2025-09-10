//
//  ListingSuccessView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class ListingSuccessView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var bubbles: UIImageView!
    @IBOutlet weak var image: UIImageView!
    
    var type: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch type {
        case 1:
            image.image = UIImage(named: "boatListingSuccess")
            AppStorage.boatListing = nil
        case 2:
            image.image = UIImage(named: "beachListingSuccess")
            AppStorage.beachListing = nil
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
