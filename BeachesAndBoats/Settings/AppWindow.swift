//
//  AppWindow.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class AppWindow: UIWindow{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var count = 0
    var timedOut: Bool = false
    var reissueCount = 0
    var time = 3*60
    var refreshTime = (3*60) - 30
    var backgroundTime = 1*30
    var timer: Timer = Timer()
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
