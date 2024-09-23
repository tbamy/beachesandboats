//
//  PhotoCollectionsViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 10/06/2024.
//

import UIKit

class PhotoCollectionsViewController: UIViewController {
    
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        NavigationUtility.shared.setupNavigation(
            for: self,
            backIcon: UIImage(named: "backButton"),
            navigationTitle: "Photos",
            navigationSubtitle: nil,
            rightIcon: { button in
                button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysOriginal), for: .normal)
            },
            secondRightIcon: { button in
                button.setImage(UIImage(named: "sort")?.withRenderingMode(.alwaysOriginal), for: .normal)
            })
    }


    

}
