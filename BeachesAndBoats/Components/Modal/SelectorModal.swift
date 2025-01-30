//
//  SelectPropertyModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit

public class SelectorModal: BaseXib {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var title: SemiLabel!
    
    var selectedItem: PickerItem?
    private var filteredItems: [PickerItem] = []
    
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
    
//    @IBAction func donetapped(_ sender: Any) {
//        if selectedItem == nil {
//            Toast.show(message: "Please select an option or swipe down to dismiss")
//            return
//        }
//        model.callback(selectedItem)
//        dismiss()
//    }
    
    func setupUI() {
        collectionView.reloadData()
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
    
    @objc func handleSwipeDown() {
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
        view.titleOnlyMode = true

//        view.model.noCheckBox = true
//        if view.model.noCheckBox == true {
//            view.noCheckBox = true
//        } else {
//            view.titleOnlyMode = true
//        }

        let item = filteredItems.count > 0 ? filteredItems[indexPath.row] : model.items[indexPath.row]
        view.model.image = UIImage(named: item.value) ?? UIImage()
        view.model.title = item.name
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
        let cell = collectionView.cellForItem(at: indexPath)
        guard let subviews = cell?.subviews else { return }
        for view in subviews {
            if view is SelectableView {
                let v = view as! SelectableView
                v.model.state = true
            }
        }
        selectedItem = filteredItems.count > 0 ? filteredItems[indexPath.row]: model.items[indexPath.row]
        model.callback(selectedItem)
        dismiss()
    }

    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        guard let subviews = cell?.subviews else { return }
        for view in subviews {
            if view is SelectableView {
                let v = view as! SelectableView
                v.model.state = false
            }
        }
    }
}

// MARK: Display Modal
extension SelectorModal {
    public static func show(title: String, items: [PickerItem], callBack: @escaping (PickerItem?) -> Void) {
        let backDrop = SelectorModalView(frame: Helpers.screen)
        backDrop.backgroundColor = .clear
        backDrop.applyDarkEffect()
        
        let modal = SelectorModal()
        modal.model.title = title
        modal.model.items = items
        modal.model.callback = callBack
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.65
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
