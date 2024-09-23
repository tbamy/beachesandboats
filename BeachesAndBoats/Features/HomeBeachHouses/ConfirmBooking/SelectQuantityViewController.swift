//
//  SelectQuantityViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 09/06/2024.
//

import UIKit

class SelectQuantityViewController: UIViewController {
    @IBOutlet weak var closeIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        closeView(for: closeIcon)
    }



}
