//
//  GroundRulesViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 24/05/2024.
//

import UIKit

class GroundRulesViewController: UIViewController {
    @IBOutlet weak var cancelIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        let cancel = UITapGestureRecognizer(target: self, action: #selector(closeClicked))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
    }
    
    @objc func closeClicked() {
        dismiss(animated: true, completion: nil)
    }

}
