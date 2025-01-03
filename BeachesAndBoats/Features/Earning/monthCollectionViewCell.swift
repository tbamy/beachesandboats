//
//  monthCollectionViewCell.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 31/12/2024.
//

import UIKit

class monthCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var months: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 8
        containerView.layer.masksToBounds = true
    }
    
    func updateCell(isSelected: Bool) {
        if isSelected {
            containerView.backgroundColor = .B_B
            months.textColor = .white
        } else {
            containerView.backgroundColor = .clear
            months.textColor = .background
        }
    }
}
