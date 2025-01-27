//
//  HostListingSortView.swift
//  BeachesAndBoats
//
//  Created by WEMA on 11/01/2025.
//

import UIKit

class HostListingSortView: UIViewController {
    
    var coordinator: HostingHouseAndBoatListingCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationButton()
    }
    
    func setupNavigationButton() {
        let leftButton = UIBarButtonItem(image: UIImage(named: "close_icon")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(closeTapped))
        self.navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func closeTapped() {
        self.dismiss(animated: true)
    }


    @IBAction func applyBtnTapped(_ sender: Any) {
    }
    
}
