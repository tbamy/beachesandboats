//
//  ChatViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 16/05/2024.
//

import UIKit

class ChatViewController: UIViewController {
    
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var typeView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        let cancel = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(cancel)
    }
    
    @objc func closeTapped() {
        dismiss(animated: false, completion: nil)
    }


   
}
