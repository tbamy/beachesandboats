//
//  GestureRecognizerHelper.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 04/01/2025.
//

import Foundation
import UIKit

class GestureRecognizerHelper {
    
    static func addTapGesture(to view: UIStackView, target: Any, action: Selector) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGestureRecognizer)
    }
}
