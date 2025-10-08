//
//  SelectPropertyModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit

public class SelectorModal: BaseXib {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var title: SemiLabel!
    
    var selectedItem: PickerItem?
    var selectedItems: [PickerItem] = []
    private var filteredItems: [PickerItem] = []
    private var isMultipleSelectionMode: Bool = false
    
    public var model: SelectorModalModel = SelectorModalModel() {
        didSet {
            setupUI()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setupUI() {
        collectionView.reloadData()
        if isMultipleSelectionMode {
            collectionView.allowsMultipleSelection = true
            preselectItems()
        }
    }
    
    func setup() {
        setupUI()
        setupCollectionView()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 16
        flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: 48)
        collectionView.collectionViewLayout = flowLayout
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }
    
    private func preselectItems() {
        guard isMultipleSelectionMode else { return }
        
        let itemsToCheck = filteredItems.count > 0 ? filteredItems : model.items
        
        for (index, item) in itemsToCheck.enumerated() {
            if selectedItems.contains(where: { $0.value == item.value }) {
                let indexPath = IndexPath(row: index, section: 0)
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                
                // Update cell appearance
                if let cell = collectionView.cellForItem(at: indexPath) {
                    updateCellSelection(cell, selected: true)
                }
            }
        }
    }
    
    private func updateCellSelection(_ cell: UICollectionViewCell, selected: Bool) {
        for view in cell.subviews {
            if view is SelectableView {
                let v = view as! SelectableView
                v.model.state = selected
                v.setState()
            }
        }
    }
    
    @objc func handleSwipeDown() {
        if isMultipleSelectionMode {
            // Don't dismiss on swipe in multiple mode, require explicit action
            return
        }
        dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
    public func textChanged(_ textField: UITextField, range: NSRange, string: String) {
        let searchText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        filteredItems = model.items.filter({ $0.name.lowercased().contains(searchText.lowercased()) })
        collectionView.reloadData()
        
        if isMultipleSelectionMode {
            preselectItems()
        }
    }
    
}


//MARK: Collectionview Setup
extension SelectorModal: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredItems.count > 0 {
            return filteredItems.count
        } else {
            return model.items.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        cell.isUserInteractionEnabled = true
        let view = SelectableView(frame: cell.bounds)
        view.identifier = "Picker cell " + indexPath.description
        view.subtitleOnlyMode = true

        let item = filteredItems.count > 0 ? filteredItems[indexPath.row] : model.items[indexPath.row]
        view.model.image = UIImage(named: item.value) ?? UIImage()
        view.model.subtitle = item.name
        
        // Check if item is selected (for multiple selection mode)
        if isMultipleSelectionMode {
            let isSelected = selectedItems.contains(where: { $0.value == item.value })
            view.model.state = isSelected
        }
        
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.bounds.width, height: 48)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = filteredItems.count > 0 ? filteredItems[indexPath.row]: model.items[indexPath.row]
        
        if isMultipleSelectionMode {
            // Multiple selection mode - toggle selection
            let isCurrentlySelected = selectedItems.contains(where: { $0.value == item.value })
            
            if isCurrentlySelected {
                // Deselect the item
                selectedItems.removeAll(where: { $0.value == item.value })
                collectionView.deselectItem(at: indexPath, animated: false)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    updateCellSelection(cell, selected: false)
                }
            } else {
                // Select the item
                selectedItems.append(item)
                if let cell = collectionView.cellForItem(at: indexPath) {
                    updateCellSelection(cell, selected: true)
                }
            }
        } else {
            // Single selection mode (existing behavior)
            let cell = collectionView.cellForItem(at: indexPath)
            if let subviews = cell?.subviews {
                for view in subviews {
                    if view is SelectableView {
                        let v = view as! SelectableView
                        v.model.state = true
                    }
                }
            }
            selectedItem = item
            model.callback(selectedItem)
            dismiss()
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // This is only called in multiple selection mode when using collection view's built-in selection
        // We handle toggling in didSelectItemAt for multiple mode
        if !isMultipleSelectionMode {
            let cell = collectionView.cellForItem(at: indexPath)
            if let subviews = cell?.subviews {
                for view in subviews {
                    if view is SelectableView {
                        let v = view as! SelectableView
                        v.model.state = false
                    }
                }
            }
        }
    }
}

// MARK: Display Modal
extension SelectorModal {
    // Existing single selection method
    public static func show(title: String, items: [PickerItem], callBack: @escaping (PickerItem?) -> Void) {
        let backDrop = SelectorModalView(frame: Helpers.screen)
        backDrop.backgroundColor = .clear
        backDrop.applyDarkEffect()
        
        let modal = SelectorModal()
        modal.model.title = title
        modal.model.items = items
        modal.model.callback = callBack
        modal.isMultipleSelectionMode = false
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.4
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    // New multiple selection method
    public static func showMultiple(title: String, items: [PickerItem], selectedItems: [PickerItem] = [], callBack: @escaping ([PickerItem]) -> Void) {
        let backDrop = SelectorModalView(frame: Helpers.screen)
        backDrop.backgroundColor = .clear
        backDrop.applyDarkEffect()
        
        let modal = SelectorModal()
        modal.model.title = title
        modal.model.items = items
        modal.isMultipleSelectionMode = true
        modal.selectedItems = selectedItems
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        
        // Add Done button for multiple selection
        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        doneButton.backgroundColor = .systemBlue
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.layer.cornerRadius = 8
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        modal.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: modal.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: modal.trailingAnchor, constant: -16),
            doneButton.bottomAnchor.constraint(equalTo: modal.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        doneButton.addAction(UIAction { _ in
            callBack(modal.selectedItems)
            modal.dismiss()
        }, for: .touchUpInside)
        
        // Adjust collection view bottom constraint to accommodate done button
        if let collectionView = modal.collectionView {
            for constraint in modal.constraints {
                if constraint.firstItem as? UICollectionView == collectionView &&
                   constraint.firstAttribute == .bottom {
                    constraint.constant = -72 // Space for button
                }
            }
        }
        
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.5 // Slightly taller for multiple selection
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    public static func dismiss() {
        if let subviews = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.subviews {
            for view in subviews {
                if view is SelectorModalView {
                    for v in view.subviews {
                        if v is SelectorModal {
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                                v.frame.origin.y = Helpers.screenHeight
                                view.layoutIfNeeded()
                            }, completion: { _ in
                                view.removeFromSuperview()
                            })
                        }
                    }
               }
            }
        }
    }
}

public struct SelectorModalModel {
    var title: String = ""
    var items: [PickerItem] = []
    var callback: (PickerItem?) -> Void = { _ in }
}
class SelectorModalView: UIView {}
