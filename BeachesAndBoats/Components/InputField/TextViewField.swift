//
//  TextViewField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

@IBDesignable public class TextViewField: InputField, NSTextStorageDelegate {
    
    override public var text: String {
        get {
            if textArea.text == placeHolder {
                return ""
            }
            return textArea.text ?? ""
        }
        set {textArea.text = newValue}
    }
    
    @IBInspectable public var isCounterVisible: Bool = false {
        didSet {
            updateCounterVisibility()
        }
    }
            
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setup() {
        super.setup()
        setupTextArea()
    }
    
    func setupTextArea() {
        textArea.textStorage.delegate = self
        textArea.layoutManager.delegate = self
        textArea.layer.borderColor = UIColor.background.cgColor
        textArea.layer.borderWidth = 1
        textArea.layer.cornerRadius = 8
        textArea.textColor = .titleGrey
//        textArea.font = Fonts.getFont(name: .Regular, 14)
        textArea.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        infoStack.isHidden = false
        counter.isHidden = false
        textArea.isHidden = false
        textView.isHidden = true
        textArea.backgroundColor = .clear
        textArea.heightAnchor.constraint(equalToConstant: 200).isActive = true
        updateHeight()
        updateCounterVisibility()
    }
    
    func updateCounterVisibility() {
        counter.isHidden = !isCounterVisible
    }
            

    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        error = ""
        let count = textStorage.string == placeHolder ? 0 : textStorage.string.count
        counter.text = "\(count)/\(numberOfCharacters)"
    }
}

extension TextViewField: NSLayoutManagerDelegate {
    public func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        12
    }
}

