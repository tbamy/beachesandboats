//
//  SelectableCard.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import Foundation
import UIKit

public class SelectableView: BaseXib, Sizeable {
     
     @IBOutlet weak var left: NSLayoutConstraint!
     @IBOutlet weak var bottom: NSLayoutConstraint!
     @IBOutlet weak var top: NSLayoutConstraint!
     @IBOutlet weak var right: NSLayoutConstraint!
     
//     @IBOutlet weak var topPaddingView: UIView!
     @IBOutlet weak var mainStack: UIStackView!
     @IBOutlet weak private var image: UIImageView!
     @IBOutlet weak private var checkButton: CheckboxButton!
     @IBOutlet weak private var subtitle: LightLabel!
     @IBOutlet weak private var title: MediumLabel!
     @IBOutlet weak var topImage: UIImageView!
    
     @IBOutlet weak var imageHeight: NSLayoutConstraint!
     @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    @IBInspectable var isTopImage: Bool = false {
        didSet { setup() }
    }
    
    @IBInspectable var titleOnlyMode: Bool = false {
        didSet { setup() }
    }
     
    @IBInspectable var titleAndSubtitleOnlyMode: Bool = false {
        didSet { setup() }
    }
     
     @IBInspectable var titleAndSubtitleWithImageOnlyMode: Bool = false {
         didSet { setup() }
     }
    
    @IBInspectable var actionMode: Bool = false {
        didSet { setupActionMode() }
    }
    
    @IBInspectable var imageTitleMode: Bool = false {
        didSet { setupImageTitleStyle() }
    }
    
//    @IBInspectable var noCheckBox: Bool = false {
//        didSet { setUpForNoCheckBox() }
//    }
    
    @IBInspectable var state: Bool = false {
        didSet { model.state = state }
    }
    
    @IBInspectable var titleText: String = "" {
        didSet { model.title = titleText }
    }
    
    @IBInspectable var subtitleText: String = "" {
        didSet { model.subtitle = subtitleText }
    }
    
    @IBInspectable var displayImage: UIImage = UIImage() {
        didSet { model.image = displayImage }
    }
    
    public var model: SelectableViewModel = SelectableViewModel() {
        didSet {
            setup()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    public override func awakeFromNib() {
        updateHeight()
    }
    
    func setup() {
        title.text = model.title
        subtitle.text = model.subtitle
        image.image = model.image
        topImage.image = model.image
//        checkButton.isHidden = model.noCheckBox
        
        layer.borderWidth = 2
        layer.cornerRadius = 6.0
        setState()
        updateHeight()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped(_:))))
        if isTopImage {
            setupTopImageStyle()
        } else if titleOnlyMode {
            setupTitleOnlyMode()
        } else if titleAndSubtitleOnlyMode{
            setupTitleAndSubtitleOnlyMode()
        }else if titleAndSubtitleWithImageOnlyMode{
            setupTitleAndSubtitleWithImageOnlyMode()
        } 
//        else if noCheckBox {
//            setUpForNoCheckBox()
//        } 
        else {
            setupSideImageStyle()
        }
        
    }
    
    func setupSideImageStyle() {
        image.isHidden = false
        topImage.isHidden = true
//        topPaddingView.isHidden = true
        mainStack.alignment = .center
        mainStack.spacing = 15
        top.constant = 10
        left.constant = 10
        bottom.constant = 10
        right.constant = 10
    }
    
    func setupImageTitleStyle() {
        setupSideImageStyle()
        top.constant = 17
        left.constant = 10
        bottom.constant = 17
        right.constant = 10
        title.font = Fonts.getFont(name: .Regular, 16)
        subtitle.isHidden = true
    }
    
    func setupTopImageStyle() {
        image.isHidden = true
        topImage.isHidden = false
//        topPaddingView.isHidden = false
        mainStack.alignment = .bottom
        mainStack.spacing = -20
        top.constant = 40
        left.constant = 15
        bottom.constant = 20
        right.constant = 15
    }
    
    func setupActionMode() {
        image.isHidden = false
        topImage.isHidden = true
        subtitle.isHidden = true
        checkButton.isHidden = true
        imageHeight.constant = 18
        imageWidth.constant = 18
        title.size = 13
//        topPaddingView.isHidden = true
        mainStack.alignment = .center
        mainStack.spacing = 15
        top.constant = 13
        left.constant = 16
        bottom.constant = 13
        right.constant = 16
    }
    
    func setupTitleOnlyMode() {
        image.isHidden = true
        topImage.isHidden = true
        subtitle.isHidden = true
        title.size = 13
//        topPaddingView.isHidden = true
        mainStack.alignment = .center
        mainStack.spacing = 15
        top.constant = 13
        left.constant = 16
        bottom.constant = 13
        right.constant = 16
    }
     
     func setupTitleAndSubtitleOnlyMode() {
         image.isHidden = true
         topImage.isHidden = true
         checkButton.isHidden = true
//         title.size = 13
 //        topPaddingView.isHidden = true
         mainStack.alignment = .leading
         mainStack.spacing = 15
         top.constant = 13
         left.constant = 16
         bottom.constant = 13
         right.constant = 16
     }
     
     func setupTitleAndSubtitleWithImageOnlyMode() {
         topImage.isHidden = true
         checkButton.isHidden = true
//         title.size = 13
 //        topPaddingView.isHidden = true
         mainStack.alignment = .center
         mainStack.spacing = 15
         top.constant = 13
         left.constant = 25
         bottom.constant = 13
         right.constant = 16
     }
    
//    func setUpForNoCheckBox() {
//        image.isHidden = true
//        topImage.isHidden = true
//        subtitle.isHidden = true
//        checkButton.isHidden = true
//        title.size = 13
////        topPaddingView.isHidden = true
//        mainStack.alignment = .center
//        mainStack.spacing = 15
//        top.constant = 13
//        left.constant = 16
//        bottom.constant = 13
//        right.constant = 16
//    }
    
    public func getHeight() -> CGFloat {
        return title.bounds.height + 20
    }
    
    @objc func onTapped(_ sender: UITapGestureRecognizer) {
        model.tapped()
        model.state = true
    }
    
    func setState() {
        if model.state {
            layer.borderColor = UIColor.beachBlue.cgColor
//            backgroundColor = .bBLight
            checkButton.isChecked = true
        } else {
            layer.borderColor = UIColor.greyLight.darker(by: 8)?.cgColor
//            backgroundColor = .greyLight
            checkButton.isChecked = false
        }
    }
    
}

public struct SelectableViewModel {
    public var title: String = ""
    public var subtitle: String = ""
    public var image: UIImage = UIImage()
    public var state: Bool = false
    public var tapped: () -> Void = {}
//    public var noCheckBox: Bool = false
}

