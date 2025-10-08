//
//  EarningDistributionTableCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class EarningDistributionTableCell: UITableViewCell {
    
    @IBOutlet weak var beachImg: UIImageView!
    @IBOutlet weak var beachNameLbl: BoldLabel!
    @IBOutlet weak var locationLbl: RegularLabel!
    @IBOutlet weak var amountLbl: MediumLabel!
    
    var isBoat: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beachImg.layer.cornerRadius = 10
    }
    
    func setup(with topEarner: TopEarner?) {
        guard let topEarner = topEarner else {
            beachImg.image = UIImage(named: "dummy")
            beachNameLbl.text = "N/A"
            locationLbl.text = "N/A"
            amountLbl.text = "₦0"
            return
        }
        
        if let beachHouse = topEarner.beachHouse {
            isBoat = false
            
            // Set image
            if let imageUrlString = beachHouse.images.first?.url,
               let url = URL(string: imageUrlString) {
                beachImg.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
            } else {
                beachImg.image = UIImage(named: "dummy")
            }

            // Set name
            beachNameLbl.text = beachHouse.name ?? "N/A"

            // Set location
            if let locations = beachHouse.locations {
                locationLbl.text = "\(locations.jettyLocation ?? ""), \(locations.name ?? "")"
            } else {
                locationLbl.text = "N/A"
            }

        } else if let boat = topEarner.boat {
            isBoat = true
            
            // Set image
            if let imageUrlString = boat.images?.first?.url,
               let url = URL(string: imageUrlString) {
                beachImg.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
            } else {
                beachImg.image = UIImage(named: "dummy")
            }

            // Set name
            beachNameLbl.text = boat.name ?? "N/A"

            // Set location (adjust fields depending on Boat model)
            if let locations = boat.locations {
                locationLbl.text = "\(locations.jettyLocation ?? ""), \(locations.name ?? "")"
            } else {
                locationLbl.text = "N/A"
            }
        }

        // Amount (shared for both cases)
        if let totalEarnings = topEarner.totalEarnings {
            amountLbl.text = "+₦ \(GeneralFormatter.decimalToString(totalEarnings))"
        } else {
            amountLbl.text = "₦0"
        }
    }
    
}
