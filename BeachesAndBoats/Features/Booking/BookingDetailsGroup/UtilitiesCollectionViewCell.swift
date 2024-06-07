//
//  UtilitiesCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 22/05/2024.
//

import UIKit

class UtilitiesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(with data: UtilitiesProperties) {
        image.image = UIImage(named: data.image ?? "empty")
        title.text = data.title
    }

}


struct UtilitiesModel {
    func populateData() -> [UtilitiesProperties] {
        [
            UtilitiesProperties(image: "wifi", title: "Wifi"),
            UtilitiesProperties(image: "washer", title: "Washer"),
            UtilitiesProperties(image: "parking", title: "Parking"),
            UtilitiesProperties(image: "pets", title: "Pets allowed"),
            UtilitiesProperties(image: "kitchen", title: "Kitchen"),
            UtilitiesProperties(image: "beachfont", title: "Beach Front"),
            UtilitiesProperties(image: "wifi", title: "Wifi"),

        ]
    }
}

struct UtilitiesProperties {
    let image: String?
    let title: String?
}
