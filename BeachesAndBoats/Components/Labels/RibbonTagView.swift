//
//  RibbonTagView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/07/2025.
//

//import UIKit
//
//public class RibbonTagView: UIView {
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//
//    private func setupView() {
//        // Rounded left corners
////        self.layer.cornerRadius = 12
//        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
//        self.clipsToBounds = true
//
//    }
//
//    public override func layoutSubviews() {
//        super.layoutSubviews()
//        applyGradient()
//        addRightArrowMask()
//    }
//
//    public func applyGradient(color1: UIColor = UIColor(red: 1, green: 0.64, blue: 0, alpha: 1), color2: UIColor = UIColor(red: 0.89, green: 0.2, blue: 0, alpha: 1)) {
//        // Remove old gradient if any
//        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
//
//        let gradient = CAGradientLayer()
//        gradient.colors = [
//            color1.cgColor,
//            color2.cgColor
//        ]
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint = CGPoint(x: 1, y: 0.5)
//        gradient.frame = bounds
//        layer.insertSublayer(gradient, at: 0)
//    }
//
//    private func addRightArrowMask() {
//        let path = UIBezierPath()
//        let h = bounds.height
//        let w = bounds.width
//        let notchWidth: CGFloat = 10
//
//        // Start from top-left
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: w, y: 0))
//        path.addLine(to: CGPoint(x: w - notchWidth, y: h / 2))
//        path.addLine(to: CGPoint(x: w, y: h))
//        path.addLine(to: CGPoint(x: 0, y: h))
//        path.close()
//
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//
//}


import UIKit

public class RibbonTagView: UIView {

    private var gradientColor1: UIColor = UIColor(red: 1, green: 0.64, blue: 0, alpha: 1)
    private var gradientColor2: UIColor = UIColor(red: 0.89, green: 0.2, blue: 0, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        self.clipsToBounds = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(color1: gradientColor1, color2: gradientColor2)
        addRightArrowMask()
    }

    public func applyGradient(color1: UIColor, color2: UIColor) {
        // Save the colors for future layout updates
        self.gradientColor1 = color1
        self.gradientColor2 = color2

        // Remove old gradient layers
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }

        let gradient = CAGradientLayer()
        gradient.colors = [
            color1.cgColor,
            color2.cgColor
        ]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }

    private func addRightArrowMask() {
        let path = UIBezierPath()
        let h = bounds.height
        let w = bounds.width
        let notchWidth: CGFloat = 10

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: w, y: 0))
        path.addLine(to: CGPoint(x: w - notchWidth, y: h / 2))
        path.addLine(to: CGPoint(x: w, y: h))
        path.addLine(to: CGPoint(x: 0, y: h))
        path.close()

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
