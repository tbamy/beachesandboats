//
//  HouseDetailsView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 30/08/2025.
//

import UIKit

class HouseDetailsView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var noOfRooms : IncreaseDecreaseField!
    @IBOutlet weak var noOfGuests : IncreaseDecreaseField!
    @IBOutlet weak var noOfBeds : IncreaseDecreaseField!
    @IBOutlet weak var noOfBathrooms : IncreaseDecreaseField!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
//    var houseRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        
//        checkAndLoadSavedListing()
        setup()
    }
    
    
    func setup(){
        stepOneProgress.setProgress(1, animated: true)
        stepOneProgress.tintColor = .success
        stepTwoProgress.setProgress(0.3, animated: false)
        stepTwoProgress.tintColor = .B_B
//        subtitleLabel.text = "Select the maximum number people that can be in your \(boatType ?? "") at once"
        
        // Set initial counts from saved data or default to 0
        let roomsCount = createBeachListing?.noOfRooms ?? 1
        let guestsCount = createBeachListing?.noOfGuests ?? 1
        let bedsCount = createBeachListing?.noOfBeds ?? 1
        let bathroomsCount = createBeachListing?.noOfBathrooms ?? 1
        
        noOfRooms.model = IncreaseDecreaseModel(id: "", type: "Number of rooms", subtitle: "", count: roomsCount)
        noOfGuests.model = IncreaseDecreaseModel(id: "", type: "Number of guest allowed", subtitle: "", count: guestsCount)
        noOfBeds.model = IncreaseDecreaseModel(id: "", type: "Number of beds", subtitle: "", count: bedsCount)
        noOfBathrooms.model = IncreaseDecreaseModel(id: "", type: "Number of bathrooms", subtitle: "", count: bathroomsCount)
        
        // Enable next button if we have saved data with at least one person/pet
        let hasValidCounts = roomsCount > 0 && guestsCount > 0 && bedsCount > 0 && bathroomsCount > 0
        nextBtn.isEnabled = hasValidCounts
        
        loadSavedData()
        
//        // Setup count change handlers
//        noOfRooms.onValueChange = { [weak self] _ in
//            self?.validateCounts()
//        }
//        
//        noOfGuests.onValueChange = { [weak self] _ in
//            self?.validateCounts()
//        }
//        
//        noOfBeds.onValueChange = { [weak self] _ in
//            self?.validateCounts()
//        }
//        
//        noOfBathrooms.onValueChange = { [weak self] _ in
//            self?.validateCounts()
//        }
    }
    
//    private func validateCounts() {
//        let hasValidCounts = noOfRooms.count > 0 && noOfGuests.count > 0 && noOfBeds.count > 0 && noOfBathrooms.count > 0
//        nextBtn.isEnabled = hasValidCounts
//    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.noOfRooms = noOfRooms.count
                createBeachListing.noOfGuests = noOfGuests.count
                createBeachListing.noOfBeds = noOfBeds.count
                createBeachListing.noOfBathrooms = noOfBathrooms.count
                print(createBeachListing)
                
                guard noOfRooms.count > 0 && noOfGuests.count > 0 && noOfBeds.count > 0 && noOfBathrooms.count > 0 else {
                    Toast.show(message: "Please select at least one item for each.")
                    return
                }
                
                coordinator?.gotoUploadImageView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.noOfRooms = noOfRooms.count
            createBeachListing.noOfGuests = noOfGuests.count
            createBeachListing.noOfBeds = noOfBeds.count
            createBeachListing.noOfBathrooms = noOfBathrooms.count
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }
    }
}


extension HouseDetailsView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Load house detail counts
        let roomsCount = savedListing.noOfRooms ?? 1
        let guestsCount = savedListing.noOfGuests ?? 1
        let bedsCount = savedListing.noOfBeds ?? 1
        let bathroomsCount = savedListing.noOfBathrooms ?? 1
        
        // Update the UI fields
        noOfRooms.model = IncreaseDecreaseModel(id: "", type: "Number of rooms", subtitle: "", count: roomsCount)
        noOfGuests.model = IncreaseDecreaseModel(id: "", type: "Number of guest allowed", subtitle: "", count: guestsCount)
        noOfBeds.model = IncreaseDecreaseModel(id: "", type: "Number of beds", subtitle: "", count: bedsCount)
        noOfBathrooms.model = IncreaseDecreaseModel(id: "", type: "Number of bathrooms", subtitle: "", count: bathroomsCount)
        
        // Enable next button if we have valid counts
        let hasValidCounts = roomsCount > 0 && guestsCount > 0 && bedsCount > 0 && bathroomsCount > 0
        nextBtn.isEnabled = hasValidCounts
    }
}
