//
//  BoatAdditionalAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BoatAdditionalAmenitiesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
//    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var selectedAmenities: [String] = []
    
    var amenitiesList: [RoomAmenities]?

    let hostRoles: [HostType] = [.primaryHost, .secondaryHost]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        
        checkAndLoadSavedListing()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = AppStorage.boatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("Total amenities count: \(savedListing.amenities?.count ?? 0)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Load saved amenities (will be filtered for Safety type in setup)
            if let savedAmenities = savedListing.amenities {
                selectedAmenities = savedAmenities
            }
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    private func filterSavedAmenities() {
        // Filter saved amenities to only include those that are "Safety" type
        guard let amenitiesList = amenitiesList else { return }
        
        let safetyAmenityIds = amenitiesList.compactMap { $0.id }
        selectedAmenities = selectedAmenities.filter { safetyAmenityIds.contains($0) }
        
        // Enable next button if we have any amenities (either from general or safety)
        nextBtn.isEnabled = true
        
        print("Filtered safety amenities: \(selectedAmenities)")
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        amenitiesList = boatData?.amenities?.filter{ $0.amenityType == "Safety"}
        subtitleLabel.text = "Select the amenities available to guests in your \(boatType ?? "")."
        
        // Filter saved amenities after amenitiesList is populated
        if createBoatListing != nil {
            filterSavedAmenities()
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
                // Get existing amenities and filter out Safety type
                let existingAmenities = createBoatListing.amenities ?? []
                let nonSafetyAmenities = existingAmenities.filter { amenityId in
                    guard let amenitiesList = self.amenitiesList else { return true }
                    return !amenitiesList.contains { $0.id == amenityId }
                }
                
                // Combine non-safety amenities with current safety selection
                createBoatListing.amenities = nonSafetyAmenities + selectedAmenities
                
                print("current amenities: \(createBoatListing.amenities ?? [])")
                print("additional amenities: \(selectedAmenities)")
                print(createBoatListing)
                
                let userRoles = UserSession.shared.userDetails?.roles
                let hostRoleStrings = hostRoles.map { $0.rawValue }
                let hasHostRole = userRoles?.contains { hostRoleStrings.contains($0) }
                
//                if let _ = hasHostRole {
//                    coordinator?.gotoBoatRulesView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
//                }else{
                    coordinator?.gotoBoatAboutYouLanguageView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
//                }
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            // Get existing amenities and filter out Safety type
            let existingAmenities = createBoatListing.amenities ?? []
            let nonSafetyAmenities = existingAmenities.filter { amenityId in
                guard let amenitiesList = self.amenitiesList else { return true }
                return !amenitiesList.contains { $0.id == amenityId }
            }
            
            createBoatListing.amenities = nonSafetyAmenities + selectedAmenities
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
    }
}


extension BoatAdditionalAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Additional Amenities Cell " + indexPath.description
        let item = amenitiesList?[indexPath.row]
        
        let itemId = item?.id ?? ""
        if selectedAmenities.contains(itemId) {
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
        
        if selectedAmenities.contains(itemId) {
            selectedAmenities.removeAll { $0 == itemId }
            view.model.state = true
//            view.model.image = UIImage.uncheckIcon
        } else {
            selectedAmenities.append(itemId)
            view.model.state = false
//            view.model.image = UIImage.checkIcon
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = !selectedAmenities.isEmpty
    }

    
}
