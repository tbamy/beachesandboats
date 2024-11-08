//
//  ViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import UIKit

class GeneralViewCell: BaseXib {
    @IBOutlet var cellView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var saveBtn: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceStack: UIStackView!
    @IBOutlet weak var infoOneIcon: UIImageView!
    @IBOutlet weak var infoOneLabel: UILabel!
    @IBOutlet weak var infoOneStack: UIStackView!
    @IBOutlet weak var infoTwoIcon: UIImageView!
    @IBOutlet weak var infoTwoLabel: UILabel!
    @IBOutlet weak var infoTwoStack: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable var isBeachHouseMode: Bool = false {
        didSet { setup() }
    }
    
    @IBInspectable var isBoatMode: Bool = false {
        didSet { setup() }
    }
    public var model: GeneralViewCellModel = GeneralViewCellModel(){
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
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
//        title
        
        if isBoatMode{
            setupBoatMode()
            
        }else if isBeachHouseMode{
            setupBeachHouseMode()
            
        }
        
    }
    
    func setupBeachHouseMode(){
        infoOneIcon.image = Assets.location.image
        infoTwoIcon.image = Assets.calendar.image
    }
    
    func setupBoatMode(){
        infoOneIcon.image = Assets.people.image
        infoTwoIcon.image = Assets.location.image
        priceStack.isHidden = true
    }

}

struct GeneralViewCellModel{
    public var title: String = ""
    public var titleLabel: String = ""
    public var priceLabel: String = ""
    public var ratingLabel: String = ""
    public var infoOneLabel: String = ""
    public var infoTwoLabel: String = ""
    public var bannerImg: UIImage = UIImage()
    public var tapped: () -> Void = {}
}
