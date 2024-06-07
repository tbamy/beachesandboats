//
//  SaveTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 05/06/2024.
//

import UIKit

class SaveTableViewCell: UITableViewCell {
    
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var numberOfSaves: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setup(with data: SaveModel) {
        locationImage.image = UIImage(named: data.locationImage)
        locationNameLabel.text = data.locationName
        numberOfSaves.text = data.itemCount.description
    }

   
    
}
