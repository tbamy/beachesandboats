//
//  BoatDetailsViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 06/06/2024.
//

import UIKit

class BoatDetailsViewController: UIViewController {
    
    @IBOutlet weak var boatName: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var boatImage: UIImageView!
    @IBOutlet weak var backIcon: UIImageView!
    
    
    var coordinator: AppCoordinator?
    var getBoatTopRatedData: TopRatedProperties?
    var getBoatBookNowData: TopRatedProperties?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setup()
        gestureReconizer()
    }
    
    func setup() {
        boatImage.image = UIImage(named: getBoatTopRatedData?.img ?? "empty")
        location.text = getBoatTopRatedData?.location
        boatName.text = getBoatTopRatedData?.name
    }
    
    func gestureReconizer() {
        let back = UITapGestureRecognizer(target: self, action: #selector(backTapped))
        backIcon.isUserInteractionEnabled = true
        backIcon.addGestureRecognizer(back)
    }
    
    @objc func backTapped() {
        popView()
    }
}
