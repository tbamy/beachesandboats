//
//  MiddleModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import UIKit
import MessageUI

@IBDesignable public class MiddleModal: BaseXib {

    @IBOutlet weak var cancelButton: PlainOutlineButton!
    @IBOutlet weak var confirmButton: PrimaryButton!
    @IBOutlet weak var subtitle: RegularLabel!
    @IBOutlet weak var title: BoldLabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentStack: UIStackView!
    @IBOutlet weak var backView: UIView!
    
    var model: MiddleModalModel = MiddleModalModel() {
        didSet {
            setup(model)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup(model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(model)
    }
    
    func setup(_ model: MiddleModalModel) {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
        
        // Hide/show elements based on content
        cancelButton.isHidden = model.secondaryText.isEmpty
        subtitle.isHidden = model.modalSubtitle.isEmpty
        title.isHidden = model.modalTitle.isEmpty
        
        // Set content
        title.text = model.modalTitle
        
        // Clean up subtitle text and configure for multiline
//        let cleanSubtitle = model.modalSubtitle.replacingOccurrences(of: "\u00a0", with: " ")
        subtitle.text = model.modalSubtitle
        subtitle.numberOfLines = 0 // Allow multiple lines
        subtitle.lineBreakMode = .byWordWrapping
        subtitle.preferredMaxLayoutWidth = Helpers.screenWidth - 40 // Adjust for modal padding
        
        cancelButton.setTitle(model.secondaryText, for: .normal)
        confirmButton.setTitle(model.primaryText, for: .normal)
        icon.image = model.modalType.getImage()
        
        // Force layout update after setting text
        subtitle.setNeedsLayout()
        subtitle.layoutIfNeeded()
    }

    func getHeight() -> CGFloat {
        // Force layout to ensure all subviews have correct sizes
        setNeedsLayout()
        layoutIfNeeded()
        
        var contentHeight: CGFloat = 60.0 // Base padding
        
        // Add icon height if visible and has content
        if !icon.isHidden && icon.image != nil {
            let iconSize = icon.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            contentHeight += iconSize.height + 10.0
        }
        
        // Add title height if visible and has text
        if !title.isHidden && !(title.text?.isEmpty ?? true) {
            // Set preferred max width for accurate height calculation
            title.preferredMaxLayoutWidth = Helpers.screenWidth - 40
            let titleSize = title.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            contentHeight += titleSize.height + 10.0
        }
        
        // Add subtitle height if visible and has text
        if !subtitle.isHidden && !(subtitle.text?.isEmpty ?? true) {
            // Ensure preferred max width is set for multiline calculation
            subtitle.preferredMaxLayoutWidth = Helpers.screenWidth - 40
            let subtitleSize = subtitle.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            contentHeight += subtitleSize.height + 10.0
        }
        
        // Add confirm button height if visible
        if !confirmButton.isHidden {
            let confirmSize = confirmButton.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            contentHeight += confirmSize.height + 20.0
        }
        
        // Add cancel button height if visible and has text
        if !cancelButton.isHidden && !(cancelButton.titleLabel?.text?.isEmpty ?? true) {
            let cancelSize = cancelButton.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            contentHeight += cancelSize.height + 20.0
        }
        
        return contentHeight
    }
    
//    func setup(_ model: MiddleModalModel) {
//        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
//        swipeDown.direction = .down
//        addGestureRecognizer(swipeDown)
//        cancelButton.isHidden = model.secondaryText.isEmpty
//        title.text = model.modalTitle
//        subtitle.text = model.modalSubtitle
//        cancelButton.setTitle(model.secondaryText, for: .normal)
//        confirmButton.setTitle(model.primaryText, for: .normal)
//        icon.image = model.modalType.getImage()
//    }
    
    @objc func handleSwipeDown() {
        if model.dismissable {
            print(model.dismissable)
            dismiss()
        }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
//    func getHeight() -> CGFloat {
//        var contentHeight = 60.0
//        contentHeight += !icon.isHidden ? icon.bounds.height + 10.0 : 0
//        contentHeight += !title.isHidden ? title.bounds.height + 10.0 : 0
//        contentHeight += !subtitle.isHidden ? subtitle.bounds.height + 10.0 : 0
////        contentHeight += !extraViewStack.isHidden ? extraViewStack.bounds.height + 10.0 : 0
//        contentHeight += !confirmButton.isHidden ? confirmButton.bounds.height + 20.0 : 0
//        contentHeight += !cancelButton.isHidden ? cancelButton.bounds.height + 20.0 : 0
////        contentHeight += !tetiaryStack.isHidden ? tetiaryStack.bounds.height + 12.0 : 0
//        
//        return contentHeight
//    }
    
    
    @IBAction func onConfirmTapped(_ sender: Any) {
        model.onConfirm()
        if model.dismissOnConfirm {
            dismiss()
        }
    }
    
    @IBAction func onCancelTapped(_ sender: Any) {
        model.onCancel()
        dismiss()
    }
    
    public static func show(
        title: String = "",
        subtitle: String = "",
        tetiaryTitle: String = "",
        extraView: UIView? = nil,
        type: ModalType = .caution,
        icon: UIImage = UIImage(),
        primaryText: String = "Okay",
        secondaryText: String = "",
        dismissable: Bool = true,
        dismissOnConfirm: Bool = true,
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {})
    {
        _ = handleShow(title: title, subtitle: subtitle, tetiaryTitle: tetiaryTitle, extraView: extraView, type: type, icon: icon, primaryText: primaryText, secondaryText: secondaryText, dismissable: dismissable, dismissOnConfirm: dismissOnConfirm, onConfirm: onConfirm, onCancel: onCancel)
    }
    
    public static func handleShow (
        title: String = "",
        subtitle: String = "",
        tetiaryTitle: String = "",
        extraView: UIView? = nil,
        type: ModalType = .caution,
        icon: UIImage = UIImage(),
        primaryText: String = "Okay",
        secondaryText: String = "",
        dismissable: Bool = true,
        dismissOnConfirm: Bool = true,
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {}) -> UIView
    {
        let backDrop = MiddleModalView(frame: Helpers.screen)
        backDrop.backgroundColor = .clear
        
        backDrop.applyDarkEffect()
        let modal = MiddleModal(frame: CGRect(x: 0, y: 0, width: Helpers.screenWidth, height: 500))
        modal.model = MiddleModalModel(
            modalTitle: title,
            modalSubtitle: subtitle,
            tetiaryTitle: tetiaryTitle,
            extraView: extraView,
            primaryText: primaryText,
            secondaryText: secondaryText,
            modalType: type,
            dismissable: dismissable,
            dismissOnConfirm: dismissOnConfirm,
            onConfirm: onConfirm,
            onCancel: onCancel)
        modal.icon.image = type == .defaultModal ? icon : type.getImage()
        modal.layer.cornerRadius = 30
        modal.backgroundColor = .white
        modal.clipsToBounds = true
        
        modal.setNeedsLayout()
        modal.layoutIfNeeded()
        
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        
        // Calculate the modal's position to center it vertically
        let modalHeight = modal.getHeight()
        let centerY = (Helpers.screenHeight - modalHeight) / 2
        
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: modalHeight)
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = centerY
            backDrop.layoutIfNeeded()
        }, completion: nil)
        
        return backDrop
    }
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let subviews = keyWindow.subviews
            for view in subviews {
                if view is MiddleModalView {
                    for v in view.subviews {
                        if v is MiddleModal {
                            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseIn, animations: {
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

class MiddleModalView: UIView {}
