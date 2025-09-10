//
//  BoatFacilitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BoatFacilitiesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var selectedFacilities: [String] = []
    
    var amenitiesList: [RoomAmenities]?
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Boats"
//        setup()
//    }
//    
//    func setup(){
//        stepOneProgress.setProgress(0.60, animated: true)
//        stepOneProgress.tintColor = .B_B
//        stepTwoProgress.setProgress(0, animated: false)
//        
//        titleLabel.text = "What are the features in your \(boatType ?? "")?"
//        subtitleLabel.text = "Provide the correct details and info about your \(boatType ?? "")"
//        
//        amenitiesList = boatData?.amenities?.filter{ $0.amenityType == "General"}
//        
//        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.allowsMultipleSelection = true
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//    }
//
//    @IBAction func nextTapped(_ sender: Any) {
//
//        if let boatData = boatData{
//            if var createBoatListing = createBoatListing{
//                createBoatListing.amenities = selectedFacilities
//                
//                print("Main Amenities: \(selectedFacilities)")
//                print(createBoatListing)
//                
//                coordinator?.gotoBoatAdditionalAmenitiesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
//            }
//            
//        }
//    }
//    
//    @IBAction func saveAndExit(_ sender: Any) {
//        if var createBoatListing = createBoatListing{
//            createBoatListing.amenities = selectedFacilities
//            
//            AppStorage.boatListing = createBoatListing
//            coordinator?.backToDashboard()
//        }
//
//    }
//    
//
//}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = AppStorage.boatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("Amenities count: \(savedListing.amenities?.count ?? 0)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Load saved amenities (filter for General type only)
            if let savedAmenities = savedListing.amenities {
                // We need to filter these to only include "General" type amenities
                // This will be done after amenitiesList is populated in setup()
                selectedFacilities = savedAmenities
            }
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    private func filterSavedFacilities() {
        // Filter saved amenities to only include those that are "General" type
        guard let amenitiesList = amenitiesList else { return }
        
        let generalAmenityIds = amenitiesList.compactMap { $0.id }
        selectedFacilities = selectedFacilities.filter { generalAmenityIds.contains($0) }
        
        // Enable next button if we have selected facilities
        nextBtn.isEnabled = !selectedFacilities.isEmpty
        
        print("Filtered facilities: \(selectedFacilities)")
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        titleLabel.text = "What are the features in your \(boatType ?? "")?"
        subtitleLabel.text = "Provide the correct details and info about your \(boatType ?? "")"
        
        amenitiesList = boatData?.amenities?.filter{ $0.amenityType == "General"}
        
        // Filter saved facilities after amenitiesList is populated
        if createBoatListing != nil {
            filterSavedFacilities()
        } else {
            nextBtn.isEnabled = false
        }
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                // Preserve existing amenities and update with current selection
                let existingAmenities = createBoatListing.amenities ?? []
                let nonGeneralAmenities = existingAmenities.filter { amenityId in
                    // Keep amenities that are not "General" type
                    guard let amenitiesList = self.amenitiesList else { return true }
                    return !amenitiesList.contains { $0.id == amenityId }
                }
                
                // Combine non-general amenities with current selection
                createBoatListing.amenities = nonGeneralAmenities + selectedFacilities
                
                print("Main Amenities: \(selectedFacilities)")
                print(createBoatListing)
                
                coordinator?.gotoBoatAdditionalAmenitiesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            // Preserve existing amenities and update with current selection
            let existingAmenities = createBoatListing.amenities ?? []
            let nonGeneralAmenities = existingAmenities.filter { amenityId in
                guard let amenitiesList = self.amenitiesList else { return true }
                return !amenitiesList.contains { $0.id == amenityId }
            }
            
            createBoatListing.amenities = nonGeneralAmenities + selectedFacilities
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
    }
}

extension BoatFacilitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Amenities Cell " + indexPath.description
        let item = amenitiesList?[indexPath.row]
        
        let itemId = item?.id ?? ""
        if selectedFacilities.contains(itemId) {
            view.model.state = true
        } else {
            view.model.state = false
        }
        
        view.model.subtitle = item?.name ?? ""
        view.isUserInteractionEnabled = false
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 35)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = amenitiesList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        if selectedFacilities.contains(itemId) {
            selectedFacilities.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedFacilities.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = !selectedFacilities.isEmpty
    }

    
}
