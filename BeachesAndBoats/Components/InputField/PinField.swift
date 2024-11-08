//
//  PinField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 13/10/2024.
//

import UIKit

@IBDesignable
public class PinField: UITextField {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        backgroundColor = .clear
        layer.borderColor = UIColor.beachBlue.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
}

