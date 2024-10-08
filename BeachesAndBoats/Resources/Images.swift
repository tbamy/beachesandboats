//
//  Images.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

enum Assets: String {
    case logo = "B&BLogo"
    case logo2 = "B&BLogoColoured"
    case slide1 = "slide1"
    case slide2 = "slide2"
    case slide3 = "slide3"
    case more = "formkit_right"
    case list = "gala_add"
    case switchicon = "icon-park_switch"
    case notification = "iconamoon_notification-light"
    case book = "iconoir_book"
    case loginSecurity = "mingcute_shield-line"
    case saved = "ph_heart"
    case profile = "solar_user-linear"
    case support = "streamline_customer-support-1"
    case payment = "uil_money-bill"
    case backButton = "backButton"
    case error_icon = "error_icon"
    case dropdownIcon = "dropdown_icon"
    case NGnum = "234"
    case uncheckIcon = "uncheck_icon"
    case checkIcon = "check_icon"
    case modal_success = "modal_success"
    case modal_error = "modal_error"
    case modal_pending = "modal_pending"
    case modal_caution = "model_caution"

    
    
    var image: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
}
