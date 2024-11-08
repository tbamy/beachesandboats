//
//  CheckboxButton.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/06/2024.
//

import UIKit

@IBDesignable public class CheckboxButton: UIButton {

    public enum ButtonType: String {
        case check
        case radio
    }

    @IBInspectable public var identifier: String = "" {
        didSet {
            self.accessibilityIdentifier = identifier
        }
    }
    
    @IBInspectable public var isChecked: Bool = false {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable public var btnType: String = ButtonType.check.rawValue {
        didSet {
            updateImage()
        }
    }
    
    @IBInspectable var tint: UIColor = .B_B {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var titleText: String = "" {
        didSet {
            setup()
        }
    }
    
    public var stateChanged: (Bool) -> Void = { _ in }

    public override func awakeFromNib() {
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setTitle("", for: .normal)
        if titleText != "" {
            setTitle("  " + titleText, for: .normal)
            setTitleColor(.textGrey, for: .normal)
            titleLabel?.font = .systemFont(ofSize: 12)
        }
        backgroundColor = .clear
        self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        self.isChecked = false
        updateImage()
        imageView?.tintColor = tint
    }

    private func updateImage() {
        let buttonTypeEnum = ButtonType(rawValue: btnType) ?? .check
        let image = isChecked ? checkedImage(for: buttonTypeEnum) : uncheckedImage(for: buttonTypeEnum)
        self.setImage(image, for: .normal)
    }

    private func checkedImage(for type: ButtonType) -> UIImage {
        switch type {
        case .check:
            return Assets.checkIcon.image
        case .radio:
            return Assets.radioOn.image
        }
    }

    private func uncheckedImage(for type: ButtonType) -> UIImage {
        switch type {
        case .check:
            return Assets.uncheckIcon.image
        case .radio:
            return Assets.radioOff.image
        }
    }

    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
            stateChanged(isChecked)
        }
    }
}
