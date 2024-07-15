//
//  PlainOutlineButton.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import UIKit

@IBDesignable public class PlainOutlineButton: UIButton {
    
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
        layer.borderColor = UIColor.beachBlue.cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
        titleLabel?.font = Fonts.getFont(name: .SemiBold, 14)
    }
}
