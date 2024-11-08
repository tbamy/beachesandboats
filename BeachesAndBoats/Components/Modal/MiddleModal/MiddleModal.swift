//
//  MiddleModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import UIKit
import MessageUI

@IBDesignable public class MiddleModal: BaseXib {

    @IBOutlet weak var extraViewSpacer: UIView!
    @IBOutlet weak var tetiaryStack: UIStackView!
    @IBOutlet weak var extraViewTrailing: NSLayoutConstraint!
    @IBOutlet weak var etraViewLeading: NSLayoutConstraint!
    @IBOutlet weak var extraViewStack: UIStackView!
    @IBOutlet weak var tetiaryText: PaddedLabel!
    @IBOutlet weak var extraViewHeight: NSLayoutConstraint!
    @IBOutlet weak var subtitleHeight: NSLayoutConstraint!
    @IBOutlet weak var cancelButton: PlainOutlineButton!
    @IBOutlet weak var confirmButton: PrimaryButton!
    @IBOutlet weak var extraView: UIView!
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
       // subtitle.textAlignment = .justified
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
        cancelButton.isHidden = model.secondaryText.isEmpty
        title.text = model.modalTitle
        subtitle.text = model.modalSubtitle
        tetiaryText.text = model.tetiaryTitle
        tetiaryStack.isHidden = model.tetiaryTitle.isEmpty
        cancelButton.setTitle(model.secondaryText, for: .normal)
        confirmButton.setTitle(model.primaryText, for: .normal)
        icon.image = model.modalType.getImage()
        extraViewStack.isHidden = true
    }
    
    @objc func handleSwipeDown() {
        if model.dismissable {
            print(model.dismissable)
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
        contentHeight += !icon.isHidden ? icon.bounds.height + 10.0 : 0
        contentHeight += !title.isHidden ? title.bounds.height + 10.0 : 0
        contentHeight += !subtitle.isHidden ? subtitle.bounds.height + 10.0 : 0
        contentHeight += !extraViewStack.isHidden ? extraViewStack.bounds.height + 10.0 : 0
        contentHeight += !confirmButton.isHidden ? confirmButton.bounds.height + 10.0 : 0
        contentHeight += !cancelButton.isHidden ? cancelButton.bounds.height + 10.0 : 0
        contentHeight += !tetiaryStack.isHidden ? tetiaryStack.bounds.height + 12.0 : 0
        
        return contentHeight
    }
    
    
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
    
    public static func showV2 (
        title: String = "",
        subtitle: String = "",
        type: ModalType = .caution,
        icon: UIImage = UIImage(),
        primaryText: String = "Okay",
        secondaryText: String = "",
        dismissable: Bool = true,
        dismissOnConfirm: Bool = true,
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {})  -> UIView
    {
        return handleShow(title: title, subtitle: subtitle, type: type, icon: icon, primaryText: primaryText, secondaryText: secondaryText, dismissable: dismissable, dismissOnConfirm: dismissOnConfirm, onConfirm: onConfirm, onCancel: onCancel)
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
        
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        
        // Calculate the modal's position to center it vertically
        let modalHeight = modal.getHeight()
        let centerY = (Helpers.screenHeight - modalHeight) / 2
        
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: modalHeight)
        modal.subtitleHeight.isActive = false
        backDrop.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            modal.frame.origin.y = centerY
            backDrop.layoutIfNeeded()
        }, completion: nil)
        
        return backDrop
    }

   
    
    public static func showProcessing(
        title: String = "Thank you",
        subtitle: String = "Your transaction is being processed",
        tetiaryText: String = "If you are not redirected in 30 seconds, use the refresh button below to manually check your transaction status",
        dismissable: Bool = false,
        confirmText: String = "Refresh",
        cancelText: String = "",
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {})
    {
        MiddleModal.show(title: title, subtitle: subtitle, tetiaryTitle: tetiaryText, type: .pending, primaryText: confirmText, secondaryText: cancelText, dismissable: dismissable, dismissOnConfirm: false, onConfirm: onConfirm, onCancel: onCancel)
    }
    
    public static func dismiss() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            let subviews = keyWindow.subviews
            for view in subviews {
                if view is MiddleModalView {
                    for v in view.subviews {
                        if v is MiddleModal {
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

class MiddleModalView: UIView {}
