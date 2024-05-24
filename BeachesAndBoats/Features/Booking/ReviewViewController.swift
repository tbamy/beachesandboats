//
//  ReviewViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 23/05/2024.
//

import UIKit

class ReviewViewController: UIViewController {
//    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var closeIcon: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
       viewSetup()
    }
    
    func viewSetup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
//        button.layer.borderWidth = 5
////        button.layer.borderColor = UIColor.black.cgColor
//        button.layer.cornerRadius = 10
        
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelClicked))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true)
    }


  

}
