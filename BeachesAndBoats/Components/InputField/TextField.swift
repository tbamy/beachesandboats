//
//  TextField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class TextField: UITextField {
    let error = UILabel()
    let info = UILabel()
    var mainStack = UIStackView()
    override func awakeFromNib() {
        setup()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        return bounds.inset(by: insets)
    }
    
    func setup() {
        // Set the background color
        backgroundColor = UIColor.lightGray
        
        // Set the layer properties
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor
        clipsToBounds = false
        error.text = "error"
        info.text = "info"
        error.sizeToFit()
        info.sizeToFit()
        
        let errorImage = UIImageView(image: Assets.error_icon.image)
        errorImage.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        let errostack = UIStackView(arrangedSubviews: [errorImage, error])
        errostack.spacing = 5
        errostack.axis = .horizontal
        
        mainStack = UIStackView(arrangedSubviews: [info, errostack])
        mainStack.axis = .vertical
        mainStack.spacing = 5
        
        addSubview(error)

        
    }
}

class CustomTextField: UITextField {

    let errorLabel = UILabel()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    private func commonInit() {
        // Set the background color
        backgroundColor = UIColor.lightGray

        // Set the layer properties
        layer.cornerRadius = 10.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor

        // Set up the error label
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = font
        errorLabel.textColor = UIColor.red
        errorLabel.isHidden = true
        addSubview(errorLabel)
        showError(message: "hello")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: errorLabel.bounds.height + 5, right: 0)
        return bounds.inset(by: insets)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: errorLabel.bounds.height + 5, right: 0)
        return bounds.inset(by: insets)
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: 200)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }
    
    func showError(message: String) {
        errorLabel.text = message
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = false

        // Calculate the size of the error label
        let labelSize = errorLabel.sizeThatFits(CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude))

        // Update the constraints for the error label
        NSLayoutConstraint.activate([
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            errorLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 5),
            errorLabel.heightAnchor.constraint(equalToConstant: labelSize.height)
        ])

        // Update the text field's height to include the error label
        let newHeight = bounds.height + labelSize.height + 10
        bounds.size.height = newHeight
    }

    func hideError() {
        errorLabel.isHidden = true

        // Reset the text field's height
        bounds.size.height -= errorLabel.bounds.height + 10
    }
}
