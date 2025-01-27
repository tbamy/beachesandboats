//
//  MessageViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit

class MessageViewCell: UITableViewCell {
    
    @IBOutlet weak var contactImg: UIImageView!
    @IBOutlet weak var contactName: BoldLabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var lastMsgLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
