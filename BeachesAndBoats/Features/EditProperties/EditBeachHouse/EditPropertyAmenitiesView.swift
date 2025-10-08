//
//  EditPropertyAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditPropertyAmenitiesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var details: GetBeachData?
    var selectedItems: [String] = []
    var id: String?
    
    var amenitiesList: [RoomAmenities]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup(){
        amenitiesList = beachData?.amenities?.filter{ $0.amenityType == "General"}
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = false  // Consistent with additional screen
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        // UPDATED: Initialize with only previous GENERAL amenities (not all from details)
        selectedItems = getGeneralAmenities(from: details?.amenities?.compactMap{ $0.id } ?? [])
        collectionView.reloadData()
        
        // Update button state based on selections
        updateNextButtonState()
        
        print("Setup - General amenities: \(amenitiesList?.count ?? 0)")
        print("Setup - Pre-selected general amenities: \(selectedItems)")
    }
    
    // NEW: Helper to filter previous amenities to only GENERAL types
    private func getGeneralAmenities(from allAmenities: [String]) -> [String] {
        let generalIds = amenitiesList?.compactMap { $0.id } ?? []
        return allAmenities.filter { generalIds.contains($0) }
    }
    
    private func updateNextButtonState() {
        nextBtn.isEnabled = !selectedItems.isEmpty
        print("Selected items count: \(selectedItems.count), Button enabled: \(nextBtn.isEnabled)")
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard !selectedItems.isEmpty else {
            print("Cannot proceed - no items selected")
            return
        }
        
        if let beachData = beachData {
            if createBeachListing == nil {
                createBeachListing = CreateBeachListingRequest()
            }
            // Now selectedItems only has generals, so this is clean
            createBeachListing?.amenities = selectedItems
            print("Proceeding with selected general amenities: \(selectedItems)")
            print(createBeachListing)
        
            if let createBeachListing = createBeachListing {
                coordinator?.gotoEditPropertyAdditionalAmenitiesView(beachData: beachData, request: createBeachListing, details: details, id: id)
            }
        }
    }
}

extension EditPropertyAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amenitiesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Amenities Cell " + indexPath.description
        
        guard let item = amenitiesList?[indexPath.row] else {
            cell.applyView(view: view)
            return cell
        }
        
        let itemId = item.id ?? ""
        let isSelected = selectedItems.contains(itemId)
        
        view.model.state = isSelected
        view.model.subtitle = item.name ?? ""
        view.isUserInteractionEnabled = false
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = amenitiesList?[indexPath.row] else {
            print("No item found at index \(indexPath.row)")
            return
        }
        
        let itemId = item.id ?? ""
        let itemName = item.name ?? "Unknown"
        
        // Toggle selection
        if selectedItems.contains(itemId) {
            // Remove from selection
            selectedItems.removeAll { $0 == itemId }
            print("Deselected: \(itemName) (ID: \(itemId))")
        } else {
            // Add to selection
            selectedItems.append(itemId)
            print("Selected: \(itemName) (ID: \(itemId))")
        }
        
        // Update the specific cell
        collectionView.reloadItems(at: [indexPath])
        
        // Update button state after selection change
        updateNextButtonState()
        
        print("Current selected general items: \(selectedItems)")
    }
}
