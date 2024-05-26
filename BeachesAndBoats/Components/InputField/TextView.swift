//
//  TextView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 18/05/2024.
//

import UIKit

class TextView : UITextView, UITextViewDelegate {
    @IBInspectable public var placeHolder: String = "" {
        didSet {
            text = placeHolder
            hasPlaceHolder = true
            setup()
        }
    }
    
    @IBInspectable public var max: Int = 100
    
    var hasPlaceHolder: Bool = false
    
    override func awakeFromNib() {
        setup()
    }
    
    func setup() {
        delegate = self
        if hasPlaceHolder {
            textColor = .background
        } else {
            textColor = .titleGrey
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if text == placeHolder, hasPlaceHolder {
            text = ""
            textColor = .titleGrey
        }
        guard layer.borderColor != UIColor.error.cgColor else { return  }
        layer.borderColor = UIColor.black.cgColor
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if text.count == 0, hasPlaceHolder {
            text = placeHolder
            textColor = .background
        } else {
            textColor = .titleGrey
        }
        guard layer.borderColor != UIColor.error.cgColor else { return  }
        layer.borderColor = UIColor.background.cgColor
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Get the current text and calculate the new text after adding the replacement text
        guard let currentText = textView.text else { return true }
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= max
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let isFont = self.font else { return superRect }
        superRect.size.height = isFont.pointSize - isFont.descender
        return superRect
    }
}
