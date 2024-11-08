//
//  HouseTypeViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/10/2024.
//

import UIKit

class HouseTypeViewCell: UICollectionViewCell {

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var navigateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        container.backgroundColor = .white
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.background.cgColor
        container.layer.cornerRadius = 8
    }
    
    func updateContent(data: BeachCategory?){
        icon.image = UIImage.property
        titleLabel.text = data?.name
        subtitleLabel.text = data?.description
    }

}

//struct houseTypeModel{
//    var title: String
//    var subtitle: String
//    var icon: String
//}
