//
//  SecondaryButton.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/07/2025.
//

import UIKit

@IBDesignable public class SecondaryButton: UIButton {
    
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
        backgroundColor = .clear
        layer.cornerRadius = 8.0
        setTitleColor(.beachBlue, for: .normal)
//        tintColor = .background.darker(by: 30)
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
//        titleLabel?.font = Fonts.getFont(name: .SemiBold, 14)
    }
}
