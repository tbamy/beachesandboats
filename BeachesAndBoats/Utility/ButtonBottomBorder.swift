//
//  ButtonBottomBorder.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 18/05/2024.
//

import Foundation
import UIKit

class ButtonBottomBorder {
    static let shared = ButtonBottomBorder()
    
    private init(){}
    
    func addBottomBorder(to button: UIButton) {
        // Remove existing borders
        removeBottomBorder(from: button)
        
        // Create a new bottom border
        let bottomBorder = UIView()
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.backgroundColor = UIColor.B_B
        button.addSubview(bottomBorder)
        
        NSLayoutConstraint.activate([
            bottomBorder.heightAnchor.constraint(equalToConstant: 2),
            bottomBorder.leftAnchor.constraint(equalTo: button.leftAnchor, constant: 40),
            bottomBorder.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            bottomBorder.widthAnchor.constraint(equalToConstant: 90)
        ])
        bottomBorder.tag = 999
    }
    
    func removeBottomBorder(from button: UIButton) {
        // Remove existing bottom borders
        for view in button.subviews {
            if view.tag == 999 {
                view.removeFromSuperview()
            }
        }
    }
}
