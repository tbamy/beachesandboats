//
//  BookingTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 17/05/2024.
//

import UIKit

class BookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var villaImage: UIImageView!
    @IBOutlet weak var villaName: UILabel!
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        
//        let text = "Underlined Text"
//               let attributedString = NSAttributedString(string: text, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
    }
    
    func setup(with data: BookingProperties) {
        villaName.text = data.name
        villaImage.image = UIImage(named: data.image ?? "EMPTY")
        locationLabel.text = data.address
        dateLabel.text = data.date
    }

   
    
}
