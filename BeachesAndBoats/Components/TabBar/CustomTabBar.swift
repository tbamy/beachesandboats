//
//  CustomTabBar.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 03/01/2025.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    private let middleButton = UIButton()
    
    var user = UserSession.shared.userDetails
    let serviceRoles: [HostType] = [.chef, .dj, .bouncer]
    let hostRoles: [HostType] = [.primaryHost, .secondaryHost]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMiddleButton()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupMiddleButton()
    }

    private func setupMiddleButton() {
        middleButton.frame.size = CGSize(width: 64, height: 64)
        middleButton.layer.cornerRadius = 32
        middleButton.backgroundColor = .B_B
        if let userRoles = user?.roles {
            let hostRoleStrings = self.hostRoles.map { $0.rawValue }
            let hasHostRole = userRoles.contains { hostRoleStrings.contains($0) }
            
            let serviceRoleStrings = serviceRoles.map { $0.rawValue }
            let hasSeviceRole = userRoles.contains { serviceRoleStrings.contains($0)}
            
            if hasHostRole {
                middleButton.setImage(UIImage(named: "plusTab"), for: .normal)
            } else if hasSeviceRole {
                middleButton.setImage(UIImage(named: "editIcon"), for: .normal)
            }
        }
        middleButton.tintColor = .white
        
        // Add shadow
        middleButton.layer.shadowColor = UIColor.black.cgColor
        middleButton.layer.shadowOpacity = 0.3
        middleButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        middleButton.layer.shadowRadius = 10
        
        middleButton.addTarget(self, action: #selector(middleButtonTapped), for: .touchUpInside)
        
        addSubview(middleButton)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Position the middle button in the center of the tab bar
        middleButton.center = CGPoint(x: frame.width / 2, y: 0)
    }

    @objc private func middleButtonTapped() {
        // Handle middle button action
        print("Middle button tapped")
    }
}
