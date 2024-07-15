//
//  PrimaryButton.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import UIKit

@IBDesignable public class PrimaryButton: UIButton {
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    public override func awakeFromNib() {
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        backgroundColor = .beachBlue
        layer.cornerRadius = 8.0
        setTitleColor(.white, for: .normal)
        layer.borderColor = UIColor.beachBlue.cgColor
        layer.borderWidth = 1.0
        setBackgroundColor(.grey, for: .disabled)
        tintColor = .white
        clipsToBounds = true
//        titleLabel?.font = Fonts.getFont(name: .SemiBold, 14)
    }
}

