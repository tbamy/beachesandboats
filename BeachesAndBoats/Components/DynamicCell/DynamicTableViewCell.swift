//
//  DynamicTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit

public class DynamicTableViewCell: UITableViewCell {

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func applyView(view: UIView){
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        contentView.addSubview(view)
        
    }

}

