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
//            nextBtn.isEnabled = true
//        }
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: createBoatListing?.name ?? "", description: createBoatListing?.description ?? "", from_when: createBoatListing?.from_when ?? "", to_when: createBoatListing?.to_when ?? "", amenities: createBoatListing?.amenities ?? [], preferred_languages: createBoatListing?.preferred_languages ?? [], brief_introduction: descriptionLabel.text, rules: [], no_of_adults: 0, no_of_children: 0, no_of_pets: 0, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatRulesView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }


}
