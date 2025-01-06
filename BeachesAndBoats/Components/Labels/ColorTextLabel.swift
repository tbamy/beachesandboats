//
//  ColorTextLabel.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import Foundation
import UIKit

@IBDesignable
class ColorTextLabel: UILabel {
    
    // Inspectable properties for the label text and color
    @IBInspectable var labelText: String? {
        didSet {
            updateText()
        }
    }
    
    @IBInspectable var textToColor: String? {
        didSet {
            updateText()
        }
    }
    
    @IBInspectable var colorForText: UIColor = UIColor.red {
        didSet {
            updateText()
        }
    }
    
    // Inspectable property for clickable text
    @IBInspectable var isClickable: Bool = false {
        didSet {
            setupGestureRecognizer()
        }
    }
    
    // Closure to handle the click event on the text range
    var onTextClicked: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGestureRecognizer()
    }
    
    // Updates the attributed text and applies color to the specified substring
    private func updateText() {
        guard let fullText = labelText else {
            self.attributedText = nil
            return
        }
        
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // Ensure the textToColor is valid
        if let textToColor = textToColor, let range = fullText.range(of: textToColor) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.foregroundColor, value: colorForText, range: nsRange)
        }
        
        self.attributedText = attributedString
    }
    
    // Set up the gesture recognizer to detect taps on the label
    private func setupGestureRecognizer() {
        self.isUserInteractionEnabled = isClickable
        
        if isClickable {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            self.addGestureRecognizer(tapGesture)
        }
    }
    
    // Handle tap gesture and detect if it was on the specified text range
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let attributedText = self.attributedText, let textToColor = textToColor else { return }
        
        // Get the location of the tap in the label
        let tapLocation = gesture.location(in: self)
        
        // Get the index of the character that was tapped
        if let index = characterIndexAt(location: tapLocation) {
            if let fullText = self.text, let range = fullText.range(of: textToColor) {
                let nsRange = NSRange(range, in: fullText)
                
                // Check if the tap is within the specified range
                if NSLocationInRange(index, nsRange) {
                    onTextClicked?() // Call the closure when text is tapped
                }
            }
        }
    }
    
    // Utility to get the index of the character at the tap location
    private func characterIndexAt(location: CGPoint) -> Int? {
        guard let attributedText = self.attributedText else { return nil }
        
        // Create a text storage with the label's attributed text
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        
        // Set up a text container with the label's size and properties
        let textContainer = NSTextContainer(size: self.bounds.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)
        
        // Get the index of the tapped character
        let glyphIndex = layoutManager.glyphIndex(for: location, in: textContainer)
        return layoutManager.characterIndexForGlyph(at: glyphIndex)
    }
    
    // Override text property to keep things in sync
    override var text: String? {
        didSet {
            labelText = text
        }
    }
}

