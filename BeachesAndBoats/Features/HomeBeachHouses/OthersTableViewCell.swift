//
//  OthersTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 30/05/2024.
//

import UIKit

class OthersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageName: UIImageView!
    @IBOutlet weak var beachName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    //    @IBOutlet weak var bottomView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageName.layer.cornerRadius = 20
        
    }
    
    func setup(with data: TopRatedProperties) {
        imageName.image = UIImage(named: data.img ?? "empty")
        beachName.text = data.name
        location.text = data.location
        date.text = data.date
        rating.text = data.rating
        price.text = data.price
    }
}

struct OthersModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "like"),
        ]
    }
}

struct BoatsOthersModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "boats", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "boats", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "boats", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "boats", likeImg: "like"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "boats", likeImg: "like"),
        ]
    }
}
