//
//  DestinationSearchViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 01/06/2024.
//

import UIKit

class DestinationSearchViewController: UIViewController {
    
    @IBOutlet weak var cancel: UIImageView!
    @IBOutlet weak var searchByDate: UIView!
    @IBOutlet weak var searchByLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(closeSearch))
        cancel.isUserInteractionEnabled = true
        cancel.addGestureRecognizer(cancelGesture)
        
        searchByDate.layer.cornerRadius = 10
        searchByLocation.layer.borderWidth = 1
        searchByLocation.layer.cornerRadius = 10
        searchByLocation.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func closeSearch() {
        dismiss(animated: true, completion: nil)
    }
   

    @IBAction func searchCurrentLocationTapped(_ sender: Any) {
        
    }
    

}
