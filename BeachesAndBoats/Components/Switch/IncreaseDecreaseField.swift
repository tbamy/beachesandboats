//
//  IncreaseDecreaseField.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/10/2024.
//

import UIKit

@IBDesignable public class IncreaseDecreaseField: BaseXib {
    
    let nibName = "IncreaseDecreaseField"
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var titleLabel: BoldLabel!
    @IBOutlet weak var subtitle: LightLabel!
    @IBOutlet weak var minusBtn: PrimaryButton!
    @IBOutlet weak var numberCount: InputField!
    @IBOutlet weak var plusBtn: PrimaryButton!
    
    
    public var minValue: Int = 0
    public var maxValue: Int = 100

//    public var onCountChanged: ((Int) -> Void)?
    public var onValueChange: ((IncreaseDecreaseModel) -> Void)?
    
    public var count: Int = 0 {
        didSet {
            updateCountLabel()
//            onCountChanged?(count)
        }
    }
    
    public var model: IncreaseDecreaseModel? {
        didSet {
            setupData()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func getNibName() -> String? {
        return nibName
    }
    
    func setupData() {
        titleLabel.text = model?.type
        subtitle.text = model?.subtitle
        count = model?.count ?? 0
        updateCountLabel()
        plusBtn.backgroundColor = UIColor.beachBlue
        if count == 0{
            minusBtn.backgroundColor = UIColor.beachBlue.lighter(by: 5)
            minusBtn.isEnabled = false
        }else{
            minusBtn.isEnabled = true
            minusBtn.backgroundColor = UIColor.beachBlue
        }
    }
    
    func setup() {
        minusBtn.cornerRadius = minusBtn.frame.width / 2
        plusBtn.cornerRadius = plusBtn.frame.width / 2
//        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .clear
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor.background.cgColor
        contentView.isUserInteractionEnabled = true
        
        numberCount.centerTextInTextField()
//        numberCount.isUserInteractionEnabled = false
        numberCount.layer.borderColor = .none
        numberCount.textField.keyboardType = .numberPad
        numberCount.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
            
        minusBtn.addTarget(self, action: #selector(decreaseCount), for: .touchUpInside)
        plusBtn.addTarget(self, action: #selector(increaseCount), for: .touchUpInside)
        
        updateCountLabel()
    }
    
    func updateCountLabel() {
        numberCount.text = "\(count)"
    }
    
    @objc func decreaseCount() {
        if count > minValue {
            count -= 1
            model?.count = count
            updateCountLabel()
            if let model = model {
                onValueChange?(model) // Trigger the closure
            }
                            
//            print("DecreaseCount: \(model?.type ?? "") count: \(count)")
        }
    }
    
    @objc func increaseCount() {
        if count < maxValue {
            count += 1
            model?.count = count
            updateCountLabel()
            if let model = model {
                onValueChange?(model) // Trigger the closure
            }
//            print("IncreaseCount: \(model?.type ?? "") count: \(count)")
        }
    }
    
    @objc func textFieldDidChange() {
        guard let newCount = Int(numberCount.text) else {
            updateCountLabel()
            return
        }
        
        // Clamp the value within min/max bounds
        let clampedCount = max(minValue, min(maxValue, newCount))
        
        if clampedCount != count {
            count = clampedCount
            model?.count = count
            
            // Update display if value was clamped
            if clampedCount != newCount {
                updateCountLabel()
            }
            
            // Trigger the closure
            if let model = model {
                onValueChange?(model)
            }
        }
    }
}

extension InputField {
    func centerTextInTextField() {
        textField.textAlignment = .center
    }
}

public struct IncreaseDecreaseModel {
    public var id: String
    public var type: String
    public var subtitle: String
    public var count: Int
    
    public init(id: String, type: String, subtitle: String, count: Int) {
        self.id = id
        self.type = type
        self.subtitle = subtitle
        self.count = count
    }
}
