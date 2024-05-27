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
    case closeIcon = "cancel"
    case creditCard = "creditcard"
    case paypal = "paypal"
    case plus = "plusIcon"
    case shield = "shield"
    case gmail = "gmail"
    case phone = "phone"
    case chat = "chat"
    case call = "call"
    case email = "email"
    case textfont = "textfont"
    case gif = "gif"
    case uploadPicture = "uploadPicture"
    case appLogo = "appLogo"
    case beach = "beach"
    case dateIcon = "dateIcon"
    case locationIcon = "locationIcon"
    case sort = "sort"
    case radioOn = "radioOn"
    case radioOff = "radioOff"
    case Share = "Share"
    case Favourite = "Favourite"
    case wifi = "wifi"
    case washer = "washer"
    case parking = "parking"
    case pets = "pets"
    case kitchen = "kitchen"
    case beachfont = "beachfont"
    case calendar = "calendar"
    case star = "star"
    case ratingstar = "ratingstar"
    case fillratingstar = "fillratingstar"
    case beachhouse = "beachhouse"
    case boats = "boats"
    case services = "services"
    case filter = "filter"
    case search = "search"
    case luxury = "luxury"
    case hotel = "hotel"
    case mansion = "mansion"
    case room = "room"
    case pool = "pool"
    


    var image: UIImage {
        UIImage(named: self.rawValue) ?? UIImage()
    }
}
