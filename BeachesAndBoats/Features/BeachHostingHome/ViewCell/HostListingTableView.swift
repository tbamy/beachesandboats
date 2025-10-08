//
//  HostListingTableView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 14/01/2025.
//

import UIKit

class HostListingTableView: UITableViewCell {
    
    @IBOutlet weak var beachHouseImage: UIImageView!
    @IBOutlet weak var beachName: UILabel!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var availabilitDate: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var pricePerNightLbl: UILabel!
    
    var isSingle: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func beachHouseListingCell(with data: BeachHouseListing) {
        beachName.text = data.name ?? "No name available"
        isSingle = data.bookingType == "SINGLE"
        
//        if data.bookingType
        
        if let location = data.locations {
            locationLbl.text = "\(location.name ?? ""), \(location.jettyLocation ?? "")"
        }
        
        if let availability = data.availabilities {
            availabilitDate.text = "\(availability.availableFrom?.convertToShorterDateFormat() ?? "") - \(availability.availableTo?.convertToShorterDateFormat() ?? "")"
        }
        
//        if let listingPrice = data.listingPrice {
        
        pricePerNightLbl.text = isSingle ? "₦\(data.minRoomPricePerNight?.toAmount() ?? "0")" : "₦\(data.listingPrice?.toAmount() ?? "0")"
//        }
        
        if let rating = data.rating {
            ratingLbl.text = "\(rating)"
        }
        
        if let imageUrl = data.image, let url = URL(string: imageUrl) {
//            beachHouseImage.kf.setImage(with: url)
            beachHouseImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }
    }
    
    func boatListingCell(with data: BoatListing) {
        beachName.text = data.name
        
        if let location = data.locations {
            locationLbl.text = "\(location.name ?? ""), \(location.jettyLocation ?? "")"
        }
        
        if let availability = data.availabilities {
            availabilitDate.text = "\(availability.availableFrom?.convertToShorterDateFormat() ?? "") - \(availability.availableTo?.convertToShorterDateFormat() ?? "")"
        }
        
        if let listingPrice = data.destinations?.first {
            pricePerNightLbl.text = "₦\(listingPrice.price?.toAmount() ?? "0")"
        }
        
        if let rating = data.rating {
            ratingLbl.text = "\(rating)"
        }
        
        if let images = data.images, let firstImage = images.first, let imageUrlString = firstImage.url, let url = URL(string: imageUrlString) {
//            beachHouseImage.kf.setImage(with: url)
            beachHouseImage.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
        }

    }
    
    
//    func beachHouseListingCell(with data: BeachHouseListingResponse?) {
//        if let houseListing = data?.data?.beachHouseListings?.first {
//            beachName.text = houseListing.name ?? "No name available"
//            
//            if let location = houseListing.locations {
//                locationLbl.text = "\(location.city ?? ""), \(location.state ?? "") \(location.country ?? "")"
//            }
//            
//            if let availability = houseListing.availabilities {
//                availabilitDate.text = "\(availability.availableFrom ?? "") - \(availability.availableTo ?? "")"
//            }
//            
//            if let listingPrice = houseListing.listingPrice {
//                pricePerNightLbl.text = "\(listingPrice)"
//            }
//            
//            if let rating = houseListing.rating {
//                ratingLbl.text = "\(rating)"
//            }
//            
//            if let imageUrl = houseListing.image, let url = URL(string: imageUrl) {
//                beachHouseImage.kf.setImage(with: url)
//            }
//        }


        
//        beachName.text = data?.beachHouseListings?.first
//        locationLbl.text = "\(data?.locations?.city ?? ""), \(data?.locations?.state ?? "") \(data?.locations?.country ?? "")"
//        availabilitDate.text = "\(data?.availabilities?.availableFrom ?? "") - \(data?.availabilities?.availableTo ?? "")"
//        pricePerNightLbl.text = "\(data?.listingPrice ?? 0)"
//        ratingLbl.text = "\(data?.rating ?? 0)"
//        let url = URL(string: data?.image ?? "")
//        beachHouseImage.kf.setImage(with: url)
    }

