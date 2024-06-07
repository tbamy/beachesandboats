//
//  ConfirmBookingTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 07/06/2024.
//

import UIKit

class ConfirmBookingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var luxuryImage: UIImageView!
    @IBOutlet weak var bedroomName: UILabel!
    @IBOutlet weak var numberOfGuests: UILabel!
    @IBOutlet weak var numberOfBeds: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var selectButton: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 10
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.04
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        
        luxuryImage.layer.cornerRadius = 10
        selectButton.layer.cornerRadius = 10
        selectButton.layer.borderWidth = 1
        selectButton.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setup(with data: ConfirmBookingProperties) {
        luxuryImage.image = UIImage(named: data.imageName ?? "empty")
        bedroomName.text = data.name
        numberOfGuests.text = data.numberOfGuests
        numberOfBeds.text = data.numberOfBeds
        date.text = data.date
        price.text = data.price
    }

  
    
}
