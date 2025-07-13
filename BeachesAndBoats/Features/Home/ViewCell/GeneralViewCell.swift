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
    
    
    @IBOutlet weak var ribbonTagView: RibbonTagView!
    @IBOutlet weak var ribbonTagLabel: UILabel!
    
    var onSaveFavouriteTapped: (() -> Void)?
    
    @IBInspectable var isBeachHouseMode: Bool = false {
        didSet { setup() }
    }
    
    @IBInspectable var isBoatMode: Bool = false {
        didSet { setup() }
    }
    
    var isSaved: Bool = false {
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

        saveBtn.isUserInteractionEnabled = true
        saveBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveBtnTapped)))
        
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

        if isSaved{
            saveBtn.image = UIImage(named: "saveIconFilled")
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
        ribbonTagView.isHidden = true

    }
    
    func setupBoatMode(){
        infoOneIcon.image = Assets.people.image
        infoTwoIcon.image = Assets.location.image
        priceStack.isHidden = true
        ribbonTagView.isHidden = false
        ribbonTagLabel.text = model.ribbonTagLabel
        ribbonTagLabel.textColor = .white
        
        if model.ribbonTagLabel == "Cruising" || model.ribbonTagLabel == "Travel destinations"{
            ribbonTagView.applyGradient(color1: UIColor.black.withAlphaComponent(0.3), color2: UIColor.black)
        }
    }
    
    @objc func saveBtnTapped(){
        onSaveFavouriteTapped?()
    }

}

struct GeneralViewCellModel{
    public var ribbonTagLabel: String = ""
    public var titleLabel: String = ""
    public var priceLabel: String = ""
    public var ratingLabel: String = ""
    public var infoOneLabel: String = ""
    public var infoTwoLabel: String = ""
    public var bannerImg: String = ""
    public var tapped: () -> Void = {}
}
