//
//  DateRangePicker.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/09/2024.
//

import UIKit

public class DateRangePicker: InputField{
    
    
    public var onSelected: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        textField.isEnabled = false
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleTapped))
        addGestureRecognizer(tapped)
    }
    
    func setImage() {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 12))
        let imageView = UIImageView(frame: CGRect(x: 12, y: 0, width: 12, height: 12))
        imageView.image = UIImage(named: "carat.png")
        imageView.tintColor = .background
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.leftViewMode = UITextField.ViewMode.always
        textField.leftView = iconContainer
        textField.returnKeyType = .done
    }
    
    
    @objc func handleTapped() {
//        DateRangePage.startDateRangeModal(on: <#T##UIView#>, delegate: <#T##DateRangeDelegate#>)
    }
}
