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
        
//        nameLabel.onTextChanged = { [weak self] text in
//            self?.checkTextFields()
//        }
//
//        descriptionLabel.onTextChanged = { [weak self] text in
//            self?.checkTextFields()
//        }
//
//        checkTextFields()
    }
    
    func checkTextFields() {
        let isNameFilled = !nameLabel.text.isEmpty
        let isDescriptionFilled = !descriptionLabel.text.isEmpty
        
        nextBtn.isEnabled = isNameFilled && isDescriptionFilled
    }
    
    func validate(){
        
    }


    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: nameLabel.text, description: descriptionLabel.text, from_when: "", to_when: "", amenities: [], preferred_languages: [], brief_introduction: "", rules: [], no_of_adults: 0, no_of_children: 0, no_of_pets: 0, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatAvailableDatesView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }
    
}
