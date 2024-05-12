//
//  ViewControllerExtension.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 12/05/2024.
//

import UIKit

extension UIViewController {
    class func fromNib<T: UIViewController>() -> T {
        let vc = T(nibName: String(describing: T.self), bundle: nil)
        return vc
    }
    
    class func fromSuperNib<T: UIViewController>() -> T {
        let vc = T(nibName: String(describing: T.superclass()!.self), bundle: nil)
        return vc
    }
}
