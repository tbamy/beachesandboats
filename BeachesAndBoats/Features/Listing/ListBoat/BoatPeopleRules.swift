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
        stepOneProgress.setProgress(1, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        subtitleLabel.text = "Select the maximum number people that can be in your \(boatType ?? "") at once"
//        houseRulesList = boatData?.
        
        numberOfAdults.model = IncreaseDecreaseModel(id: "", type: "Number of adults", subtitle: "Ages 17+ years", count: 0)
        numberOfChildren.model = IncreaseDecreaseModel(id: "", type: "Number of children", subtitle: "Ages 0-16 years", count: 0)
        numberOfPets.model = IncreaseDecreaseModel(id: "", type: "Number of Pets", subtitle: "eg. dogs, cats etc.", count: 0)
        
    }

    @IBAction func nextTapped(_ sender: Any) {
        
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.noOfAdults = numberOfAdults.count
                createBoatListing.noOfChildren = numberOfChildren.count
                createBoatListing.noOfPets = numberOfPets.count
                print(createBoatListing)
                
                
                coordinator?.gotoBoatAddressView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.noOfAdults = numberOfAdults.count
            createBoatListing.noOfChildren = numberOfChildren.count
            createBoatListing.noOfPets = numberOfPets.count
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
    }


}
