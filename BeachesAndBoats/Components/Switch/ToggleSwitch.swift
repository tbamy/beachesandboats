//
//  ToggleSwitch.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/10/2024.
//

import UIKit

class ToggleSwitch: BaseXib {
    @IBOutlet weak public var bgView: UIView!
    @IBOutlet weak public var nameLabel: UILabel!
    @IBOutlet weak public var toggleSwitch: UISwitch!
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public var model: ToggleSwitchModel = ToggleSwitchModel() {
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
//         layer.borderWidth = 2
//         layer.cornerRadius = 6.0
        nameLabel.text = model.title
//         print("Displaying \(model.title)")
        bgView.backgroundColor = UIColor.background.lighter(by: 17)
//        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapped(_:))))
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

public struct ToggleSwitchModel {
   public var title: String = ""
   public var state: Bool = false
//   public var tapped: () -> Void = {}
}
        
