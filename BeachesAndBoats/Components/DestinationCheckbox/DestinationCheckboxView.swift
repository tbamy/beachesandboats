//
//  DestinationCheckboxView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class DestinationCheckboxView: BaseXib {

    @IBOutlet weak var checkBox: SelectableCheckbox!
    @IBOutlet weak var moneyInput: BigMoneyInputField!
    @IBOutlet weak var moneyStack: UIStackView!

    public var model: DestinationCheckboxModel = DestinationCheckboxModel() {
        didSet {
            setup()
        }
    }
    
    @IBInspectable public var identifier: String = "" { didSet {
        self.accessibilityIdentifier = identifier
    } }

    @IBInspectable var titleText: String = "" {
        didSet { model.title = titleText }
    }

    @IBInspectable var state: Bool = false {
        didSet { model.state = state }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    public override func awakeFromNib() {
        updateHeight()
    }

    func setup() {
        checkBox.model.title = model.title
        checkBox.model.state = model.state
        moneyStack.isHidden = !checkBox.model.state

        // Setup checkbox state change handling
        checkBox.model.tapped = { [weak self] in
            guard let self = self else { return }
            self.model.state = !self.model.state
            self.setState()
        }

        // Save the entered money when user types in the money input
        moneyInput.onTextChanged = { [weak self] enteredText in
            self?.model.onMoneyEntered(Int(enteredText) ?? 0)
        }
    }

    func setState() {
        if model.state {
            moneyStack.isHidden = false
            moneyInput.isUserInteractionEnabled = true
            checkBox.state = true
        } else {
            moneyStack.isHidden = true
            checkBox.state = false
        }
    }

}

struct DestinationCheckboxModel{
    public var title: String = ""
    public var state: Bool = false
    public var tapped: () -> Void = {}
    public var onMoneyEntered: (Int) -> Void = {_ in }
}
