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
        
        checkAndLoadSavedListing()
        setUp()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = AppStorage.boatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("About owner: \(savedListing.aboutOwner ?? "No description")")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Populate field with saved data
            descriptionLabel.text = savedListing.aboutOwner ?? ""
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.80, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        // Check initial state - enable button if we have saved data or current text
        nextBtn.isEnabled = true
        
//        descriptionLabel.onTextChanged = { [weak self] _ in
//            self?.checkTextField()
//        }
    }
    
    func checkTextField() {
        nextBtn.isEnabled = !descriptionLabel.text.isEmpty
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
