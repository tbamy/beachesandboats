//
//  HostingCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

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
        daysView.layer.cornerRadius = 20
        daysView.layer.borderWidth = 1
        daysView.layer.borderColor = UIColor.systemOrange.cgColor
    }
    
    // MARK: - Helper method to determine if booking is room-only
    private func isRoomOnlyBooking(_ data: BeachHouseReservationsCurrentReservation?) -> Bool {
        return data?.propertyBookingType == "ROOM"
    }
    
    // MARK: - Helper methods to get appropriate details based on booking type
    private func getPropertyName(from data: BeachHouseReservationsCurrentReservation?) -> String? {
        let isRoomOnly = isRoomOnlyBooking(data)
        return isRoomOnly ? data?.beachHouseRoom?.name : data?.beachHouse?.name
    }
    
    private func getPropertyImage(from data: BeachHouseReservationsCurrentReservation?) -> String? {
        let isRoomOnly = isRoomOnlyBooking(data)
        if isRoomOnly {
            // For room bookings, try to get room image first, fallback to house image
            return data?.beachHouseRoom?.images?.first?.url ?? data?.beachHouse?.image
        } else {
            return data?.beachHouse?.image
        }
    }
    
    private func getPropertyPrice(from data: BeachHouseReservationsCurrentReservation?) -> String {
        let isRoomOnly = isRoomOnlyBooking(data)
        
        if isRoomOnly {
            if let roomPrice = data?.beachHouseRoom?.pricePerNight {
                return "₦\(roomPrice.toAmount() ?? "0.00") / night"
            }
        } else {
            if let housePrice = data?.beachHouse?.listingPrice {
                return "₦\(housePrice.toAmount() ?? "0.00") / night"
            }
        }
        
        // Fallback
        return "₦\(data?.beachHouseRoom?.pricePerNight?.toAmount() ?? "0.00") / night"
    }
    
    //For beach reservation
    func currentHostingCell(with data: BeachHouseReservationsCurrentReservation?) {
        daysView.isHidden = true
        
        beachName.text = getPropertyName(from: data)
        locationLbl.text = "\(data?.beachHouse?.locations?.name ?? ""), \(data?.beachHouse?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.checkingDate?.convertToShorterDateFormat() ?? "") - \(data?.checkoutDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = getPropertyPrice(from: data)
        
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: getPropertyImage(from: data))
    }
    
    //For boat reservation
    func boatCurrentHostingCell(with data: BoatReservationsCurrentReservation?) {
        daysView.isHidden = true
        beachName.text = data?.boat?.name
        locationLbl.text = "\(data?.boat?.locations?.name ?? ""), \(data?.boat?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.bookingDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.boat?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.total ?? 0.00)"
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.boat?.images?.first?.url)
    }
    
    func upcomingHostingCell(with data: BeachHouseReservationsCurrentReservation?) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyy"

        if let futureDate = formatter.date(from: data?.checkingDate ?? "") {
            if let days = daysBetween(from: today, to: futureDate) {
                if days < 1 {
                    daysLbl.text = "Less than 1 day"
                } else if days == 1 {
                    daysLbl.text = "Next 1 day"
                } else {
                    daysLbl.text = "Next \(days) days"
                }
            }
        }
        
        beachName.text = getPropertyName(from: data)
        locationLbl.text = "\(data?.beachHouse?.locations?.name ?? ""), \(data?.beachHouse?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.checkingDate?.convertToShorterDateFormat() ?? "") - \(data?.checkoutDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = getPropertyPrice(from: data)
        
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: getPropertyImage(from: data))
    }
    
    func boatUpcomingHostingCell(with data: BoatReservationsCurrentReservation?) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyy"

        if let futureDate = formatter.date(from: data?.bookingDate ?? "") {
            if let days = daysBetween(from: today, to: futureDate) {
                if days < 1 {
                    daysLbl.text = "Less than 1 day"
                } else if days == 1 {
                    daysLbl.text = "Next 1 day"
                } else {
                    daysLbl.text = "Next \(days) days"
                }
            }
        }
        
        beachName.text = data?.boat?.name
        locationLbl.text = "\(data?.boat?.locations?.name ?? ""), \(data?.boat?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.bookingDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.boat?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.total ?? 0.00)"
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.boat?.images?.first?.url )
    }
    
    func cancelledBookingCell(with data: BeachHouseReservationsCurrentReservation?) {
        daysView.isHidden = true
        
        beachName.text = getPropertyName(from: data)
        locationLbl.text = "\(data?.beachHouse?.locations?.name ?? ""), \(data?.beachHouse?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.checkingDate?.convertToShorterDateFormat() ?? "") - \(data?.checkoutDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = getPropertyPrice(from: data)
        
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: getPropertyImage(from: data))
    }
    
    func boatCancelledBookingCell(with data: BoatReservationsCurrentReservation?) {
        daysView.isHidden = true
        beachName.text = data?.boat?.name
        locationLbl.text = "\(data?.boat?.locations?.name ?? ""), \(data?.boat?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.bookingDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.boat?.rating ?? 0)"
        amountPerNight.text = "₦\(data?.total ?? 0.00)"
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: data?.boat?.images?.first?.url )
    }
    
    func checkingOutHostingCell(with data: BeachHouseReservationsCurrentReservation?) {
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyy"

        if let futureDate = formatter.date(from: data?.checkoutDate ?? "") {
            if let days = daysBetween(from: today, to: futureDate) {
                if days < 1 {
                    daysLbl.text = "Less than 1 day"
                } else if days == 1 {
                    daysLbl.text = "Next 1 day"
                } else {
                    daysLbl.text = "Next \(days) days"
                }
            }
        }
        
        beachName.text = getPropertyName(from: data)
        locationLbl.text = " \(data?.beachHouse?.locations?.name ?? ""), \(data?.beachHouse?.locations?.jettyLocation ?? "")"
        availabilityDate.text = "\(data?.checkingDate?.convertToShorterDateFormat() ?? "") - \(data?.checkoutDate?.convertToShorterDateFormat() ?? "")"
        calendarImg.image = UIImage(named: "ratingIcon")
        date.text = "\(data?.beachHouse?.rating ?? 0)"
        amountPerNight.text = getPropertyPrice(from: data)
        
        reservationCalendar.image = UIImage(named: "calendar")
        loadImage(urlString: getPropertyImage(from: data))
    }
    
    func setupHostingCell(with data: BeachHouseBookingDetails?) {
        reservationCalendar.isHidden = true
        amountPerNight.isHidden = true
        
        guard let data = data, let beachHouse = data.beachHouse else {
            handleEmptyCell(isEmpty: true)
            return
        }
        handleEmptyCell(isEmpty: false)
        daysLbl.text = data.checkingDate
        beachName.text = data.beachHouse?.name
        locationLbl.text = " \(data.beachHouse?.locations?.name ?? ""), \(data.beachHouse?.locations?.jettyLocation ?? "")"
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

    func daysBetween(from startDate: Date, to endDate: Date) -> Int? {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day
    }
    
    private func loadImage(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            beachHouseImage.image = UIImage(named: "dummy")
            return
        }
        
        beachHouseImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
    }
}
