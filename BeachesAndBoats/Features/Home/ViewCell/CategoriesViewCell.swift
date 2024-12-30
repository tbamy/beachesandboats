//
//  CategoriesViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 19/09/2024.
//

import UIKit
import Kingfisher

class CategoriesViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateCell(with data: PropertyCategory){
        title.text = data.name
        print(data.image)
        if let url = URL(string: data.image ?? "") {
            image.kf.setImage(with: url)
        }
    }
    
    func updateCell(with data: SubCategory){
        title.text = data.name
        print(data.image)
        if let url = URL(string: data.image ?? "") {
            image.kf.setImage(with: url)
        }
    }

}
