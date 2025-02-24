//
//  RecommendationsViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/02/2025.
//

import UIKit
import Kingfisher

class RecommendationsViewCell: BaseXib {

    let nibName = "RecommendationsViewCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dishOrSexLabel: UILabel!
    @IBOutlet weak var viewBtn: PrimaryButton!

    var onViewBtnTapped: (() -> Void)?
    
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
    
    public var model: RecommendationsViewCellModel = RecommendationsViewCellModel(){
        didSet {
            setup()
        }
        
    }
    
    func setup(){
        
        nameLabel.text = model.name
        priceLabel.text = "From ₦\(model.price) / day"
        ratingLabel.text = "\(model.rating)"
//        if model.dishOrSex == ""{
        dishOrSexLabel.isHidden = model.dishOrSex.isEmpty
//        }
        dishOrSexLabel.text = model.dishOrSex
        
        image.layer.cornerRadius = 10
        if let url = URL(string: model.image.replacingOccurrences(of: "http://", with: "https://")) {
            image.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummy"),
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                        self.image.image = UIImage(named: "dummy")
                    }
                }
            )
        } else {
            image.image = UIImage(named: "dummy")
        }
    }

    @IBAction func viewBtnTapped(_ sender: Any) {
        onViewBtnTapped?()
    }
}

struct RecommendationsViewCellModel{
    public var name: String = ""
    public var image: String = ""
    public var price: Float = 0
    public var rating: Int = 0
    public var dishOrSex: String = ""
}
