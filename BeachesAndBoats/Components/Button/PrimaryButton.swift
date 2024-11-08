//
//  PrimaryButton.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import UIKit

@IBDesignable public class PrimaryButton: UIButton {
    
    @IBInspectable public var identifier: String = "" {
        didSet {
            self.accessibilityIdentifier = identifier
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private func setUp() {
        layer.cornerRadius = 8.0
        clipsToBounds = true
        tintColor = .white
        
        // Set title color for normal state
//        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .disabled)
        
        // Update appearance based on initial enabled state
        updateAppearance()
    }
    
    // Override the isEnabled property to update the appearance
    public override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }
    
    // Update background color and title color based on the button's state
    private func updateAppearance() {
        if isEnabled {
            backgroundColor = UIColor.beachBlue
            setTitleColor(.white, for: .normal)
        } else {
            tintColor = .white
            backgroundColor = UIColor.background.lighter(by: 7)
            setTitleColor(.white, for: .disabled)
        }
    }
}
