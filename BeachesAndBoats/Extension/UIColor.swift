//
//  UIColor.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import UIKit
private class LocalColor {}

extension UIColor {
    public static let beachBlue = UIColor(named: "B&B", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
    public static let alatRedLight = UIColor(named: "AlatRedLight", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
    public static let alatPurple = UIColor(named: "AlatPurple", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let background = UIColor(named: "Background", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let error = UIColor(named: "Error", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let pending = UIColor(named: "Pending", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let pendingLight = UIColor(named: "PendingLight", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let success = UIColor(named: "Success", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let successLight = UIColor(named: "SuccessLight", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
    public static let textGrey = UIColor(named: "Grey", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let greyLight = UIColor(named: "GreyLight", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
//    public static let titleGrey = UIColor(named: "TitleGrey", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
    public static let darkRed = UIColor(named: "DarkRed", in: Bundle(for: LocalColor.self), compatibleWith: nil) ?? UIColor()
}

extension UIColor {
    public func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    public func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}

