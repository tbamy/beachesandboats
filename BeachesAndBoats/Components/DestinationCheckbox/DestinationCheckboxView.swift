//
//  DestinationCheckboxView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class DestinationCheckboxView: BaseXib {

    @IBOutlet weak public var checkBox: CheckboxButton!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var moneyInput: BigMoneyInputField!
    @IBOutlet weak public var moneyStack: UIStackView!

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
        // Disable interaction on other parts of the cell
        titleLabel.isUserInteractionEnabled = false
        self.isUserInteractionEnabled = true // enable overall view touch handling
        moneyInput.textField.font = UIFont.systemFont(ofSize: 20, weight: .regular)

        titleLabel.text = model.title
        checkBox.isChecked = model.state
        moneyStack.isHidden = !checkBox.isChecked

        // Enable only the checkbox and money input field
        checkBox.isUserInteractionEnabled = false
        moneyInput.isUserInteractionEnabled = true

        // Handle checkbox state changes
        checkBox.stateChanged = { [weak self] state in
            guard let self = self else { return }
            self.model.state = state
            self.updateInputFieldVisibility()
        }

        // Handle money input changes
          moneyInput.amountChanged = { [weak self] in
              guard let self = self else { return }
              let enteredAmount = self.moneyInput.getDoubleValue() ?? 0
//              print("Money Input Value Changed: \(enteredAmount)")
              self.model.amount = enteredAmount
              self.model.onMoneyEntered(enteredAmount)
          }
          
          // Initial call to update model with current money input value
          model.onMoneyEntered(moneyInput.getDoubleValue() ?? 0)

        
    }

    func updateInputFieldVisibility() {
        // Toggle visibility of the money input field based on checkbox state
        moneyStack.isHidden = !model.state
        moneyInput.isUserInteractionEnabled = model.state
    }

}

struct DestinationCheckboxModel{
    public var title: String = ""
    public var state: Bool = false
    public var tapped: () -> Void = {}
    public var amount: Double = 0
    public var onMoneyEntered: (Double) -> Void = {_ in }
}
