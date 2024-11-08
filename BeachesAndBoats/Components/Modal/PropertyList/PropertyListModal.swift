//
//  PropertyListModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit

public class PropertyListModal: BaseXib {

    @IBOutlet weak var beachHouseStack: UIStackView!
    @IBOutlet weak var beachHouseIcon: UIImageView!
    @IBOutlet weak var boatStack: UIStackView!
    @IBOutlet weak var boatIcon: UIImageView!
    @IBOutlet weak var beachBoatStack: UIStackView!
    @IBOutlet weak var beachBoatIcon: UIImageView!
    
    var selectedItem: PickerItem?
    var callback: (PickerItem?) -> Void = { _ in }
    
    let nibName = "PropertyListModal"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    
    func addGestureRecognizers(){
        beachHouseStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beachTapped)))
        boatStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(boatTapped)))
        beachBoatStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(beachBoatStackTapped)))
    }
    
    @objc func beachTapped(){
        selectedItem?.name = "Beach House"
        selectedItem?.value = "1"
        beachHouseIcon.image = UIImage.radioOn
        boatIcon.image = UIImage.radioOff
        beachBoatIcon.image = UIImage.radioOff
        callback(selectedItem)
        dismiss()
    }
    
    @objc func boatTapped(){
        selectedItem?.name = "Boat"
        selectedItem?.value = "2"
        beachHouseIcon.image = UIImage.radioOff
        boatIcon.image = UIImage.radioOn
        beachBoatIcon.image = UIImage.radioOff
        callback(selectedItem)
        dismiss()
    }
    
    @objc func beachBoatStackTapped(){
        selectedItem?.name = "Boat Beach Houses and Boats"
        selectedItem?.value = "3"
        beachHouseIcon.image = UIImage.radioOff
        boatIcon.image = UIImage.radioOff
        beachBoatIcon.image = UIImage.radioOn
        callback(selectedItem)
        dismiss()
    }

    
    func setup() {
        addGestureRecognizers()
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
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
    
}

// MARK: Display Modal
extension PropertyListModal {
    public static func show(selectedItem: PickerItem? = nil, callBack: @escaping (PickerItem?) -> Void) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = PropertyListModal()
        modal.callback = callBack
        modal.selectedItem = selectedItem ?? PickerItem(name: "", value: "")
        
        modal.backgroundColor = .white
        modal.layer.cornerRadius = 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = Helpers.screenHeight * 0.25
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = Helpers.screenHeight - height
            backDrop.layoutIfNeeded()
        }, completion: nil)
    }
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let subviews = keyWindow.subviews
            for view in subviews {
                for v in view.subviews {
                    if v is PropertyListModal {
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

