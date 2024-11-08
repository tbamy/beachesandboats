//
//  SelectableCheckbox.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/10/2024.
//

import UIKit

@IBDesignable public class SelectableCheckbox: BaseXib, Sizeable {

    @IBOutlet weak var left: NSLayoutConstraint!
//    @IBOutlet weak var bottom: NSLayoutConstraint!
//    @IBOutlet weak var top: NSLayoutConstraint!
    @IBOutlet weak var right: NSLayoutConstraint!
    
    
    @IBOutlet weak public var checkButton: CheckboxButton!
    @IBOutlet weak private var subtitle: LightLabel!
    @IBOutlet weak private var title: MediumLabel!
   
   
   @IBInspectable public var identifier: String = "" { didSet {
       self.accessibilityIdentifier = identifier
   } }
   
   @IBInspectable var titleOnlyMode: Bool = false {
       didSet { setup() }
   }

   
   @IBInspectable var state: Bool = false {
       didSet { model.state = state }
   }
   
   @IBInspectable var titleText: String = "" {
       didSet { model.title = titleText }
   }
   
   @IBInspectable var subtitleText: String = "" {
       didSet { model.subtitle = subtitleText }
   }
   
   public var model: SelectableCheckboxModel = SelectableCheckboxModel() {
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
       
//       layer.borderWidth = 2
//       layer.cornerRadius = 6.0
       setState()
       updateHeight()
       addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped(_:))))
       if titleOnlyMode {
           setupTitleOnlyMode()
       } else {
           setupNormal()
       }
       
   }
   

   
   func setupNormal() {
//       top.constant = 40
       left.constant = 15
//       bottom.constant = 20
       right.constant = 15
   }
   
   func setupTitleOnlyMode() {
       subtitle.isHidden = true
       title.size = 13
//       top.constant = 13
       left.constant = 16
//       bottom.constant = 13
       right.constant = 16
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

public struct SelectableCheckboxModel {
   public var title: String = ""
   public var subtitle: String = ""
   public var state: Bool = false
   public var tapped: () -> Void = {}
}
