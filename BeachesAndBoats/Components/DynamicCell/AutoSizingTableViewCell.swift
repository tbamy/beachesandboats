//
//  AutoSizingTableViewCell.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/09/2024.
//

import UIKit

class AutoSizingTableViewCell: UITableViewCell {
    
    public func applyView(view: Sizeable) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.addSubview(view)
        view.pinView(to: self)
        contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: view.getHeight()).isActive = true
    }

}

public protocol Sizeable: UIView {
    func getHeight() -> CGFloat
}
