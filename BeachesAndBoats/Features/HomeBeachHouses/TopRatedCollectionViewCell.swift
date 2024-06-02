//
//  TopRatedCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by WEMA on 29/05/2024.
//

import UIKit

class TopRatedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var beachName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var likeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = 10
    }
    
    func setup(with data: TopRatedProperties) {
        image.image = UIImage(named: data.img ?? "empty")
        beachName.text = data.name
        location.text = data.location
        date.text = data.date
        rating.text = data.rating
    }

}

struct TopRatedModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches"),
        ]
    }
}

struct BoatsTopRatedModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship"),
        ]
    }
}

struct TopRatedProperties {
    let name:  String?
    let location:  String?
    let date: String?
    let price: String?
    let rating: String?
    let img: String?
}


