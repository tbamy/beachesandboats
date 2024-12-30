//
//  ImageCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 28/12/2024.
//

import UIKit

class ImageCell: BaseXib {


    let nibName = "ImageCell"
    
    @IBOutlet weak var image: UIImageView!

    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public var img: String = ""{
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
    
    
    func setup(){
        if let url = URL(string: img.replacingOccurrences(of: "http://", with: "https://")) {
            image.kf.setImage(with: url)
        }
    }
}
