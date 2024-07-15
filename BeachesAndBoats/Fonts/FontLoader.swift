//
//  FontLoader.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 26/05/2024.
//

import UIKit
import Foundation

enum FontError: Error {
  case invalidFontFile
  case fontPathNotFound
  case initFontError
  case registerFailed
}

class GetBundle {}

extension UIFont {
    
    public static func loadAllFonts() {
        register(fileNameString: "Montserrat-Bold", type: ".ttf")
        register(fileNameString: "Montserrat-Light", type: ".ttf")
        register(fileNameString: "Montserrat-Medium", type: ".ttf")
        register(fileNameString: "Montserrat-Regular", type: ".ttf")
        register(fileNameString: "Montserrat-SemiBold", type: ".ttf")
    }
    
    static func register( fileNameString: String, type: String) {
        let frameworkBundle = Bundle(for: GetBundle.self)
        guard let resourceBundleURL = frameworkBundle.path(forResource: fileNameString, ofType: type) else { return }
        guard let fontData = NSData(contentsOfFile: resourceBundleURL),let dataProvider = CGDataProvider.init(data: fontData) else { return }
        guard let fontRef = CGFont.init(dataProvider) else { return }
        var errorRef: Unmanaged<CFError>? = nil
        guard CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) else { return }
     }
}
