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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        beachImg.layer.cornerRadius = 10
    }
    
    func setup(with topEarner: TopEarner?) {
        guard let topEarner = topEarner, let beachHouse = topEarner.beachHouse else {
            beachImg.image = UIImage(named: "dummy")
            beachNameLbl.text = "N/A"
            locationLbl.text = "N/A"
            amountLbl.text = "₦0"
            return
        }
                    

        // Set beach image
        if let imageUrlString = beachHouse.images.first?.url, let url = URL(string: imageUrlString) {
            beachImg.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        } else {
            beachImg.image = UIImage(named: "dummy")
        }

        // Set beach name
        beachNameLbl.text = beachHouse.name ?? "N/A"

        // Set location
        if let locations = beachHouse.locations {
            locationLbl.text = "\(locations.jettyLocation ?? ""), \(locations.name ?? "")"
        } else {
            locationLbl.text = "N/A"
        }

        // Set amount (use total_earnings instead of listingPrice)
        if let totalEarnings = topEarner.totalEarnings {
            amountLbl.text = "+₦ \(GeneralFormatter.decimalToString(totalEarnings))"
        } else {
            amountLbl.text = "₦0"
        }
    }
    
//    func setup(with data: TopEarningResponse?) {
//        if let beachImage = data?.data?.topEarners.first?.value, let roomImage = beachImage.beachHouse?.category.image {
//            
//            let url = URL(string: roomImage)
//            beachImg.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
//        }
//        
//        if let beachName = data?.data?.topEarners.first?.value {
//            beachNameLbl.text = beachName.beachHouse?.name
//            locationLbl.text = "\(beachName.beachHouse?.locations.jettyLocation ?? ""), \(beachName.beachHouse?.locations.name ?? "")"
//            amountLbl.text = "+₦ \(GeneralFormatter.decimalToString(((beachName.beachHouse?.listingPrice ?? 0))))"
//        }
//    }
    
}
