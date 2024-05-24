//
//  NotificationTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 16/05/2024.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with data: NotificationProperties) {
        titleLabel.text = data.title
        subTitleLabel.text = data.subTitle
    }

   
}
