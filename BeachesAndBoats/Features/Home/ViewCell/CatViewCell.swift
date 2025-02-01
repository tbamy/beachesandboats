//
//  CatViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 02/01/2025.
//

import UIKit
import Kingfisher

class CatViewCell: BaseXib {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    let nibName = "CatViewCell"

    
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
    
    public var model: CatViewCellModel = CatViewCellModel(){
        didSet {
            setup()
        }
        
    }
    
    func setup(){
        image.contentMode = .scaleAspectFit
        
        title.text = model.title
        title.font.withSize(12)
        
        if let url = URL(string: model.image) {
            image.kf.setImage(
                with: url,
                placeholder: UIImage(named: "calendar"),
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                        self.image.image = UIImage(named: "calendar")
                    }
                }
            )
        } else {
            image.image = UIImage(named: "calendar")
        }
        
    }
    
}


struct CatViewCellModel{
    public var title: String = ""
    public var image: String = ""
}

    
        
