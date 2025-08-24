//
//  ViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import UIKit
import SDWebImage
import SDWebImageSVGCoder

// Updated GeneralViewCell with proper cell reuse handling
//class GeneralViewCell: BaseXib {
//    
//    let nibName = "GeneralViewCell"
//    
//    @IBOutlet var cellView: UIView!
//    @IBOutlet weak var bannerImg: UIImageView!
//    @IBOutlet weak var saveBtn: UIImageView!
//    @IBOutlet weak var ratingIcon: UIImageView!
//    @IBOutlet weak var ratingLabel: UILabel!
//    @IBOutlet weak var priceLabel: UILabel!
//    @IBOutlet weak var priceNightLabel: UILabel!
//    @IBOutlet weak var infoOneIcon: UIImageView!
//    @IBOutlet weak var infoOneLabel: UILabel!
//    @IBOutlet weak var infoOneStack: UIStackView!
//    @IBOutlet weak var infoTwoIcon: UIImageView!
//    @IBOutlet weak var infoTwoLabel: UILabel!
//    @IBOutlet weak var infoTwoStack: UIStackView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var ribbonTagView: RibbonTagView!
//    @IBOutlet weak var ribbonTagLabel: UILabel!
//    
//    var onSaveFavouriteTapped: (() -> Void)?
//    
//    // Add this property to track current image URL
//    private var currentImageURL: String = ""
//    
//    @IBInspectable var isBeachHouseMode: Bool = false {
//        didSet { setup() }
//    }
//    
//    @IBInspectable var isBoatMode: Bool = false {
//        didSet { setup() }
//    }
//    
//    var isSaved: Bool = false {
//        didSet { setup() }
//    }
//    
//    public var model: GeneralViewCellModel = GeneralViewCellModel(){
//        didSet {
//            setup()
//        }
//    }
//    
//    @IBInspectable public var identifier: String = "" { didSet {
//        self.accessibilityIdentifier = identifier
//    } }
//    
//    public override init(frame: CGRect) {
//        super .init(frame: frame)
//        setup()
//    }
//    
//    public required init?(coder: NSCoder) {
//        super .init(coder: coder)
//        setup()
//    }
//    
//    // Add this method to prepare for reuse
////    public override func prepareForReuse() {
////        super.prepareForReuse()
////        
////        // Cancel any ongoing image loading
////        bannerImg.sd_cancelCurrentImageLoad()
////        
////        // Reset image to placeholder
////        bannerImg.image = UIImage(named: "dummy")
////        
////        // Clear current URL tracking
////        currentImageURL = ""
////        
////        // Reset other UI elements
////        titleLabel.text = ""
////        infoOneLabel.text = ""
////        infoTwoLabel.text = ""
////        priceLabel.text = ""
////        ratingLabel.text = ""
////        ribbonTagLabel.text = ""
////        
////        // Reset modes
////        isBeachHouseMode = false
////        isBoatMode = false
////        isSaved = false
////        
////        // Remove gesture recognizers to prevent multiple additions
////        saveBtn.gestureRecognizers?.removeAll()
////    }
//    
//    func setup(){
//        bannerImg.layer.cornerRadius = 15
//        cellView.layer.cornerRadius = 15
//        titleLabel.text = model.titleLabel
//        infoOneLabel.text = model.infoOneLabel
//        infoTwoLabel.text = model.infoTwoLabel
//        priceLabel.text = model.priceLabel
//        ratingLabel.text = model.ratingLabel
//
//        saveBtn.isUserInteractionEnabled = true
//        saveBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveBtnTapped)))
//        
//        // Load image with proper cell reuse handling
//        loadImage()
//
//        if isSaved{
//            saveBtn.image = UIImage(named: "saveIconFilled")
//        } else {
//            saveBtn.image = UIImage(named: "saveIcon") // assuming you have an unfilled version
//        }
//        
//        if isBoatMode{
//            setupBoatMode()
//        }else if isBeachHouseMode{
//            setupBeachHouseMode()
//        }
//    }
//    
//    private func loadImage() {
//        // Cancel any previous image loading
//        bannerImg.sd_cancelCurrentImageLoad()
//        
//        // Set placeholder immediately
//        bannerImg.image = UIImage(named: "dummy")
//        
//        // Update current URL tracking
//        currentImageURL = model.bannerImg
//        
//        guard !model.bannerImg.isEmpty else {
//            return
//        }
//        
//        // Store the URL we're about to load
//        let urlToLoad = model.bannerImg
//        
//        if let url = URL(string: urlToLoad.replacingOccurrences(of: "http://", with: "https://")) {
//            print("Loading image: \(url)")
//            
//            bannerImg.sd_setImage(
//                with: url,
//                placeholderImage: UIImage(named: "dummy"),
//                options: [.allowInvalidSSLCertificates, .refreshCached, .retryFailed],
//                completed: { [weak self] (image, error, cacheType, imageURL) in
//                    guard let self = self else { return }
//                    
//                    // CRITICAL: Only update the image if this is still the current URL
//                    // This prevents images from previous cells from showing up
//                    if self.currentImageURL == urlToLoad {
//                        DispatchQueue.main.async {
//                            if let error = error {
//                                print("❌ Image loading failed: \(error)")
//                                self.bannerImg.image = UIImage(named: "dummy")
//                            } else if let image = image {
//                                print("✅ Image loaded successfully: \(imageURL?.absoluteString ?? "")")
//                                self.bannerImg.image = image
//                            }
//                        }
//                    } else {
//                        print("🚫 Ignoring image load for outdated URL: \(imageURL?.absoluteString ?? "")")
//                    }
//                }
//            )
//        } else {
//            print("❌ Invalid URL format: \(model.bannerImg)")
//            bannerImg.image = UIImage(named: "dummy")
//        }
//    }
//    
//    func setupBeachHouseMode(){
//        infoOneIcon.image = Assets.location.image
//        infoTwoIcon.image = Assets.calendar.image
//        ribbonTagView.isHidden = true
//        priceNightLabel.isHidden = false
//        priceLabel.isHidden = false
//    }
//    
//    func setupBoatMode(){
//        infoOneIcon.image = Assets.people.image
//        infoTwoIcon.image = Assets.location.image
//        priceNightLabel.isHidden = true
//        priceLabel.isHidden = true
//        ribbonTagView.isHidden = false
//        ribbonTagLabel.text = model.ribbonTagLabel
//        ribbonTagLabel.textColor = .white
//        
//        if model.ribbonTagLabel == "Cruising" || model.ribbonTagLabel == "Travel destinations"{
//            ribbonTagView.applyGradient(color1: UIColor.black.withAlphaComponent(0.3), color2: UIColor.black)
//        }
//    }
//    
//    @objc func saveBtnTapped(){
//        onSaveFavouriteTapped?()
//    }
//}

class GeneralViewCell: BaseXib {
    
    let nibName = "GeneralViewCell"
    
    @IBOutlet var cellView: UIView!
//    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var saveBtn: UIImageView!
    @IBOutlet weak var ratingIcon: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceNightLabel: UILabel!
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
        titleLabel.text = model.titleLabel
        infoOneLabel.text = model.infoOneLabel
        infoTwoLabel.text = model.infoTwoLabel
        priceLabel.text = model.priceLabel
        ratingLabel.text = model.ratingLabel

        saveBtn.isUserInteractionEnabled = true
        saveBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(saveBtnTapped)))
        
        // IMPORTANT: Clear the image first to handle cell reuse
        bannerImg.image = UIImage(named: "dummy") // Set placeholder immediately
        
        print("Image Url is: \(model.bannerImg)")
        
        if !model.bannerImg.isEmpty {
            if let url = URL(string: model.bannerImg.replacingOccurrences(of: "http://", with: "https://")) {
                print("Image New Url is: \(url)")
                
                // Cancel any previous image loading for this image view
                bannerImg.sd_cancelCurrentImageLoad()
                
                bannerImg.sd_setImage(
                    with: url,
                    placeholderImage: UIImage(named: "dummy"),
                    options: [.allowInvalidSSLCertificates, .refreshCached, .retryFailed],
                    completed: { [weak self] (image, error, cacheType, url) in
                        if let error = error {
                            print("Image loading error: \(error)")
                        } else if let image = image {
                            print("Image loaded successfully from: \(url?.absoluteString ?? "")")
                        }
                    }
                )
            } else {
                print("Invalid URL: \(model.bannerImg)")
                bannerImg.image = UIImage(named: "dummy")
            }
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
        priceNightLabel.isHidden = true
        priceLabel.isHidden = true
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
