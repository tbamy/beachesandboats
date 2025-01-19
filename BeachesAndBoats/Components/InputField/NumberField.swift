//
//  NumberField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 09/10/2024.
//

import Foundation
import UIKit

class NumberField: InputField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        textField.isUserInteractionEnabled = true
        setRightImage()
    }
    
//    func setRightImage() {
//        textField.text = "0"
//        
//        // Create the container view for the stack
//        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 25)) // Adjust the height and width for better visibility
//
//        // Create the stack view to hold the images
//        let stackView = UIStackView(frame: iconContainer.bounds)
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.alignment = .center
//        stackView.spacing = 4 // Add spacing between images
//        
//        // Create the chevron.up image view
//        let upImageView = UIImageView()
//        upImageView.image = UIImage(systemName: "chevron.up")
//        upImageView.tintColor = .label // Use `.label` for adaptive coloring
//        upImageView.contentMode = .scaleAspectFit
//        upImageView.isUserInteractionEnabled = true
//        let upTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementValue))
//        upImageView.addGestureRecognizer(upTapGesture)
//
//        // Create the chevron.down image view
//        let downImageView = UIImageView()
//        downImageView.image = UIImage(systemName: "chevron.down")
//        downImageView.tintColor = .label
//        downImageView.contentMode = .scaleAspectFit
//        downImageView.isUserInteractionEnabled = true
//        let downTapGesture = UITapGestureRecognizer(target: self, action: #selector(decrementValue))
//        downImageView.addGestureRecognizer(downTapGesture)
//
//        // Add the image views to the stack view
//        stackView.addArrangedSubview(upImageView)
//        stackView.addArrangedSubview(downImageView)
//        
//        // Add the stack view to the container
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        iconContainer.addSubview(stackView)
//        
//        // Constraints for the stack view to fill the container
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: iconContainer.topAnchor),
//            stackView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor),
//            stackView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
//            stackView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor)
//        ])
//        
//        // Set the icon container as the right view of the text field
//        textField.rightViewMode = .always
//        textField.rightView = iconContainer
//    }
//
//
//    // Action to increment the value in the text field
//    @objc func incrementValue() {
//        if let currentText = textField.text, let currentValue = Int(currentText) {
//            textField.text = "\(currentValue + 1)"
//        } else {
//            textField.text = "1"
//        }
//    }
//
//    // Action to decrement the value in the text field
//    @objc func decrementValue() {
//        if let currentText = textField.text, let currentValue = Int(currentText), currentValue > 0 {
//            textField.text = "\(currentValue - 1)"
//        } else {
//            textField.text = "0"
//        }
//    }
    
    func setRightImage() {
        textField.text = "0"
        
        // Create the container view for the stack
        let iconContainer = UIView(frame: CGRect(x: 5, y: 5, width: 15, height: 15))
        
        // Create the stack view to hold the images
        let stackView = UIStackView(frame: iconContainer.bounds)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 4 // Add spacing between images
        
        // Create the chevron.up image view
        let upImageView = UIImageView()
        upImageView.image = UIImage(systemName: "chevron.up")
        upImageView.tintColor = .label
        upImageView.contentMode = .scaleAspectFit
        upImageView.isUserInteractionEnabled = true // Enable user interaction
        let upTapGesture = UITapGestureRecognizer(target: self, action: #selector(incrementValue))
        upImageView.addGestureRecognizer(upTapGesture)

        // Create the chevron.down image view
        let downImageView = UIImageView()
        downImageView.image = UIImage(systemName: "chevron.down")
        downImageView.tintColor = .label
        downImageView.contentMode = .scaleAspectFit
        downImageView.isUserInteractionEnabled = true // Enable user interaction
        let downTapGesture = UITapGestureRecognizer(target: self, action: #selector(decrementValue))
        downImageView.addGestureRecognizer(downTapGesture)

        // Add the image views to the stack view
        stackView.addArrangedSubview(upImageView)
        stackView.addArrangedSubview(downImageView)
        
        // Add the stack view to the container
        stackView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(stackView)
        
        // Constraints for the stack view to fill the container
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: iconContainer.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: iconContainer.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: iconContainer.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: iconContainer.trailingAnchor)
        ])
        
        // Set the icon container as the right view of the text field
        textField.rightViewMode = .always
        textField.rightView = iconContainer
    }

    @objc func incrementValue() {
        if let currentText = textField.text, let currentValue = Int(currentText) {
            textField.text = "\(currentValue + 1)"
        } else {
            textField.text = "1"
        }
    }

    @objc func decrementValue() {
        if let currentText = textField.text, let currentValue = Int(currentText), currentValue > 0 {
            textField.text = "\(currentValue - 1)"
        } else {
            textField.text = "0"
        }
    }


}

