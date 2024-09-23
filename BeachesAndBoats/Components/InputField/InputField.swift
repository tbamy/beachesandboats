//
//  InputField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit
public struct PickerItem {
    public var name, value: String
    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

@IBDesignable public class InputField: BaseXib {
    @IBOutlet weak var topRightStack: UIStackView!
    @IBOutlet weak public var topRightLabel: RegularLabel!
    @IBOutlet weak public var topRightIcon: UIImageView!
    @IBOutlet weak var title: RegularLabel!
    @IBOutlet weak var textArea: TextView!
    @IBOutlet weak public var textField: UITextField!
    @IBOutlet weak public var infoText: RegularLabel!
    @IBOutlet weak var counter: RegularLabel!
    @IBOutlet weak public var errorText: RegularLabel!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var infoStack: UIStackView!
    @IBOutlet weak var errorStack: UIStackView!
    @IBOutlet weak var textBlocker: UIView!
    @IBOutlet weak var pinIcon: UIImageView!
    @IBOutlet weak var topRightPrompt: UILabel!
    @IBOutlet weak var coverLabel: RegularLabel!
    @IBOutlet weak var styledLabel: RegularLabel!
    
    @IBInspectable public var numberOfCharacters: Int = 1000
    @IBInspectable public var identifier: String = "" { didSet {
        textField.accessibilityIdentifier = identifier
        textArea.accessibilityIdentifier = identifier
    } }
    
    public var onPromptTapped: () -> Void = {}
    public var onIconTapped: () -> Void = {}
    
    public var textChanged: (UITextField, NSRange, String) -> Void = { _, _, _ in }
    public var editingEnded: () -> Void = {}
    
    public var text: String {
        get { textField.text ?? "" }
        set {textField.text = newValue}
    }
    
    public var enabled: Bool = true {
        didSet {
            setup()
        }
    }
    
    public var noSpecialCharacters: Bool = false {
        didSet {
            setup()
        }
    }
    
    public var keyboardType: UIKeyboardType = .default {
        didSet { textField.keyboardType = keyboardType }
    }
    
    @IBInspectable public var secureTextEntry: Bool = false {
        didSet { textField.isSecureTextEntry = secureTextEntry }
    }
    
    @IBInspectable public var info: String = "" {
        didSet { updateInfo() }
    }
    
    @IBInspectable public var titleText: String = "" {
        didSet { setup() }
    }
    
    @IBInspectable public var error: String = "" {
        didSet { updateError() }
    }

    @IBInspectable public var placeHolder: String = "" {
        didSet {
            textArea.placeHolder = placeHolder
            textField.placeholder = placeHolder
            textField.attributedPlaceholder = NSAttributedString(string: placeHolder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.background])
        }
    }
    
    @IBInspectable public var topRightPromtText: String = "" {
        didSet {
            updatePrompt()
            setup()
        }
    }
    
    @IBInspectable public var icon: UIImage? {
        didSet{
            pinIcon.image = icon
            pinIcon.isHidden = false
            pinIcon.isUserInteractionEnabled = true
            let tapped = UITapGestureRecognizer(target: self, action: #selector(iconTapped))
            pinIcon.addGestureRecognizer(tapped)
            setup()
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
    
    override func getNibName() -> String? {
        "InputField"
    }
    
    func setup() {
        styledLabel.layer.masksToBounds = true
        styledLabel.layer.cornerRadius = 8
        backgroundColor = .clear
        title.superview?.isHidden = titleText.isEmpty
        //print(title.isHidden)
        title.text = titleText
        textArea.isHidden = true
        counter.isHidden = true
        infoText.text = info
        textField.delegate = self
        textField.borderStyle = .none
        textField.layer.borderColor = UIColor.background.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.textColor = enabled ? .titleGrey : .background
//        textField.font = Fonts.getFont(name: .Regular, 14)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.background]
        )
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.rightViewMode = .always
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.backgroundColor = .clear
        //textView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textField.isEnabled = enabled
        textArea.isEditable = enabled
        updateInfo()
        updateError()
        updateHeight()
    }
    
    public override func prepareForInterfaceBuilder() {
        textView.widthAnchor.constraint(equalToConstant: superview?.bounds.width ?? 100).isActive = true
        setNeedsLayout()
    }
    
//    func updateHeight() {
//        constraints.filter({$0.firstAnchor == heightAnchor }).forEach{ $0.isActive = false }
////        heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
////        constraints.filter({$0.firstAnchor == leadingAnchor }).forEach{ $0.isActive = false }
////        constraints.filter({$0.firstAnchor == trailingAnchor }).forEach{ $0.isActive = false }
////        textView.widthAnchor.constraint(equalToConstant: superview?.bounds.width ?? 150).isActive = true
//        //superview?.removeAllConstraints()
//        setNeedsDisplay()
//    }
    
    func updateError() {
        if error != "" {
            errorStack.isHidden = false
            errorText.text = error
            errorText.numberOfLines = 0
            textArea.layer.borderColor = UIColor.error.cgColor
            textField.layer.borderColor = UIColor.error.cgColor
        } else {
            textArea.layer.borderColor = UIColor.background.cgColor
            textField.layer.borderColor = UIColor.background.cgColor
            errorStack.isHidden = true
        }
    }
    
    func updateInfo() {
        if info != "" {
            infoText.text = info
            infoStack.isHidden = false
            infoText.isHidden = false
        } else {
            //infoText.isHidden = true
            infoStack.isHidden = counter.isHidden
        }
    }
    
    func updatePrompt() {
        if topRightPromtText != "" {
            topRightPrompt.text = topRightPromtText
            topRightPrompt.isHidden = false
            topRightPrompt.isUserInteractionEnabled = true
            let tapped = UITapGestureRecognizer(target: self, action: #selector(promptTapped))
            topRightPrompt.addGestureRecognizer(tapped)
        } else {
            topRightPrompt.isHidden = true
        }
    }
    
    @objc func promptTapped(){
        onPromptTapped()
    }
    
    @objc func iconTapped(){
        onIconTapped()
    }
    
    public func validate(rules: [Rule]) -> Bool {
        SingleValidator(field: self, rules: rules).validate()
    }
    
    public func validate<T: Comparable>(rules: [Rule], v1: T, v2: T) -> Bool {
        RelationalSingleValidator(field: self, rules: rules).validate(v1: v1, v2: v2)
    }
}

extension InputField: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        guard textField.layer.borderColor != UIColor.error.cgColor else { return }
        textField.layer.borderColor = UIColor.black.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.layer.borderColor != UIColor.error.cgColor else { return }
        textField.layer.borderColor = UIColor.background.cgColor
        editingEnded()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        error = ""
        if noSpecialCharacters {
            if string.containsSpecialCharacter {
                return false
            }
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        textChanged(textField, range, string)
        return updatedText.count <= numberOfCharacters
    }
}

enum Height {
    static var smallHeight: CGFloat { 48 }
    static var bigHeight: CGFloat { 116 }
    static var infoHeight: CGFloat { 32 }
}
