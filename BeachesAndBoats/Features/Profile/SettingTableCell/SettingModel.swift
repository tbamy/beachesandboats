//
//  SettingModel.swift
//  Beaches and Boats
//
//  Created by Paul Orimogunje on 11/05/2024.
//

import Foundation

struct SettingModelArray {
    func populateData() -> [ProfileModel] {
        [
            ProfileModel(img: "solar_user-linear", title: "Manage your profile"),
            ProfileModel(img: "ph_heart", title: "Saved"),
            ProfileModel(img: "uil_money-bill", title: "Payment"),
            ProfileModel(img: "iconamoon_notification-light", title: "Notification"),
            ProfileModel(img: "mingcute_shield-line", title: "Login and Security")
        ]
    }
}
