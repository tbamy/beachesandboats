//
//  Images.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

enum Assets: String {
    case logo = "B&BLogo"
    case slide1 = "slide1"
    case slide2 = "slide2"
    case slide3 = "slide3"
    case backButton = "backButton"

    
    
    var image: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
}
