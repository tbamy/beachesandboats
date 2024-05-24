//
//  ViewlTopCornerRadius.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 14/05/2024.
//

import Foundation
import UIKit

class ViewlTopCornerRadius {
    static let shared = ViewlTopCornerRadius()
    
    private init() {}
    
    func applyTopBorderRadius(to view: UIView, radius: CGFloat) {
            let path = UIBezierPath(
                roundedRect: view.bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: radius, height: radius)
            )
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            view.layer.mask = maskLayer
        }

}
