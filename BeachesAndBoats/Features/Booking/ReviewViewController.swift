//
//  ReviewViewController.swift
//  BeachesAndBoats
//
//  Created by WEMA on 23/05/2024.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var closeIcon: UIImageView!
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStars: UIButton!
    @IBOutlet weak var threeStars: UIButton!
    @IBOutlet weak var fourStars: UIButton!
    @IBOutlet weak var fiveStars: UIButton!
    @IBOutlet var starCollections: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSetup()
        starSetup()
    }
    
    func viewSetup() {
        view.backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 0.2).withAlphaComponent(0.2)
        let cancel = UITapGestureRecognizer(target: self, action: #selector(cancelClicked))
        closeIcon.isUserInteractionEnabled = true
        closeIcon.addGestureRecognizer(cancel)
    }
    
    func starSetup() {
        for (index, stars) in starCollections.enumerated() {
            stars.tintColor = UIColor.backgroundcolor
            stars.layer.borderWidth = 1
            stars.layer.borderColor = UIColor.lightGray.cgColor
            stars.layer.cornerRadius = 10
            stars.setTitle("\(index + 1)", for: .normal)
            stars.setTitleColor(.black, for: .normal)
        }
    }
    
    @objc func cancelClicked() {
        dismiss(animated: true)
    }
    
    @IBAction func oneStarTapped(_ sender: Any) {
        updateStarButtons(selectedButton: oneStar, totalStars: 1)
    }
    
    @IBAction func twoStarTapped(_ sender: Any) {
        updateStarButtons(selectedButton: twoStars, totalStars: 2)
    }
    
    @IBAction func threeStarTapped(_ sender: Any) {
        updateStarButtons(selectedButton: threeStars, totalStars: 3)
    }
    
    @IBAction func fourStarTapped(_ sender: Any) {
        updateStarButtons(selectedButton: fourStars, totalStars: 4)
    }
    
    @IBAction func fiveStarTapped(_ sender: Any) {
        updateStarButtons(selectedButton: fiveStars, totalStars: 5)
    }
    
    func updateStarButtons(selectedButton: UIButton, totalStars: Int) {
        let filledStar = UIImage(named: "fillratingstar")
        let ratingStar = UIImage(named: "ratingstar")
        
        for (index, button) in starCollections.enumerated() {
            if index < totalStars {
                button.setImage(filledStar, for: .normal)
                button.tintColor = UIColor.B_B
                button.setTitleColor(.white, for: .normal)
            } else {
                button.setImage(ratingStar, for: .normal)
                button.tintColor = UIColor.backgroundcolor
                button.setTitleColor(.black, for: .normal)
            }
        }
    }
}
