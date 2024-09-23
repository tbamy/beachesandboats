//
//  BookingConfirmationViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 09/06/2024.
//

import UIKit

class BookingConfirmationViewController: UIViewController {
    
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Confirm Booking", navigationSubtitle: nil, rightIcon: nil, secondRightIcon: nil)
    }
    
    @IBAction func makePaymentTapped(_ sender: Any) {
        coordinator?.gotoPayments()
    }
    

  

}
