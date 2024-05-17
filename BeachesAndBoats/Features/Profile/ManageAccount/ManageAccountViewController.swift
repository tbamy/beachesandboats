//
//  ManageAccountViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 12/05/2024.
//

import UIKit

class ManageAccountViewController: UIViewController {

    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       navigation()

    }
    
    func navigation() {
        // right bar item
        let saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor(red: 0.047, green: 0.302, blue: 0.722, alpha: 1), for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "MontserratRoman-SemiBold", size: 14)
        saveButton.addTarget(self, action: #selector(saveDetails), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        // left navigation bar item
        let backButton = UIButton(type: .custom)
        if let backIcon = UIImage(named: "backButton") {
            backButton.setImage(backIcon.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        backButton.addTarget(self, action: #selector(popUp), for: .touchUpInside)
        let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        //title navigation
        let customFont = UIFont(name: "MontserratRoman-SemiBold", size: 16)
        if let customFont = customFont {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
        navigationItem.title = "Manage Account"
    }
    
    @objc func popUp() {
        coordinator?.pop(animated: true)
    }
    
    @objc func saveDetails() {
        coordinator?.pop(animated: true)
    }
    


   

}
