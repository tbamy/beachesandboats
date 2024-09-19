//
//  CategoriesViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 19/09/2024.
//

import UIKit

class CategoriesViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(with data: CategoriesModel){
        title.text = data.title
//        image.image = UIImage(data: "")
    }

}
