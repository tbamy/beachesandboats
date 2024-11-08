//
//  BoatPeopleRules.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//
import UIKit

class BoatPeopleRules: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var numberOfAdults: IncreaseDecreaseField!
    @IBOutlet weak var numberOfChildren: IncreaseDecreaseField!
    @IBOutlet weak var numberOfPets: IncreaseDecreaseField!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var houseRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.90, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        subtitleLabel.text = "Select the maximum number people that can be in your \(boatType ?? "") at once"
//        houseRulesList = boatData?.
        
        numberOfAdults.model = IncreaseDecreaseModel(type: "Number of adults", subtitle: "Ages 17+ years", count: 0)
        numberOfChildren.model = IncreaseDecreaseModel(type: "Number of children", subtitle: "Ages 0-16 years", count: 0)
        numberOfPets.model = IncreaseDecreaseModel(type: "Number of Pets", subtitle: "eg. dogs, cats etc.", count: 0)
        
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: createBoatListing?.name ?? "", description: createBoatListing?.description ?? "", from_when: createBoatListing?.from_when ?? "", to_when: createBoatListing?.to_when ?? "", amenities: createBoatListing?.amenities ?? [], preferred_languages: createBoatListing?.preferred_languages ?? [], brief_introduction: createBoatListing?.brief_introduction ?? "", rules: createBoatListing?.rules ?? [], no_of_adults: numberOfAdults.count, no_of_children: numberOfChildren.count, no_of_pets: numberOfPets.count, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatAddressView(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }


}
