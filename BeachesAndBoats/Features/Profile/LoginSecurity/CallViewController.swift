//
//  CallViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 16/05/2024.
//

import UIKit

class CallViewController: UIViewController {

    @IBOutlet weak var callNumber: UIButton!
    @IBOutlet weak var cancelView: UIButton!
    @IBOutlet weak var containerCallView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).withAlphaComponent(0.5)
    }

    @IBAction func callTapped(_ sender: Any) {
        print("Calling number")
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
