//
//  BoatNameView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 07/11/2024.
//

import UIKit

class BoatNameView: BaseViewControllerPlain {

    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nameLabel: InputField!
    @IBOutlet weak var descriptionLabel: TextViewField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setUp()
    }
    
    func setUp(){
        stepOneProgress.setProgress(0.40, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        titleLabel.text = "What is the name and description of your \(boatType ?? "")?"
        
//        checkTextFields()
//
//        nameLabel.onTextChanged = { [weak self] text in
//            self?.checkTextFields()
//        }

//        descriptionLabel.onTextChanged = { [weak self] _ in
//            self?.checkTextFields()
//        }
    }
    
    func checkTextFields() {
        print("Checking text fields...")
        let isNameFilled = !(nameLabel.text.isEmpty)
        let isDescriptionFilled = !(descriptionLabel.text.isEmpty)
        
        print("Description: \(descriptionLabel.text)")
        
        nextBtn.isEnabled = isNameFilled && isDescriptionFilled
        print("Name filled: \(isNameFilled), Description filled: \(isDescriptionFilled), Button enabled: \(nextBtn.isEnabled)")
    }



    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.name = nameLabel.text
                createBoatListing.description = descriptionLabel.text
                
                print(createBoatListing)
                
                coordinator?.gotoBoatAvailableDatesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.name = nameLabel.text
            createBoatListing.description = descriptionLabel.text
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }

    }
    
}
