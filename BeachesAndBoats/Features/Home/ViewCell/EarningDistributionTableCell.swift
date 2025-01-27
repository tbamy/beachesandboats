//
//  EarningDistributionTableCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 01/01/2025.
//

import UIKit
import Kingfisher

class EarningDistributionTableCell: UITableViewCell {
    
    @IBOutlet weak var beachImg: UIImageView!
    @IBOutlet weak var beachNameLbl: BoldLabel!
    @IBOutlet weak var locationLbl: RegularLabel!
    @IBOutlet weak var amountLbl: MediumLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func setup(with data: BeachHouseData) {
//        if let beachImage = data.rooms?.first {
//            beachImg.image = UIImage(named: beachImage.images?.first ?? "")
//        }
//        beachNameLbl.text = data.name
//        locationLbl.text = "\(data.locations?.city ?? ""), \(data.locations?.state ?? ""), \(data.locations?.country ?? "")"
//        amountLbl.text = "+₦ \(GeneralFormatter.decimalToString(data.listingPrice ?? 0))"
//    }
    
    func setup(with data: TopEarningResponse?) {
        if let beachImage = data?.data?.topEarners.first?.value, let roomImage = beachImage.beachHouse?.category.image {
            
            let url = URL(string: roomImage)
            let processor = DownsamplingImageProcessor(size: beachImg.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 20)
            beachImg.kf.indicatorType = .activity
            beachImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
        
        if let beachName = data?.data?.topEarners.first?.value {
            beachNameLbl.text = beachName.beachHouse?.name
            locationLbl.text = "\(beachName.beachHouse?.locations.city ?? ""), \(beachName.beachHouse?.locations.state ?? ""), \(beachName.beachHouse?.locations.country ?? "")"
            amountLbl.text = "+₦ \(GeneralFormatter.decimalToString(((beachName.beachHouse?.listingPrice ?? 0))))"
        }
    }
    
}
