//
//  WelcomeScreen.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

class WelcomeScreen: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    
    var coordinator: AppCoordinator?
    
//    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logo.fadeIn(duration: 0.5, delay: 0.2)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(autoNavigate), userInfo: nil, repeats: true)
//    }
    
    
    @objc func autoNavigate(){
        coordinator?.gotoWalkthrough()
    }

}
