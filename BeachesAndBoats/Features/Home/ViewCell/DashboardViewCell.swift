//
//  HostingDashboardCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 22/11/2024.
//

import UIKit

class DashboardViewCell: BaseXib {
    @IBOutlet var cellView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var saveBtn: UIImageView!
    @IBOutlet weak var ratingIcon: UIImageView!
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
    
    @IBInspectable var isBeachMode: Bool = false {
        didSet { setup() }
    }
    
    @IBInspectable var isServiceMode: Bool = false {
        didSet { setup() }
    }
    public var model: DashboardViewCellModel = DashboardViewCellModel(){
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
        
        if isServiceMode{
            setupServiceMode()
            
        }else if isBeachMode{
            setupBeachMode()
            
        }
        
    }
    
    func setupBeachMode(){
        infoOneIcon.image = Assets.location.image
        infoTwoIcon.image = Assets.calendar.image
    }
    
    func setupServiceMode(){
        infoOneIcon.image = Assets.people.image
        infoTwoIcon.image = Assets.location.image
        priceStack.isHidden = true
    }

}

struct DashboardViewCellModel{
    public var title: String = ""
    public var titleLabel: String = ""
    public var priceLabel: String = ""
    public var ratingLabel: String = ""
    public var infoOneLabel: String = ""
    public var infoTwoLabel: String = ""
    public var bannerImg: UIImage = UIImage()
    public var tapped: () -> Void = {}
}
