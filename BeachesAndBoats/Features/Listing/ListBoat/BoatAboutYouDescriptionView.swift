//
//  BoatAboutYouDescriptionView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BoatAboutYouDescriptionView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setUp()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.80, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
//        if descriptionLabel.text.isEmpty{
//            descriptionLabel.error = "Enter a description"
//            nextBtn.isEnabled = false
//        }else{
            nextBtn.isEnabled = true
//        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.aboutOwner = descriptionLabel.text
                
                print(createBoatListing)
                
                coordinator?.gotoBoatRulesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.aboutOwner = descriptionLabel.text
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
    }


}
