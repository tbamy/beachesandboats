//
//  Labels.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

public enum Fonts: String {
    case Bold = "Montserrat-Bold"
    case Light = "Montserrat-Light"
    case Medium = "Montserrat-Medium"
    case Regular = "Montserrat-Regular"
    case SemiBold = "Montserrat-SemiBold"
    
    public static func getFont(name: Fonts, _ size: CGFloat ) -> UIFont {
        UIFont(name: name.rawValue, size: size) ?? UIFont()
    }
}

@IBDesignable public class CustomLabel: UILabel {
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }
    
    @IBInspectable public var boldText: String? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var boldTexts: [String]? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var linkText: String? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var linkText2: String? {
        didSet {
            setup()
        }
    }
    
    @IBInspectable var lineHeight: CGFloat = 0 {
        didSet {
            setupLineHeight()
        }
    }
    
    public override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        if let boldText = boldText {
            setBoldAttribute(boldPartOfString: [boldText], size: font.pointSize)
        }
        
        if let boldTexts = boldTexts {
            setBoldAttribute(boldPartOfString: boldTexts, size: font.pointSize)
        }
        
        if let linkText = linkText {
            setlinkAttribute(boldPartOfString: [linkText, linkText2 ?? ""], size: font.pointSize)
        }
        setupLineHeight()
    }
    
    func setupLineHeight() {
        guard lineHeight != 0 else { return }
        let alignment = textAlignment
        let attributedString = NSMutableAttributedString(string: text ?? "")
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineHeight // adjust the line height as desired
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, attributedString.length))
        attributedText = attributedString
        textAlignment = alignment
    }
}



@IBDesignable public class BoldLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 24 {
        didSet {
            setup(size)
        }
    }
    
    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 24) {
//        font = Fonts.getFont(name: .Bold, size)
    }
    
}

@IBDesignable public class ItalicLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 14 {
        didSet {
            setup(size)
        }
    }
    
    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 14) {
        let matrix = CGAffineTransform(a: 1.0, b: 0.0, c: 0.3, d: 1.0, tx: 0.0, ty: 0.0)
        let descriptor = Fonts.getFont(name: .Regular, size).fontDescriptor.withMatrix(matrix)
        font = UIFont(descriptor: descriptor, size: size)
    }
    
}

@IBDesignable public class MediumLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 22 {
        didSet {
            setup(size)
        }
    }

    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 22) {
//        font = Fonts.getFont(name: .Medium, size)
    }
}

@IBDesignable public class SemiLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 20 {
        didSet {
            setup(size)
        }
    }

    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 20) {
        font = Fonts.getFont(name: .SemiBold, size)
    }
}

@IBDesignable public class LightLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 16 {
        didSet {
            setup(size)
        }
    }

    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }
    
    func setup(_ size: CGFloat = 16) {
        font = Fonts.getFont(name: .Light, size)
    }
}

@IBDesignable public class RegularLabel: CustomLabel {

    @IBInspectable public var size: CGFloat = 13 {
        didSet {
            setup(size)
        }
    }
    
    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 13) {
//        font = Fonts.getFont(name: .Regular, size)
    }
}

public class BulletLabel: UILabel {
    
    public init(_ size: CGFloat = 13, style: Fonts = .Regular, text: String) {
        super.init(frame: .zero)
        setup(size, style: style, text: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func awakeFromNib() {
        setup()
        super.awakeFromNib()
    }

    func setup(_ size: CGFloat = 13, style: Fonts = .Regular, text: String = "") {
        self.text = text
        font = Fonts.getFont(name: style, size)
        sizeToFit()
        numberOfLines = 0
        textColor = .titleGrey
        
        let attributedText = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.headIndent = 10
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.minimumLineHeight = 22
        attributedText.addAttributes([.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
        self.attributedText = attributedText
    }
}

