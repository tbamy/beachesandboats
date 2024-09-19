//
//  PaddedLabel.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

@IBDesignable public class PaddedLabel: MediumLabel {
    
    let padding = UIEdgeInsets(top: 6, left: 10, bottom: 6, right: 10)
    @IBInspectable var color: UIColor = .textGrey {
        didSet {
            setupPad()
        }
    }
    
    @IBInspectable public var background: UIColor = UIColor.textGrey.lighter(by: 55) ?? UIColor() {
        didSet {
            setupPad()
        }
    }
    
    public var colorType: ColorTypes? {
        didSet { setupPad() }
    }
    
    public var onTapped: () -> Void = {}
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupPad()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPad()
    }
    
    public override func layoutSubviews() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:))))
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        onTapped()
    }
    
    public override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += padding.left + padding.right
        size.height += padding.top + padding.bottom
        return size
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    
    func setupPad() {
        layer.cornerRadius = 4
//        font = Fonts.getFont(name: .Medium, 12)
        textColor = color
        backgroundColor = background
        clipsToBounds = true
        textAlignment = .center
        
        if let colorType = colorType {
            switch colorType {
            case .blue:
                textColor = .beachBlue
                backgroundColor = .background
            case .grey:
                textColor = .textGrey
                backgroundColor = .textGrey.lighter(by: 55)
            case .success:
                textColor = .success
                backgroundColor = .successLight
            case .pending:
                textColor = .pending
                backgroundColor = .pendingLight
            }
        }
    }
    
    public enum ColorTypes {
        case grey, blue, success, pending
    }
}

