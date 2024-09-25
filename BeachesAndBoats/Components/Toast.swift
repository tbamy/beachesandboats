//
//  Toast.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 25/09/2024.
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
        
        label.sizeToFit()
        let padding: CGFloat = 20
        let width = label.frame.width + padding
        let height = label.frame.height + padding
        label.layer.cornerRadius = 8
        
        let x = UIScreen.main.bounds.width / 2 - width / 2
        let y = UIScreen.main.bounds.height - height - 50
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(label)
        
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

