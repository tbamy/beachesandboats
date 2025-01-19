//
//  ViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import UIKit
import Kingfisher

class GeneralViewCell: BaseXib {
    
    let nibName = "GeneralViewCell"
    
    @IBOutlet var cellView: UIView!
//    @IBOutlet weak var title: UILabel!
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
        bannerImg.layer.cornerRadius = 15
        cellView.layer.cornerRadius = 15
//        title.isHidden = true
        titleLabel.text = model.titleLabel
        infoOneLabel.text = model.infoOneLabel
        infoTwoLabel.text = model.infoTwoLabel
        priceLabel.text = model.priceLabel
        ratingLabel.text = model.ratingLabel

        
        if let url = URL(string: model.bannerImg.replacingOccurrences(of: "http://", with: "https://")) {
            bannerImg.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummy"),
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                        self.bannerImg.image = UIImage(named: "dummy")
                    }
                }
            )
        } else {
            bannerImg.image = UIImage(named: "dummy")
        }

        
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
//    public var title: String = ""
    public var titleLabel: String = ""
    public var priceLabel: String = ""
    public var ratingLabel: String = ""
    public var infoOneLabel: String = ""
    public var infoTwoLabel: String = ""
    public var bannerImg: String = ""
    public var tapped: () -> Void = {}
}
