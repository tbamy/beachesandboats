//
//  EditPropertyAdditionalAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit
import RxSwift

class EditPropertyAdditionalAmenitiesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var safetyAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var otherAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var details: GetBeachData?
    
    var selectedItems: [String] = []
    var id: String?
    
    var safetyAmenitiesList: [RoomAmenities]?
    var otherAmenitiesList: [RoomAmenities]?
    
    var disposeBag = DisposeBag()
    var vm = EditBeachViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        
        bindNetwork()
        setup()
    }
    
    func setup(){
        safetyAmenitiesList = beachData?.amenities?.filter{ $0.amenityType == "Safety"}
        otherAmenitiesList = beachData?.amenities?.filter{ $0.amenityType == "Others"}
        
        safetyAmenitiesCollectionView.backgroundColor = UIColor.background.lighter(by: 17)
        otherAmenitiesCollectionView.backgroundColor = UIColor.background.lighter(by: 17)
        
        safetyAmenitiesCollectionView.delegate = self
        safetyAmenitiesCollectionView.tag = 0
        safetyAmenitiesCollectionView.dataSource = self
        safetyAmenitiesCollectionView.allowsMultipleSelection = true
        safetyAmenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        otherAmenitiesCollectionView.delegate = self
        otherAmenitiesCollectionView.tag = 1
        otherAmenitiesCollectionView.dataSource = self
        otherAmenitiesCollectionView.allowsMultipleSelection = true
        otherAmenitiesCollectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        // Initialize selectedItems with additional amenities (Safety + Others) that were previously selected
        selectedItems = getAdditionalAmenities(from: details?.amenities?.compactMap{ $0.id } ?? [])
        
        safetyAmenitiesCollectionView.reloadData()
        otherAmenitiesCollectionView.reloadData()
        
        updateNextButtonState()
        
        print("Setup - Safety amenities: \(safetyAmenitiesList?.count ?? 0)")
        print("Setup - Other amenities: \(otherAmenitiesList?.count ?? 0)")
        print("Setup - Pre-selected additional amenities: \(selectedItems)")
        
    }
    
    private func getAdditionalAmenities(from allAmenities: [String]) -> [String] {
        let safetyIds = safetyAmenitiesList?.compactMap { $0.id } ?? []
        let otherIds = otherAmenitiesList?.compactMap { $0.id } ?? []
        let additionalIds = safetyIds + otherIds
        
        return allAmenities.filter { additionalIds.contains($0) }
    }
    
    private func updateNextButtonState() {
        // Check if we have any amenities selected (from previous screen + current selections)
        let totalAmenities = (createBeachListing?.amenities ?? []) + selectedItems
        let hasSelections = !totalAmenities.isEmpty
        
        nextBtn.isEnabled = hasSelections
        
        print("Button state update:")
        print("- General amenities: \(createBeachListing?.amenities?.count ?? 0)")
        print("- Additional amenities: \(selectedItems.count)")
        print("- Total amenities: \(totalAmenities.count)")
        print("- Button enabled: \(nextBtn.isEnabled)")
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else {
            print("Error: Missing property ID")
            return
        }
        
        let generalAmenities = createBeachListing?.amenities ?? []
        let allAmenities = generalAmenities + selectedItems
        
        guard !allAmenities.isEmpty else {
            print("Cannot proceed - no amenities selected")
            return
        }
        
        if var createBeachListing = createBeachListing {
            createBeachListing.amenities = allAmenities
            self.createBeachListing = createBeachListing
            
            print("Proceeding with amenities:")
            print("- General: \(generalAmenities)")
            print("- Additional: \(selectedItems)")
            print("- Total: \(allAmenities)")
            print(createBeachListing)
            
            LoadingModal.show(title: "Updating Record...")
            vm.editBeach(createBeachListing, id: id)
                
        }
    }
    
    func bindNetwork(){
        vm.output.subscribe(onNext: {[weak self] response in
            LoadingModal.dismiss()
            
            switch response {
            case .editBeachSuccessful(let response):
                print("Edit successful: \(response)")
                MiddleModal.show(title: response.message ?? "Update successful", type: .success, onConfirm: {
                    self?.coordinator?.popToOptionsScreen()
                })
                
            case .editBeachFailed(let error):
                print("Edit failed: \(error)")
                MiddleModal.show(title: error.message ?? "Update failed", type: .error)
            }
            
        }).disposed(by: disposeBag)
    }
}

extension EditPropertyAdditionalAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return safetyAmenitiesList?.count ?? 0
        } else {
            return otherAmenitiesList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Additional Amenities Cell " + indexPath.description
        
        var item: RoomAmenities?
        var itemId: String = ""
        
        if collectionView.tag == 0 {
            // Safety amenities
            item = safetyAmenitiesList?[indexPath.row]
        } else {
            // Other amenities
            item = otherAmenitiesList?[indexPath.row]
        }
        
        itemId = item?.id ?? ""
        let isSelected = selectedItems.contains(itemId)
        
        view.model.state = isSelected
        view.model.subtitle = item?.name ?? ""
        view.isUserInteractionEnabled = false
        
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 35)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var item: RoomAmenities?
        let collectionType = collectionView.tag == 0 ? "Safety" : "Other"
        
        if collectionView.tag == 0 {
            guard let safetyItem = safetyAmenitiesList?[indexPath.row] else {
                print("No safety item found at index \(indexPath.row)")
                return
            }
            item = safetyItem
        } else {
            guard let otherItem = otherAmenitiesList?[indexPath.row] else {
                print("No other item found at index \(indexPath.row)")
                return
            }
            item = otherItem
        }
        
        guard let amenityItem = item else { return }
        
        let itemId = amenityItem.id ?? ""
        let itemName = amenityItem.name ?? "Unknown"
        
        // Toggle selection
        if selectedItems.contains(itemId) {
            // Remove from selection
            selectedItems.removeAll { $0 == itemId }
            print("Deselected \(collectionType): \(itemName) (ID: \(itemId))")
        } else {
            // Add to selection
            selectedItems.append(itemId)
            print("Selected \(collectionType): \(itemName) (ID: \(itemId))")
        }
        
        // Update the specific cell
        collectionView.reloadItems(at: [indexPath])
        
        // Update button state after selection change
        updateNextButtonState()
        
        print("Current selected additional amenities: \(selectedItems)")
    }
}
