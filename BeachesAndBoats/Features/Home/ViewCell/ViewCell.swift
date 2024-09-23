//
//  ViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import UIKit

class ViewCell: BaseXib {
    @IBOutlet var cellView: UIView!
    
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var saveBtn: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var infoOneIcon: UIImageView!
    @IBOutlet weak var infoOneLabel: UILabel!
    @IBOutlet weak var infoOneStack: UIStackView!
    @IBOutlet weak var infoTwoIcon: UIImageView!
    @IBOutlet weak var infoTwoLabel: UILabel!
    @IBOutlet weak var infoTwoStack: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
//    public var model: 
    
    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    func setup(){
        bannerImg.layer.cornerRadius = 8
        cellView.layer.cornerRadius = 8
    }


}
