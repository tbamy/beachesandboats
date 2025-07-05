//
//  CustomView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/07/2025.
//

import UIKit

@IBDesignable class CustomView: UIView {
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var borderWidth: CGFloat = 0
    
    @IBInspectable var borderColor: UIColor = .clear
    
    @IBInspectable var background: UIColor = .white
    
    @IBInspectable var dashedBorder: Bool = false
    
    @IBInspectable var isRounded: Bool = false
    
    override func layoutSubviews() {
        setup()
    }
    
    func setup() {
        if dashedBorder {
            addDashedStroke(color: borderColor)
        } else {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
        layer.cornerRadius = isRounded ? bounds.width / 2 : cornerRadius
        backgroundColor = background
    }
}
