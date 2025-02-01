//
//  BookingViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 29/09/2024.
//

import UIKit

class BookingViewCell: BaseXib {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    let nibName = "BookingViewCell"

    
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
    
    public var model: BookingViewCellModel = BookingViewCellModel(){
        didSet {
            setup()
        }
        
    }
    
    func setup(){
        img.contentMode = .scaleAspectFit
        
        titleLabel.text = model.title
        titleLabel.font.withSize(12)
        
        if let url = URL(string: model.image.replacingOccurrences(of: "http://", with: "https://")) {
            img.kf.setImage(
                with: url,
                placeholder: UIImage(named: "dummy"),
                options: nil,
                completionHandler: { result in
                    switch result {
                    case .success(let value):
                        print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                    case .failure(let error):
                        print("Failed to load image: \(error.localizedDescription)")
                        self.img.image = UIImage(named: "dummy")
                    }
                }
            )
        } else {
            img.image = UIImage(named: "dummy")
        }
        
    }
    
}


struct BookingViewCellModel{
    public var title: String = ""
    public var image: String = ""
    public var location: String = ""
    public var date: String = ""
}

    
