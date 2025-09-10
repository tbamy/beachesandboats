//
//  CategoriesCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/12/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

class CategoriesCell: BaseXib, Sizeable {

    let nibName = "CategoriesCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public var isSubcategory: Bool = false{
        didSet { setup() }
    }

    public override init(frame: CGRect) {
        super .init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super .init(coder: coder)
        setup()
    }
    
    public override func awakeFromNib() {
        updateHeight()
    }
    
    public var model: CategoriesCellModel = CategoriesCellModel(){
        didSet {
            setup()
        }
        
    }
    
    @IBInspectable var state: Bool = false {
        didSet { model.state = state }
    }
    
    func setup(){
        blurView.isHidden = false
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        if isSubcategory{
            blurView.isHidden = true
            imageHeight.constant = 20
            image.contentMode = .scaleAspectFit
        }
        title.text = model.title
        title.font.withSize(12)
        
//        let imageUrl = model.image
//        imageUrl.loadImage(into: image, placeholder: model.dummyImage)
        print("Image Url is: \(model.image)")
        
        if let url = URL(string: model.image.replacingOccurrences(of: "http://", with: "https://")) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: model.dummyImage))

        } else {
            image.image = UIImage(named: "luxuryIcon")
        }
        
            setState()
        
    }
    
    public func getHeight() -> CGFloat {
        return title.bounds.height + 20
    }
    
    @objc func onTapped(_ sender: UITapGestureRecognizer) {
//        model.tapped()
//        model.state = true
//        setState()
    }
    
    func setState() {
        if model.state {
            image.layer.borderColor = UIColor.systemOrange.cgColor
            image.layer.borderWidth = 2
            image.layer.cornerRadius = 8
            blurView.isHidden = true
        } else {
            image.layer.borderColor = UIColor.clear.cgColor
            image.layer.borderWidth = 0
            blurView.isHidden = false
        }
    }
}


struct CategoriesCellModel{
    public var title: String = ""
    public var image: String = ""
    public var dummyImage: String = ""
//    public var image: UIImage = UIImage()
    public var state: Bool = false
    public var tapped: () -> Void = {}
//    public var isBeach: Bool = true
}
