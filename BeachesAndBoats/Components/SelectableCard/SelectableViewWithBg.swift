//
//  SelectableViewWithBg.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/07/2025.
//

import UIKit

@IBDesignable public class SelectableViewWithBg: BaseXib, Sizeable {
    
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var title: MediumLabel!
    @IBOutlet weak var bg: CustomView!
   
   
   @IBInspectable public var identifier: String = "" { didSet {
       self.accessibilityIdentifier = identifier
   } }
   
   @IBInspectable var titleOnlyMode: Bool = false {
       didSet { setup() }
   }

    @IBInspectable var selectMultiple: Bool = false {
        didSet { setup() }
    }
   
   
   @IBInspectable var state: Bool = false {
       didSet { model.state = state }
   }
   
   @IBInspectable var titleText: String = "" {
       didSet { model.title = titleText }
   }
   
   public var model: SelectableViewWithBgModel = SelectableViewWithBgModel() {
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
       bg.borderWidth = 1
       bg.borderColor = .background
       bg.background = .clear
       
       setState()
       updateHeight()
//       addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped(_:))))
       if titleOnlyMode {
           setupTitleOnlyMode()
       } else {
           setupNormal()
       }
       
   }
   

   
   func setupNormal() {
       iconImg.isHidden = false
       
       if let url = URL(string: model.image.replacingOccurrences(of: "http://", with: "https://")) {
           iconImg.kf.setImage(
               with: url,
               placeholder: UIImage(named: model.dummyImage),
               options: nil,
               completionHandler: { result in
                   switch result {
                   case .success(let value):
                       print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                   case .failure(let error):
                       print("Failed to load image: \(error.localizedDescription)")
                       self.iconImg.image = UIImage(named: self.model.dummyImage)
                   }
               }
           )
       } else {
           iconImg.image = UIImage(named: "luxuryIcon")
       }
   }
   
   func setupTitleOnlyMode() {
       iconImg.isHidden = true
   }
   
   public func getHeight() -> CGFloat {
       return title.bounds.height + 20
   }
   
   func setState() {
       if model.state {
           bg.borderColor = .beachBlue
           bg.background = .beachBlue
           title.textColor = .white
       } else {
           bg.borderColor = .background
           bg.background = .clear
           title.textColor = .black
       }
   }
   
}

public struct SelectableViewWithBgModel {
   public var title: String = ""
   public var image: String = ""
   public var dummyImage: String = ""
   public var state: Bool = false
   public var tapped: () -> Void = {}
   public var selectMultiple: Bool = false
}
