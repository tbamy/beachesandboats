//
//  HouseAndGroundRulesView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 28/02/2025.
//

import UIKit

class HouseAndGroundRulesView: UIViewController {
    
    @IBOutlet weak var cancelIcon: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelIconTapped))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancelIconTapped() {
        self.dismiss(animated: true)
    }


    @IBAction func proceedBtnTapped(_ sender: Any) {
        
    }
    

}
