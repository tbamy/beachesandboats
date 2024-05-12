//
//  HostTableViewCell.swift
//  Beaches and Boats
//
//  Created by Paul Orimogunje on 12/05/2024.
//

import UIKit

class HostTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewContainer.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
    func setupData(with data: ProfileModel) {
        img.image = UIImage(named: data.img ?? "Empty")
        title.text = data.title
    }
}
