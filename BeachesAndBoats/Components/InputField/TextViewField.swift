//
//  TextViewField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

@IBDesignable public class TextViewField: InputField, NSTextStorageDelegate, UITextViewDelegate {

    override public var text: String {
        get {
            // Return empty string only if text is placeholder and in placeholder style
            return textArea.text == placeHolder && textArea.textColor == .background ? "" : textArea.text ?? ""
        }
        set {
            let truncatedText = String(newValue.prefix(numberOfCharacters))
            textArea.textStorage.beginEditing()
            textArea.text = truncatedText.isEmpty ? placeHolder : truncatedText
            textArea.textColor = truncatedText.isEmpty ? .background : .titleGrey
            textArea.textStorage.endEditing()
            updateCounterAndError()
            onTextChanged?(truncatedText)
            print("TextViewField: text setter, value: \(truncatedText.prefix(50)), color: \(textArea.textColor?.description ?? "nil")")
        }
    }

    @IBInspectable public var isCounterVisible: Bool = false {
        didSet {
            updateCounterVisibility()
        }
    }
            
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        textArea.delegate = self
        print("TextViewField: awakeFromNib, delegate: \(textArea.delegate)")
    }
    
    override func setup() {
        super.setup()
        setupTextArea()
    }
    
    func setupTextArea() {
        textArea.textStorage.delegate = self
        textArea.layoutManager.delegate = self
        textArea.delegate = self
        textArea.layer.borderColor = UIColor.background.cgColor
        textArea.layer.borderWidth = 1
        textArea.layer.cornerRadius = 8
        textArea.textColor = textArea.text == placeHolder ? .background : .titleGrey
        textArea.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        infoStack.isHidden = false
        counter.isHidden = !isCounterVisible
        textArea.isHidden = false
        textView.isHidden = true
        textArea.backgroundColor = .clear
        textArea.heightAnchor.constraint(equalToConstant: 200).isActive = true
        updateHeight()
        updateCounterVisibility()
        updateCounterAndError()
        
        print("TextViewField: setupTextArea, delegate: \(textArea.delegate), text: \(textArea.text?.prefix(50) ?? "nil"), color: \(textArea.textColor?.description ?? "nil")")
    }
    
    func updateCounterVisibility() {
        counter.isHidden = !isCounterVisible
        updateCounterAndError()
    }
    
    func updateCounterAndError() {
        let currentText = textArea.text == placeHolder && textArea.textColor == .background ? "" : textArea.text ?? ""
        let count = currentText.count
        counter.text = "\(count)/\(numberOfCharacters)"
        if count > numberOfCharacters {
            error = "Character limit of \(numberOfCharacters) exceeded"
            textArea.layer.borderColor = UIColor.error.cgColor
        } else {
            error = ""
            textArea.layer.borderColor = UIColor.background.cgColor
        }
        print("TextViewField: updateCounterAndError, count: \(count), limit: \(numberOfCharacters), text: \(currentText.prefix(50)), color: \(textArea.textColor?.description ?? "nil")")
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        // Avoid direct text modification here; rely on shouldChangeTextIn
        updateCounterAndError()
        let currentText = textView.text == placeHolder && textView.textColor == .background ? "" : textView.text ?? ""
        onTextChanged?(currentText)
        print("TextViewField: textViewDidChange, count: \(currentText.count), text: \(currentText.prefix(50)), color: \(textView.textColor?.description ?? "nil")")
    }
    
    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        updateCounterAndError()
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            print("TextViewField: Invalid range in shouldChangeTextIn")
            return false
        }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        let effectiveText = updatedText == placeHolder && textView.textColor == .background ? "" : updatedText
        
        print("TextViewField: shouldChangeTextIn, current: \(currentText.count), replacement: \(text.count), updated: \(effectiveText.count), color: \(textView.textColor?.description ?? "nil")")
        
        if effectiveText.count > numberOfCharacters {
            print("TextViewField: Character limit exceeded, rejecting change")
            updateCounterAndError()
            return false
        }
        
        if noSpecialCharacters && text.containsSpecialCharacter {
            print("TextViewField: Special characters not allowed")
            return false
        }
        
        error = ""
        textView.textColor = effectiveText.isEmpty ? .background : .titleGrey
        textArea.layer.borderColor = UIColor.background.cgColor
        onTextChanged?(effectiveText)
        print("TextViewField: shouldChangeTextIn, allowing change, updated text: \(effectiveText.prefix(50))")
        return true
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeHolder && textView.textColor == .background {
            textView.text = ""
            textView.textColor = .titleGrey
        }
        if textView.layer.borderColor != UIColor.error.cgColor {
            textView.layer.borderColor = UIColor.beachBlue.cgColor
        }
        print("TextViewField: textViewDidBeginEditing, text: \(textView.text?.prefix(50) ?? "nil"), color: \(textView.textColor?.description ?? "nil")")
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeHolder
            textView.textColor = .background
        }
        if textView.layer.borderColor != UIColor.error.cgColor {
            textView.layer.borderColor = UIColor.background.cgColor
        }
        editingEnded()
        onTextChanged?(text)
        print("TextViewField: textViewDidEndEditing, text: \(textView.text?.prefix(50) ?? "nil"), color: \(textView.textColor?.description ?? "nil")")
    }
    
    public override func paste(_ sender: Any?) {
        if let pastedText = UIPasteboard.general.string {
            let truncatedText = String(pastedText.prefix(numberOfCharacters))
            textArea.textStorage.beginEditing()
            textArea.text = truncatedText.isEmpty ? placeHolder : truncatedText
            textArea.textColor = truncatedText.isEmpty ? .background : .titleGrey
            textArea.textStorage.endEditing()
            updateCounterAndError()
            onTextChanged?(truncatedText)
            print("TextViewField: paste, truncated to \(truncatedText.count) characters, text: \(truncatedText.prefix(50))")
        }
    }
}

extension TextViewField: NSLayoutManagerDelegate {
    public func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        12
    }
}


//import UIKit
//
//@IBDesignable public class TextViewField: InputField, NSTextStorageDelegate, UITextViewDelegate {
//
//    override public var text: String {
//        get {
//            // Return empty string only if textArea.text is exactly the placeholder and no user input
//            return textArea.text == placeHolder && textArea.textColor == .background ? "" : textArea.text ?? ""
//        }
//        set {
//            let truncatedText = String(newValue.prefix(numberOfCharacters))
//            textArea.textStorage.beginEditing()
//            textArea.text = truncatedText.isEmpty ? placeHolder : truncatedText
//            textArea.textColor = truncatedText.isEmpty ? .background : .titleGrey
//            textArea.textStorage.endEditing()
//            updateCounterAndError()
//            onTextChanged?(truncatedText)
//            print("TextViewField: text setter called, new value: \(truncatedText)")
//        }
//    }
//
//    @IBInspectable public var isCounterVisible: Bool = false {
//        didSet {
//            updateCounterVisibility()
//        }
//    }
//            
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setup()
//    }
//    
//    public override func awakeFromNib() {
//        super.awakeFromNib()
//        textArea.delegate = self
//        print("TextViewField: awakeFromNib, delegate set to \(textArea.delegate)")
//    }
//    
//    override func setup() {
//        super.setup()
//        setupTextArea()
//    }
//    
//    func setupTextArea() {
//        textArea.textStorage.delegate = self
//        textArea.layoutManager.delegate = self
//        textArea.delegate = self
//        textArea.layer.borderColor = UIColor.background.cgColor
//        textArea.layer.borderWidth = 1
//        textArea.layer.cornerRadius = 8
//        textArea.textColor = .titleGrey
//        textArea.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
//        
//        infoStack.isHidden = false
//        counter.isHidden = !isCounterVisible
//        textArea.isHidden = false
//        textView.isHidden = true
//        textArea.backgroundColor = .clear
//        textArea.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        updateHeight()
//        updateCounterVisibility()
//        updateCounterAndError()
//        
//        print("TextViewField: setupTextArea, delegate set to \(textArea.delegate)")
//    }
//    
//    func updateCounterVisibility() {
//        counter.isHidden = !isCounterVisible
//        updateCounterAndError()
//    }
//    
//    func updateCounterAndError() {
//        let currentText = textArea.text == placeHolder && textArea.textColor == .background ? "" : textArea.text ?? ""
//        let count = currentText.count
//        counter.text = "\(count)/\(numberOfCharacters)"
//        if count > numberOfCharacters {
//            error = "Character limit of \(numberOfCharacters) exceeded"
//            textArea.layer.borderColor = UIColor.error.cgColor
//            textArea.textStorage.beginEditing()
//            textArea.text = String(currentText.prefix(numberOfCharacters))
//            textArea.textStorage.endEditing()
//        } else {
//            error = ""
//            textArea.layer.borderColor = UIColor.background.cgColor
//        }
//        print("TextViewField: updateCounterAndError, count: \(count), limit: \(numberOfCharacters), text: \(currentText.prefix(50))")
//    }
//    
//    public func textViewDidChange(_ textView: UITextView) {
//        let currentText = textView.text == placeHolder && textView.textColor == .background ? "" : textView.text ?? ""
//        if currentText.count > numberOfCharacters {
//            textArea.textStorage.beginEditing()
//            let truncatedText = String(currentText.prefix(numberOfCharacters))
//            textView.text = truncatedText.isEmpty ? placeHolder : truncatedText
//            textView.textColor = truncatedText.isEmpty ? .background : .titleGrey
//            textArea.textStorage.endEditing()
//        }
//        updateCounterAndError()
//        onTextChanged?(currentText)
//        print("TextViewField: textViewDidChange, final count: \(currentText.count), text: \(currentText.prefix(50))")
//    }
//    
//    public func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
//        updateCounterAndError()
//    }
//    
//    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let currentText = textView.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else {
//            print("TextViewField: Invalid range in shouldChangeTextIn")
//            return false
//        }
//        
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//        let effectiveText = updatedText == placeHolder && textView.textColor == .background ? "" : updatedText
//        
//        print("TextViewField: shouldChangeTextIn, current: \(currentText.count), replacement: \(text.count), updated: \(effectiveText.count)")
//        
//        if effectiveText.count > numberOfCharacters {
//            print("TextViewField: Character limit exceeded, rejecting change")
//            updateCounterAndError()
//            return false
//        }
//        
//        if noSpecialCharacters && text.containsSpecialCharacter {
//            print("TextViewField: Special characters not allowed")
//            return false
//        }
//        
//        error = ""
//        textArea.layer.borderColor = UIColor.background.cgColor
//        textView.textColor = .titleGrey // Ensure user text uses titleGrey
//        onTextChanged?(effectiveText)
//        print("TextViewField: shouldChangeTextIn, allowing change, updated text: \(effectiveText.prefix(50))")
//        return true
//    }
//    
//    public func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == placeHolder && textView.textColor == .background {
//            textView.text = ""
//            textView.textColor = .titleGrey
//        }
//        if textView.layer.borderColor != UIColor.error.cgColor {
//            textView.layer.borderColor = UIColor.beachBlue.cgColor
//        }
//    }
//    
//    public func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = placeHolder
//            textView.textColor = .background
//        }
//        if textView.layer.borderColor != UIColor.error.cgColor {
//            textView.layer.borderColor = UIColor.background.cgColor
//        }
//        editingEnded()
//        onTextChanged?(text)
//    }
//    
//    public override func paste(_ sender: Any?) {
//        textArea.textStorage.beginEditing()
//        if let pastedText = UIPasteboard.general.string {
//            let truncatedText = String(pastedText.prefix(numberOfCharacters))
//            textArea.text = truncatedText.isEmpty ? placeHolder : truncatedText
//            textArea.textColor = truncatedText.isEmpty ? .background : .titleGrey
//            print("TextViewField: Pasted text truncated to \(truncatedText.count) characters")
//        }
//        textArea.textStorage.endEditing()
//        updateCounterAndError()
//        onTextChanged?(text)
//    }
//}
//
//extension TextViewField: NSLayoutManagerDelegate {
//    public func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
//        12
//    }
//}
