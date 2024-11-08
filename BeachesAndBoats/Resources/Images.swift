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
    case backBtn = "back_btn"
    case cancelIcon = "cancelIcon"
    case error_icon = "error_icon"
    case dropdownIcon = "dropdown_icon"
    case NGnum = "234"
    case uncheckIcon = "uncheck_icon"
    case checkIcon = "check_icon"
    case modal_success = "modal_success"
    case modal_error = "modal_error"
    case modal_pending = "modal_pending"
    case modal_caution = "model_caution"
    case account_menu = "account_menu"
    case explore_menu = "explore_menu"
    case messages_menu = "messages_menu"
    case saved_menu = "saved_menu"
    case bookings_menu = "bookings_menu"
    case property = "property"
    case radioOff = "radio_off"
    case radioOn = "radio_on"
    case filterIcon2 = "filter_icon2"
    case sortIcon = "sort_icon"
    case calendar = "calendar"
    case location = "location"
    case people = "people"
    

    
    
    var image: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
}
