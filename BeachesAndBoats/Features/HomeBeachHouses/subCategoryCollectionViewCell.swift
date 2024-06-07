//
//  subCategoryCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 27/05/2024.
//

import UIKit

class subCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setup(with data: SubCategoryPropeties) {
        image.image = UIImage(named: data.img ?? "empty")
        title.text = data.title
    }
}

struct SubCateogryModel {
    func populateData() -> [SubCategoryPropeties] {
        [
            SubCategoryPropeties(img: "luxury", title: "Luxury"),
            SubCategoryPropeties(img: "hotel", title: "Hotels"),
            SubCategoryPropeties(img: "mansion", title: "Mansions"),
            SubCategoryPropeties(img: "rooms", title: "Rooms"),
            SubCategoryPropeties(img: "pool", title: "Amazing pools"),
            SubCategoryPropeties(img: "pool", title: "Design"),
            SubCategoryPropeties(img: "pool", title: "Adapted")
        ]
    }
}

struct SubCategoryPropeties {
    let img: String?
    let title: String?
}
