//
//  BookingCancelViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 24/05/2024.
//

import UIKit

class BookingCancelViewController: UIViewController {
    
    @IBOutlet weak var closeIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.8)
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancel))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
    }
}
