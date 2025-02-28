//
//  NotificationViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 27/02/2025.
//

import UIKit

class NotificationViewCell: BaseXib {

    @IBOutlet weak public var bgView: UIView!
    @IBOutlet weak public var nameLabel: UILabel!
    @IBOutlet weak public var subtitleLabel: UILabel!
    @IBOutlet weak public var toggleSwitch: UISwitch!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public var model: NotificationViewCellModel = NotificationViewCellModel() {
        didSet {
            setup()
        }
    }
    @IBInspectable public var isToggled: Bool = false {
         didSet {
            toggleSwitch.isOn = isToggled

         }
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
     
     public func setTitle(_ name: String?) {
         nameLabel.text = name
     }
    
    public func setSubtitle(_ name: String?) {
        subtitleLabel.text = name
    }
    public func setStatus(_ status: Bool?) {
        toggleSwitch.isOn = status ?? false
    }
    
//    @objc func onTapped(_ sender: UITapGestureRecognizer) {
//        model.tapped()
//        model.state = true
//    }
    
    func setState() {
        toggleSwitch.isOn = isToggled
    }

    
     func setup(){
        setState()
         toggleSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)

        nameLabel.text = model.title
        subtitleLabel.text = model.subtitle
        bgView.backgroundColor = UIColor.background.lighter(by: 17)
         toggleSwitch.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
         self.isToggled = false
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isToggled = !isToggled
//            stateChanged(isToggled)
        }
    }
    

}

public struct NotificationViewCellModel {
   public var title: String = ""
   public var subtitle: String = ""
   public var state: Bool = false
//   public var tapped: () -> Void = {}
}
