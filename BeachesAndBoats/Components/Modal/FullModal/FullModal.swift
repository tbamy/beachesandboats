//
//  FullModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 03/08/2024.
//

import UIKit

public class FullModal: BaseXib {
    @IBOutlet weak var titleSpacer: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var title: SemiLabel!
    @IBOutlet weak var secondaryTitle: SemiLabel!
    @IBOutlet weak var bodyStack: UIStackView!
    @IBOutlet weak var cancelBtn: PlainOutlineButton!
    @IBOutlet weak var confirmBtn: PrimaryButton!
    @IBOutlet weak var closeButton: UIButton!
    
    public static var currentModal: FullModal?
    
    var model: FullModalModel = FullModalModel() {
        didSet { setup() }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        confirmBtn.setTitle(model.confirmText, for: .normal)
        cancelBtn.setTitle(model.cancelText, for: .normal)
        confirmBtn.isHidden = model.confirmText.isEmpty
        cancelBtn.isHidden = model.cancelText.isEmpty
        title.text = model.title
        secondaryTitle.text = model.secondaryTitle
        bodyStack.subviews.forEach { $0.removeFromSuperview() }
        bodyStack.spacing = 10
        model.views.forEach {
            $0.frame = bodyStack.bounds
            bodyStack.addArrangedSubview($0)
        }
        closeButton.isHidden = model.fullScreen
        titleSpacer.isHidden = !model.fullScreen
        
        setConfirmButtonEnabled(model.isConfirmButtonEnabled)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        dismiss()
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        dismiss()
        model.onConfirm()
    }
    
    @IBAction func declineTapped(_ sender: Any) {
        dismiss()
        model.onCancel()
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.frame.origin.y = Helpers.screenHeight
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.superview?.removeFromSuperview()
        })
    }
    
    public static func show(title: String = "", secondaryTitle: String = "", views: [UIView] = [], fullScreen: Bool = false, confirmText: String = "", cancelText: String = "", onConfirm: @escaping () -> Void = {}, onCancel: @escaping () -> Void = {}) {
        let backDrop = FullModalView(frame: Helpers.screen)
        backDrop.backgroundColor = .clear
        backDrop.applyDarkEffect()
        
        let modal = FullModal()
        currentModal = modal
        modal.model.onCancel = onCancel
        modal.model.onConfirm = onConfirm
        modal.model.confirmText = confirmText
        modal.model.cancelText = cancelText
        modal.model.title = title
        modal.model.views = views
        modal.model.fullScreen = fullScreen
        modal.model.secondaryTitle = secondaryTitle
        modal.layer.cornerRadius = fullScreen ? 0 : 12
        modal.clipsToBounds = true
        backDrop.addSubview(modal)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        let height = fullScreen ? Helpers.screenHeight : Helpers.screenHeight * 0.8
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
                if view is FullModalView {
                    for v in view.subviews {
                        if v is FullModal {
                            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                                v.frame.origin.y = Helpers.screenHeight
                                view.layoutIfNeeded()
                            }, completion: { _ in
                                view.removeFromSuperview()
                                currentModal = nil
                            })
                        }
                    }
               }
            }
        }
    }
}

struct FullModalModel {
    var title: String = ""
    var secondaryTitle: String = ""
    var views: [UIView] = []
    var fullScreen: Bool = false
    var confirmText: String = ""
    var cancelText: String = ""
    var onConfirm: () -> Void = {}
    var onCancel: () -> Void = {}
    var isConfirmButtonEnabled: Bool = true
}

class FullModalView: UIView {}

extension FullModal{
   public func setConfirmButtonEnabled(_ isEnabled: Bool) {
        confirmBtn.isEnabled = isEnabled
    }
            
}
