//
//  NotificationModel.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 16/05/2024.
//

import Foundation

struct NotificationModel {
    func populateData() -> [NotificationProperties] {
        [
            NotificationProperties(title: "Pricing updates", subTitle: "Get notification on the changes on prices"),
            NotificationProperties(title: "Hosting updates", subTitle: "Get notified on the hosting policies and changes in your mail"),
            NotificationProperties(title: "Beaches and Boats updates", subTitle: "Get notification on any update regarding Beaches and Boats policy"),
            NotificationProperties(title: "Travel tips and offers", subTitle: "Get travel tips and offers for your next travel in your mail"),
            NotificationProperties(title: "Vacation plans", subTitle: "Get informed in your mail for vacataions plans we have for you for different places"),
            NotificationProperties(title: "News and updates", subTitle: "Get notified in your mail about the current news about vacation"),
            NotificationProperties(title: "Bonus and offers", subTitle: "Get informed in your mail on different bonuses and offers available at the moment")
        ]
    }
}

struct NotificationProperties {
    let title: String?
    let subTitle: String?
}
