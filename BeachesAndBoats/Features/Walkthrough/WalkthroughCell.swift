//
//  WalkthroughCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class WalkthroughCell: UICollectionViewCell {

    @IBOutlet weak var slideImg: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setUp(data: WalkthroughModel){
        slideImg.image = UIImage(named: data.image)
        titleLabel.text = data.title
        contentLabel.text = data.content
    }

}
