//
//  UIView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

extension UIView {
    func fadeIn(duration: TimeInterval = 0.3, delay: TimeInterval = 0.0, completion: ((Bool) -> Void)? = nil) {
        self.alpha = 0.0
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func applyDarkEffect() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    func applyDark() {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        addSubview(blurEffectView)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func addDashedStroke(color: UIColor? = UIColor.background.lighter(by: 10), width: CGFloat = 2) {
        let borderLayer = CAShapeLayer()
        borderLayer.strokeColor = color?.cgColor
        borderLayer.lineDashPattern = [6,8]
        borderLayer.frame = bounds
        borderLayer.lineWidth = 2
        borderLayer.lineCap = .round
        borderLayer.fillColor = nil
        borderLayer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        layer.sublayers?.forEach {
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
        layer.addSublayer(borderLayer)
    }
    
    func removeConstraint(_ constraint: NSLayoutDimension) {
        constraints.filter({ $0.firstAnchor == constraint }).forEach{ $0.isActive = false }
    }
    
    func removeAllConstraints() {
        var constraintsToRemove = [NSLayoutConstraint]()
        for constraint in self.constraints {
            if let _ = constraint.firstItem as? UIView, constraint.secondItem == nil {
                // constraint is a layout constraint that only involves this view
                constraintsToRemove.append(constraint)
            } else if let superview = self.superview {
                // constraint involves this view and a sibling view or the superview
                for siblingView in superview.subviews {
                    if let _ = constraint.firstItem as? UIView, constraint.secondItem as? UIView == siblingView {
                        constraintsToRemove.append(constraint)
                    }
                }
            }
        }
        self.removeConstraints(constraintsToRemove)
    }
    
    func pinView(to parent: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
    }
    
    func addShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15  // Opacity of the shadow (0 to 1)
        view.layer.shadowOffset = CGSize(width: 0, height: 2)  // Offset of the shadow
        view.layer.shadowRadius = 4  // Blurriness of the shadow
        view.layer.masksToBounds = false  // Ensures the shadow goes outside the bounds of the view
    }

}
