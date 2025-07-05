//
//  Input.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

@IBDesignable public class InputFieldWithLeftImg: InputField {
    
    @IBInspectable public var img: UIImage = Assets.NGnum.image {
        didSet {
            setPhoneImage()
        }
    }
    
    @IBInspectable public var imgWidth: Int = 100 {
        didSet {
            setPhoneImage()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        setPhoneImage()
    }
    
    func setPhoneImage() {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: imgWidth + 10, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: imgWidth, height: 25))
        imageView.image = img
        imageView.tintColor = .background
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = iconContainer
    }
    
}


