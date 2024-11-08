//
//  PropertyListField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import Foundation
import UIKit

public class PropertyListField: InputField {
    
    public var selectedItem: PickerItem? {
        didSet {
            textField.text = selectedItem?.name
            id = selectedItem?.value ?? ""
        }
    }
    public var itemChanged: (PickerItem) -> Void = { _ in }
    public var fieldEdited: () -> Void = {}
    public var id: String = ""

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
        setLeftImage()
        
        textBlocker.isHidden = false
        textBlocker.addGestureRecognizer(UITapGestureRecognizer(target: self, action:  #selector(self.pickerTapped(_:))))
    }
    
    func setLeftImage() {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 12))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 12, height: 12))
        
        imageView.image = Assets.dropdownIcon.image
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        iconContainer.addSubview(imageView)
        textField.rightViewMode = UITextField.ViewMode.always
        textField.rightView = iconContainer
    }
    
//    public func setItem(with item: String) {
//        textField.text = item
//        id = item
//        selectedItem = item
//    }

    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
        PropertyListModal.show(callBack: { [weak self] in
            self?.selectedItem = $0
            self?.textField.text = self?.selectedItem?.name
            self?.error = ""
            self?.fieldEdited()
            
            guard let selectedItem = self?.selectedItem else { return }
            self?.text = selectedItem.name
        })
    }
}
