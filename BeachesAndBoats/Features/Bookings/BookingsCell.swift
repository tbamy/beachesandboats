//
//  BookingsCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 14/10/2024.
//

import UIKit

class BookingsCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(_ data: BookingsCellModel?){
        if let data = data{
//            image.image = UII
            titleLabel.text = data.title
            locationLabel.text = data.location
            dateLabel.text = data.date
        }
    }
    

}

struct BookingsCellModel{
    var title: String?
    var location: String?
    var date: String?
    var image: UIImage?
}
