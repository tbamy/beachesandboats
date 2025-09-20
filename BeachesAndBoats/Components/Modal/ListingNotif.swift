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
    
    private func setup() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    @objc private func handleSwipeDown() {
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
    
    /// Ask Auto Layout for the correct height
    func getHeight(for width: CGFloat) -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        
        return systemLayoutSizeFitting(
            CGSize(width: width, height: UIView.layoutFittingCompressedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        ).height
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
        
        // Start with zero height
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: 0)
        
        let height = modal.getHeight(for: Helpers.screenWidth)
        
        // Apply the height
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: height)
        backDrop.layoutIfNeeded()
        
        // Animate modal into view
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
