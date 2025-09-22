//
//  MiddleModal.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/09/2024.
//

import UIKit

public class MiddleModal: UIView {
    
    private let backView = UIView()
    private let contentStack = UIStackView()
    private let icon = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let confirmButton = PrimaryButton()
    private let cancelButton = PlainOutlineButton()
    
    var model: MiddleModalModel = MiddleModalModel() {
        didSet { setup(model) }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setup(model)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setup(model)
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        // backView
        backView.backgroundColor = .white
        backView.layer.cornerRadius = 30
        backView.clipsToBounds = true
        backView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backView)
        
        // contentStack
        contentStack.axis = .vertical
        contentStack.spacing = 12
        contentStack.alignment = .fill
        contentStack.distribution = .fill
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(contentStack)
        
        // icon
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        contentStack.addArrangedSubview(icon)
        NSLayoutConstraint.activate([
            icon.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // title
        titleLabel.font = .boldSystemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        contentStack.addArrangedSubview(titleLabel)
        
        // subtitle
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.textAlignment = .center
        contentStack.addArrangedSubview(subtitleLabel)
        
        // confirm button
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.layer.cornerRadius = 8
        confirmButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        confirmButton.addTarget(self, action: #selector(onConfirmTapped), for: .touchUpInside)
        contentStack.addArrangedSubview(confirmButton)
        
        // cancel button
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.systemBlue.cgColor
        cancelButton.layer.cornerRadius = 8
        cancelButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        cancelButton.addTarget(self, action: #selector(onCancelTapped), for: .touchUpInside)
        contentStack.addArrangedSubview(cancelButton)
        
        // Layout
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backView.topAnchor.constraint(equalTo: topAnchor),
            backView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            contentStack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            contentStack.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            contentStack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -20),
        ])
        
        // Swipe down to dismiss
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Config
    
    func setup(_ model: MiddleModalModel) {
        titleLabel.text = model.modalTitle
        titleLabel.isHidden = model.modalTitle.isEmpty
        
        subtitleLabel.text = model.modalSubtitle
        subtitleLabel.isHidden = model.modalSubtitle.isEmpty
        
        confirmButton.setTitle(model.primaryText, for: .normal)
        confirmButton.isHidden = model.primaryText.isEmpty
        
        cancelButton.setTitle(model.secondaryText, for: .normal)
        cancelButton.isHidden = model.secondaryText.isEmpty
        
        icon.image = model.modalType.getImage()
        icon.isHidden = icon.image == nil
    }
    
    // MARK: - Height
    
    func getHeight() -> CGFloat {
        setNeedsLayout()
        layoutIfNeeded()
        
        // Let Auto Layout compute real height
        let targetSize = CGSize(width: Helpers.screenWidth, height: .greatestFiniteMagnitude)
        let fittingSize = backView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        let totalHeight = fittingSize.height
        let maxHeight = Helpers.screenHeight * 0.9
        return min(totalHeight, maxHeight)
    }
    
    // MARK: - Actions
    
    @objc private func handleSwipeDown() {
        if model.dismissable { dismiss() }
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.y = Helpers.screenHeight
        }, completion: { _ in
            self.superview?.removeFromSuperview()
        })
    }
    
    public static func dismiss(animated: Bool = true) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            // Find the MiddleModalView (backdrop) and remove it with animation
            for subview in keyWindow.subviews {
                if let backdrop = subview as? MiddleModalView {
                    // find the first MiddleModal inside the backdrop
                    for v in backdrop.subviews {
                        if let modal = v as? MiddleModal {
                            let animations = {
                                modal.frame.origin.y = Helpers.screenHeight
                                backdrop.alpha = 0.0
                                backdrop.layoutIfNeeded()
                            }
                            let completion: (Bool) -> Void = { _ in
                                backdrop.removeFromSuperview()
                            }
                            if animated {
                                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: animations, completion: completion)
                            } else {
                                animations()
                                completion(true)
                            }
                            return
                        }
                    }
                }
            }
        }
    }
    
    @objc private func onConfirmTapped() {
        model.onConfirm()
        if model.dismissOnConfirm { dismiss() }
    }
    
    @objc private func onCancelTapped() {
        model.onCancel()
        dismiss()
    }
    
    // MARK: - Static Show
    
    public static func show(
        title: String = "",
        subtitle: String = "",
        type: ModalType = .caution,
        icon: UIImage = UIImage(),
        primaryText: String = "Okay",
        secondaryText: String = "",
        dismissable: Bool = true,
        dismissOnConfirm: Bool = true,
        onConfirm: @escaping () -> Void = {},
        onCancel: @escaping () -> Void = {}
    ) {
        let backDrop = MiddleModalView(frame: Helpers.screen)
        backDrop.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let modal = MiddleModal()
        modal.model = MiddleModalModel(
            modalTitle: title,
            modalSubtitle: subtitle,
            primaryText: primaryText,
            secondaryText: secondaryText,
            modalType: type,
            dismissable: dismissable,
            dismissOnConfirm: dismissOnConfirm,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
        modal.icon.image = type == .defaultModal ? icon : type.getImage()
        
        // Layout once to compute height
        modal.setNeedsLayout()
        modal.layoutIfNeeded()
        
        let modalHeight = modal.getHeight()
        modal.frame = CGRect(x: 0, y: Helpers.screenHeight, width: Helpers.screenWidth, height: modalHeight)
        
        backDrop.addSubview(modal)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(backDrop)
        }
        
        // Animate up
        let centerY = (Helpers.screenHeight - modalHeight) / 2
        UIView.animate(withDuration: 0.25) {
            modal.frame.origin.y = centerY
        }
    }
}

class MiddleModalView: UIView {}
