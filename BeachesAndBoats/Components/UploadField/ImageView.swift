//
//  ImageView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 08/10/2024.
//

import UIKit
import SDWebImage  

@IBDesignable public class ImageView: BaseXib {
    let nibName = "ImageView"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var CoverIndicator: PrimaryButton!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    @IBInspectable var isFirstImage: Bool = false {
        didSet { setup() }
    }
    
    public var coverTitle: String = "Cover" {
        didSet {
            CoverIndicator.setTitle(coverTitle, for: .normal)
        }
    }
    
    public var model: ImageViewModel = ImageViewModel() {
        didSet {
            setup()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func getNibName() -> String? {
        return nibName
    }
    
    func setup() {
        deleteBtn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        
        if isFirstImage {
            setupFirstImageState()
        } else {
            normalSetup()
        }
        
        // Handle image loading/display
        if let imgData = model.image {
            // Local image: Assign directly
            image.image = imgData
        } else if let url = model.url {
            // Remote URL: Load with SDWebImage
            let placeholder = UIImage(named: "placeholder")  // Ensure this asset exists
            image.sd_setImage(with: url, placeholderImage: placeholder) { [weak self] loadedImage, error, _, _ in
                // Optional: Update model on success for consistency
                if let strongSelf = self, error == nil, let loadedImage = loadedImage {
                    strongSelf.model.image = loadedImage
                }
            }
        } else {
            // No image or URL: Clear it
            image.image = nil
        }
    }
    
    func normalSetup() {
        CoverIndicator.isHidden = true
    }
    
    func setupFirstImageState() {
        CoverIndicator.isHidden = false
        CoverIndicator.isUserInteractionEnabled = false
    }
    
    @objc func deleteTapped() {
        model.deleteTapped()
    }
}

//import UIKit
//import SDWebImage
//
//@IBDesignable public class ImageView: BaseXib {
//    let nibName = "ImageView"
//    
//    @IBOutlet weak var image: UIImageView!
//    @IBOutlet weak var CoverIndicator: PrimaryButton!
//    @IBOutlet weak var deleteBtn: UIButton!
//    
//    @IBInspectable public var identifier: String = "" { didSet {
//        self.accessibilityIdentifier = identifier
//    } }
//    
//    @IBInspectable var isFirstImage: Bool = false {
//        didSet { setup() }
//    }
//    
//    public var coverTitle: String = "Cover"{
//        didSet {
//            CoverIndicator.setTitle(coverTitle, for: .normal)
//        }
//    }
//    
//    public var model: ImageViewModel = ImageViewModel() {
//        didSet {
//            setup()
//        }
//    }
//
//    public override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    public required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//    
//    override func getNibName() -> String? {
//        return nibName
//    }
//    
//    func setup(){
//        if let imgData = model.image {
//            image.image = imgData
//        } else {
//            image.image = nil // Handle invalid image URLs or missing image data
//        }
//        deleteBtn.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
//        
//        
//        if isFirstImage{
//            setupFirstImageState()
//        }else{
//            normalSetup()
//        }
//    }
//    
//    func normalSetup(){
//        CoverIndicator.isHidden = true
//    }
//    
//    func setupFirstImageState(){
//        CoverIndicator.isHidden = false
//        CoverIndicator.isUserInteractionEnabled = false
//    }
//    
//    @objc func deleteTapped() {
//        model.deleteTapped()
//    }
//
//}

public struct ImageViewModel {
    public var title: String = ""
    public var image: UIImage? = nil
    public var url: URL? = nil
    public var deleteTapped: () -> Void = {}
}
