//
//  HostingCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by WEMA on 31/12/2024.
//

import UIKit
import Kingfisher

class HostingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var daysLbl: CustomLabel!
    @IBOutlet weak var beachHouseImage: UIImageView!
    @IBOutlet weak var beachName: BoldLabel!
    @IBOutlet weak var locationLbl: LightLabel!
    @IBOutlet weak var date: LightLabel!
    @IBOutlet weak var emptyLbl: LightLabel!
    @IBOutlet weak var locationImg: UIImageView!
    @IBOutlet weak var calendarImg: UIImageView!
    @IBOutlet weak var daysView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupHostingCell(with data: BeachHouseBookingDetails?) {
        
        guard let data = data, let beachHouse = data.beachHouse else {
            daysView.isHidden = true
            beachName.isHidden = true
            locationLbl.isHidden = true
            date.isHidden = true
            beachHouseImage.isHidden = true
            locationImg.isHidden = true
            calendarImg.isHidden = true
            emptyLbl.isHidden = false
            emptyLbl.text = "No data available"
            return
        }
        emptyLbl.isHidden = true
        daysView.isHidden = false
        beachName.isHidden = false
        locationLbl.isHidden = false
        date.isHidden = false
        beachHouseImage.isHidden = false
        
        daysLbl.text = data.beachHouse?.availabilities?.availableFrom
        beachName.text = data.beachHouse?.name
        locationLbl.text = "\(data.beachHouse?.locations?.city ?? ""), \(data.beachHouse?.locations?.state ?? ""), \(data.beachHouse?.locations?.country ?? "")"
        date.text = data.checkingDate

        
        let url = URL(string: data.beachHouse?.image ?? "")
        let processor = DownsamplingImageProcessor(size: beachHouseImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        beachHouseImage.kf.indicatorType = .activity
        beachHouseImage.kf.setImage(
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
}
