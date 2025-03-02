//
//  CancelBookingView.swift
//  BeachesAndBoats
//
//  Created by Hefepa on 28/02/2025.
//

import UIKit

class CancelBookingView: UIViewController {

    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var complaintField: UITextView!
    
    var coordinator: BookingsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureRecognizers()
        setupUI()
    }
    
    func setupUI() {
        complaintField.layer.borderWidth = 1
        complaintField.layer.borderColor = UIColor.lightGray.cgColor
        complaintField.layer.cornerRadius = 8
    }
    
    func gestureRecognizers() {
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelIconTapped))
        cancelIcon.isUserInteractionEnabled = true
        cancelIcon.addGestureRecognizer(cancel)
    }
    
    @objc func cancelIconTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
        if complaintField.hasText {
            MiddleModal.show(title: "Your cancelation request has been initiated", subtitle: "", type: .success, primaryText: "Done", dismissable: false, dismissOnConfirm: true, onConfirm: {
                self.dismiss(animated: true)
                self.coordinator?.start()
            })
        } else {
            MiddleModal.show(title: "Error", subtitle: "Kindly write a reason for cancellation", type: .error, primaryText: "Okay", dismissOnConfirm: true)
        }
    }
    
}
