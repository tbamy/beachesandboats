//
//  CollectionView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 06/01/2025.
//

import Foundation
import UIKit


extension UICollectionView{
    func updateCollectionViewHeight(_ CollectionView: UICollectionView, _ CollectionViewHeightConstraint: NSLayoutConstraint, _ view: UIView) {
        CollectionView.layoutIfNeeded()
        let contentHeight = CollectionView.contentSize.height
        CollectionViewHeightConstraint.constant = contentHeight
        
        view.layoutIfNeeded()
    }
}
