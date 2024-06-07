//
//  SafetyAndGuidelinesViewController.swift
//  BeachesAndBoats
//
//  Created by Paul Orimogunje on 16/05/2024.
//

import UIKit

class SafetyAndGuidelinesViewController: UIViewController {

    @IBOutlet weak var safetyGuidelines: UILabel!
    
    var coordinator: AppCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Safety and Guidelines", navigationSubtitle: nil, rightIcon: nil, secondRightIcon: nil)
        
//        NavigationUtility.shared.setupNavigation(for: self, backIcon: UIImage(named: "backButton"), navigationTitle: "Safety and Guidelines", rightIcon: nil)
        setup()
    }
    
    func setup() {
        let attributedString = NSMutableAttributedString(string: "IThe safety and guideline can be found in our Safety books and guidelines documents.")
        
        let wordToColor = "Safety books and guidelines"
        let range = (attributedString.string as NSString).range(of: wordToColor)
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: range)
        
        safetyGuidelines.attributedText = attributedString
        safetyGuidelines.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(safetyRulesTapped))
        safetyGuidelines.addGestureRecognizer(tapGesture)
    }
    
    @objc func safetyRulesTapped() {
        print("This is our guidelines")
    }


  

}
