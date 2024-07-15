//
//  Input.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

@IBDesignable public class PhoneField: InputField {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        setPhoneImage(for: true)
    }
    
    func setPhoneImage(for state: Bool) {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 5, width: 107, height: 27))
        imageView.image = Assets.NGnum.image
        imageView.tintColor = .background
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = iconContainer
    }
    
}


