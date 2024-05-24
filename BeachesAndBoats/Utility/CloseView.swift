//
//  CloseView.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 15/05/2024.
//

import Foundation
import UIKit

extension UIViewController {
    func closeView(for imageView: UIImageView) {
        let closeGesture = UITapGestureRecognizer(target: self, action: #selector(cancelTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(closeGesture)
    }

    @objc private func cancelTapped() {
        dismiss(animated: true, completion: nil)
    }
}
