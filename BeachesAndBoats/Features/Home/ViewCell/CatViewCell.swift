//
//  CatViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/01/2025.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class CatViewCell: BaseXib {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    let nibName = "CatViewCell"

    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    @IBInspectable public var hasImage: Bool = true {
        didSet{
            setup()
        }
    }

    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    public var model: CatViewCellModel = CatViewCellModel(){
        didSet {
            setup()
        }
        
    }
    
    func setup(){
        image.contentMode = .scaleAspectFit
        image.tintColor = .beachBlue
        
        title.text = model.title
        title.font.withSize(12)
        
        if !hasImage{
            image.isHidden = true
        }
        
        if let url = URL(string: model.image.replacingOccurrences(of: "http://", with: "https://")) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "dummy"))
//            image.kf.setImage(with: url)
        } else {
            image.image = UIImage(named: "calendar")
        }
        
    }
    
}


struct CatViewCellModel{
    public var title: String = ""
    public var image: String = ""
}

    
        
