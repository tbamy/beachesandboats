//
//  KeyboardType.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import Foundation
import UIKit

public class DigitField: InputField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        textField.keyboardType = .numberPad
    }
}

public class EmailField: InputField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        super.setup()
        textField.keyboardType = .emailAddress
    }
}
