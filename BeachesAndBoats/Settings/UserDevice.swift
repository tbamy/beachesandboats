//
//  UserDevice.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/12/2024.
//

import UIKit
import DeviceKit

struct UserDevice: Codable {
   var imei: String = UIDevice.current.identifierForVendor?.uuidString ?? ""
    var name: String = Device.current.description
    var code: String = ""
    var os: String = UIDevice.current.systemVersion
    var biometricToken: String = ""
    var biometricCode: String = ""
    var isActiveDevice: Bool = true
}
