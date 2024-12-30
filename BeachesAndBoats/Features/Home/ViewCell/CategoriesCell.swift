//
//  CategoriesCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/12/2024.
//

import UIKit
import Kingfisher

class CategoriesCell: BaseXib, Sizeable {

    let nibName = "CategoriesCell"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
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
        if isSubcategory{
            imageHeight.constant = 20
            image.contentMode = .scaleAspectFit
        }
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
        
        setState()
    }
    
    public func getHeight() -> CGFloat {
        return title.bounds.height + 20
    }
    
    @objc func onTapped(_ sender: UITapGestureRecognizer) {
        model.tapped()
        model.state = true
    }
    
    func setState() {
        if model.state {
            image.layer.borderColor = UIColor.systemOrange.cgColor
            image.layer.borderWidth = 2
        } else {
            image.layer.borderColor = UIColor.clear.cgColor
            image.layer.borderWidth = 0
        }
    }
}


struct CategoriesCellModel{
    public var title: String = ""
    public var image: String = ""
    public var state: Bool = false
    public var tapped: () -> Void = {}
//    public var isBeach: Bool = true
}
