//
//  ListingNotif.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 04/10/2024.
//

import UIKit

class ListingNotif: BaseXib {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var continueBtn: PrimaryButton!
    
    var dismissable: Bool = true
    var dismissOnConfirm: Bool = true
    var onConfirm: () -> Void = {}
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)

    }
    
    @objc func handleSwipeDown() {
        if dismissable {
            dismiss()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
    func getHeight() -> CGFloat {
        var contentHeight = 50.0
        contentHeight += !title.isHidden ? title.bounds.height + 10.0 : 0
        contentHeight += !contentStack.isHidden ? contentStack.bounds.height + 10.0 : 0
        contentHeight += !continueBtn.isHidden ? continueBtn.bounds.height + 10.0 : 0
        
        return contentHeight
    }
    
    
    @IBAction func onConfirmTapped(_ sender: Any) {
        onConfirm()
        if dismissOnConfirm {
            dismiss()
        }
    }
    
    public static func show(onConfirm: @escaping () -> Void = {}) {
        let backDrop = UIView(frame: Helpers.screen)
        backDrop.backgroundColor = .gray.withAlphaComponent(0.5)
        
        let modal = ListingNotif()
        modal.onConfirm = onConfirm
        modal.layer.cornerRadius = 12
        modal.backgroundColor = .white
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
    
    public static func dismiss() {
        if let subviews = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.subviews {
            for view in subviews {
                for v in view.subviews {
                    if v is ListingNotif {
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

