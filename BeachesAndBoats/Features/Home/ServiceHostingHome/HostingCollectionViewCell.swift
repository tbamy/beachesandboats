//
//  HostingCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
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
    @IBOutlet weak var availabilityDate: UILabel!
    @IBOutlet weak var reservationCalendar: UIImageView!
    @IBOutlet weak var amountPerNight: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.04
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.shadowRadius = 10
    }
    
    //For beach reservation
    func currentHostingCell(with data: BeachHouseReservationsCurrentReservation?) {
        beachName.text = data?.beachHouse?.name
        locationLbl.text = "\(data?.beachHouse?.locations?.city ?? ""), \(data?.beachHouse?.locations?.state ?? ""), \(data?.beachHouse?.locations?.country ?? "")"
        availabilityDate.text = "\(data?.beachHouse?.availabilities?.availableFrom ?? "") - \(data?.beachHouse?.availabilities?.availableTo ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.beachHouseRoom?.pricePerNight ?? 0.00) / night"
        beachHouseImage.image = UIImage(named: data?.beachHouse?.image ?? "")
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.beachHouse?.image)
    }
    
    //For boat reservation
    func boatCurrentHostingCell(with data: BoatReservationsCurrentReservation?) {
        beachName.text = data?.boat?.name
        locationLbl.text = "\(data?.boat?.locations?.city ?? ""), \(data?.boat?.locations?.state ?? ""), \(data?.boat?.locations?.country ?? "")"
        availabilityDate.text = "\(data?.boat?.availabilities?.availableFrom ?? "") - \(data?.boat?.availabilities?.availableTo ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.boat?.rating ?? 0)"
        amountPerNight.isHidden = true
//        amountPerNight.text = "₦\(data?.boat?.pricePerNight ?? 0.00) / night"
        beachHouseImage.image = UIImage(named: data?.boat?.images ?? "")
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.boat?.images)
    }
    
    func upcomingHostingCell(with data: BeachHouseReservationsCurrentReservation?) {
        beachName.text = data?.beachHouse?.name
        locationLbl.text = "\(data?.beachHouse?.locations?.city ?? ""), \(data?.beachHouse?.locations?.state ?? ""), \(data?.beachHouse?.locations?.country ?? "")"
        availabilityDate.text = "\(data?.beachHouse?.availabilities?.availableFrom ?? "") - \(data?.beachHouse?.availabilities?.availableTo ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.beachHouseRoom?.pricePerNight ?? 0.00) / night"
        beachHouseImage.image = UIImage(named: data?.beachHouse?.image ?? "")
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.beachHouse?.image)
    }
    
    func cancelledBookingCell(with data: BeachHouseReservationsCurrentReservation?) {
        beachName.text = data?.beachHouse?.name
        locationLbl.text = "\(data?.beachHouse?.locations?.city ?? ""), \(data?.beachHouse?.locations?.state ?? ""), \(data?.beachHouse?.locations?.country ?? "")"
        availabilityDate.text = "\(data?.beachHouse?.availabilities?.availableFrom ?? "") - \(data?.beachHouse?.availabilities?.availableTo ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.beachHouseRoom?.pricePerNight ?? 0.00) / night"
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.beachHouse?.image)

    }
    
    func setupHostingCell(with data: BeachHouseBookingDetails?) {
        reservationCalendar.isHidden = true
        amountPerNight.isHidden = true
        
        guard let data = data, let beachHouse = data.beachHouse else {
            //            daysView.isHidden = true
            //            beachName.isHidden = true
            //            locationLbl.isHidden = true
            //            date.isHidden = true
            //            beachHouseImage.isHidden = true
            //            locationImg.isHidden = true
            //            calendarImg.isHidden = true
            //            emptyLbl.isHidden = false
            //            emptyLbl.text = "No data available"
            handleEmptyCell(isEmpty: true)
            return
        }
        handleEmptyCell(isEmpty: false)
        
        //        emptyLbl.isHidden = true
        //        daysView.isHidden = false
        //        beachName.isHidden = false
        //        locationLbl.isHidden = false
        //        date.isHidden = false
        //        beachHouseImage.isHidden = false
        //
        daysLbl.text = data.beachHouse?.availabilities?.availableFrom
        beachName.text = data.beachHouse?.name
        locationLbl.text = "\(data.beachHouse?.locations?.city ?? ""), \(data.beachHouse?.locations?.state ?? ""), \(data.beachHouse?.locations?.country ?? "")"
        date.text = data.checkingDate
        loadImage(urlString: data.beachHouse?.image)
    }
    
    private func handleEmptyCell(isEmpty: Bool, message: String = "No data available") {
        // Toggle visibility based on whether the cell is empty or not
        daysView.isHidden = isEmpty
        beachName.isHidden = isEmpty
        locationLbl.isHidden = isEmpty
        date.isHidden = isEmpty
        beachHouseImage.isHidden = isEmpty
        locationImg.isHidden = isEmpty
        calendarImg.isHidden = isEmpty
        emptyLbl.isHidden = !isEmpty
        availabilityDate.isHidden = isEmpty
        
        if isEmpty {
            emptyLbl.text = message
        }
    }

    
    private func loadImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            beachHouseImage.image = UIImage(named: "placeholderImage")
            return
        }
        
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
            ]
        ) { result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
}
