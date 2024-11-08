//
//  Toast.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 29/09/2024.
//

import UIKit

public class Toast: UILabel {
    static let shared = Toast()
    
    private init() {
        super.init(frame: CGRect.zero)
        textColor = UIColor.white
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        numberOfLines = 0
        font = UIFont.systemFont(ofSize: 14)
        textAlignment = .center
        alpha = 0.0
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public static func show(message: String, duration: TimeInterval = 2.0) {
        let label = Toast()
        label.text = message
        
        let padding: CGFloat = 20
        let maxWidth = UIScreen.main.bounds.width - 2 * padding // Subtract padding from both sides
        label.frame = CGRect(x: 0, y: 0, width: maxWidth, height: .greatestFiniteMagnitude)
        
        // Calculate the size that fits the message within the maxWidth
        label.sizeToFit()
        
        let width = min(label.frame.width + padding, maxWidth)
        let height = label.frame.height + padding
        label.layer.cornerRadius = 8
        
        let x = UIScreen.main.bounds.width / 2 - width / 2
        let y = UIScreen.main.bounds.height - height - 50
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Add the toast to the key window
        if let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            keyWindow.addSubview(label)
        }
        
        // Show the toast with animation
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {
            label.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseInOut, animations: {
                label.alpha = 0.0
            }, completion: { _ in
                label.removeFromSuperview()
            })
        })
    }
}
