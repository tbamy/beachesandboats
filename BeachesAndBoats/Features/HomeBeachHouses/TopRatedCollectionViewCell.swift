//
//  TopRatedCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 29/05/2024.
//

import UIKit

protocol TopRatedCollectionViewCellDelegate: AnyObject {
    func didTapImage(in cell: TopRatedCollectionViewCell)
}

class TopRatedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var beachName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var likeImg: UIImageView!
    
    weak var delegate: TopRatedCollectionViewCellDelegate?
    
    var isLiked = false {
        didSet {
            likeImg.image = isLiked ? UIImage(named: "like") : UIImage(named: "unlike")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomView.layer.cornerRadius = 10
        gestureReconizers()
    }
    
    func setup(with data: TopRatedProperties) {
        image.image = UIImage(named: data.img ?? "empty")
        beachName.text = data.name
        location.text = data.location
        date.text = data.date
        rating.text = data.rating
        likeImg.image = UIImage(named: data.likeImg)
    }
    
    func gestureReconizers() {
        let saved = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        likeImg.isUserInteractionEnabled = true
        likeImg.addGestureRecognizer(saved)
    }
    
    @objc func likeTapped() {
        delegate?.didTapImage(in: self)
    }

}

struct TopRatedModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "unlike"),
            TopRatedProperties(name: "Abule-Egba Luxury Villa", location: "Egba, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "unlike"),
            TopRatedProperties(name: "Oshodi Luxury Villa", location: "Oshodi, Ibadan Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "unlike"),
            TopRatedProperties(name: "UnderBridge Luxury Hostel", location: "Abe brigde, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "beaches", likeImg: "unlike"),
        ]
    }
}

struct BoatsTopRatedModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Orile Luxury Villa", location: "Orile, Ibadan Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Ikorodu Luxury Hostel", location: "Ikorodu, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
        ]
    }
}

struct BoatBookNowModel {
    func populateData() -> [TopRatedProperties] {
        [
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
            TopRatedProperties(name: "Marina Luxury Villa", location: "Ikoyi, Lagos Nigeria", date: "Mar 19-24", price: "240,000/ night", rating: "5.0", img: "ship", likeImg: "unlike"),
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
    let likeImg: String
}


