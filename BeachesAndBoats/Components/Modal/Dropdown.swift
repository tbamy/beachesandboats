//
//  Dropdown.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import Foundation
import UIKit

public class DropDown: InputField {
    
    @IBInspectable public var pickerTitle: String = ""
    @IBInspectable public var allowMultipleSelection: Bool = false
    
    public var items: [PickerItem] = []
    
    // Single selection properties
    public var selectedItem: PickerItem? {
        didSet {
            if !allowMultipleSelection {
                textField.text = selectedItem?.name
                id = selectedItem?.value ?? ""
            }
        }
    }
    public var itemChanged: (PickerItem) -> Void = { _ in }
    public var id: String = ""
    
    // Multiple selection properties
    public var selectedItems: [PickerItem] = [] {
        didSet {
            if allowMultipleSelection {
                updateTextFieldForMultipleSelection()
            }
        }
    }
    public var itemsChanged: ([PickerItem]) -> Void = { _ in }
    public var ids: [String] = []
    
    public var fieldEdited: () -> Void = {}

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
    
    private func updateTextFieldForMultipleSelection() {
        if selectedItems.isEmpty {
            textField.text = ""
            ids = []
        } else if selectedItems.count == 1 {
            textField.text = selectedItems[0].name
            ids = [selectedItems[0].value]
        } else {
            textField.text = "\(selectedItems.count) items selected"
            ids = selectedItems.map { $0.value }
        }
    }
    
    // Single selection setter
    public func setItem(with item: PickerItem) {
        textField.text = item.name
        id = item.value
        selectedItem = item
    }
    
    // Multiple selection setter
    public func setItems(with items: [PickerItem]) {
        selectedItems = items
        updateTextFieldForMultipleSelection()
    }

    @objc func pickerTapped(_ sender: UITapGestureRecognizer) {
        if allowMultipleSelection {
            // Multiple selection mode
            SelectorModal.showMultiple(
                title: pickerTitle,
                items: items,
                selectedItems: selectedItems,
                callBack: { [weak self] selectedItems in
                    guard let self = self else { return }
                    self.selectedItems = selectedItems
                    self.error = ""
                    self.fieldEdited()
                    self.itemsChanged(selectedItems)
                }
            )
        } else {
            // Single selection mode (existing behavior)
            SelectorModal.show(title: pickerTitle, items: items, callBack: { [weak self] item in
                guard self?.items.count ?? 0 > 0 else { return }
                self?.selectedItem = item
                self?.error = ""
                self?.fieldEdited()
                
                guard let selectedItem = self?.selectedItem else { return }
                self?.itemChanged(selectedItem)
            })
        }
    }
}
