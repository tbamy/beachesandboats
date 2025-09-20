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
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        selectedItems = createBeachListing?.amenities ?? []
        collectionView.reloadData()
        
        // Update button state based on selections
        updateNextButtonState()
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
            if var createBeachListing = createBeachListing {
                createBeachListing.amenities = selectedItems
                print("Proceeding with selected amenities: \(selectedItems)")
                print(createBeachListing)
                
                coordinator?.gotoEditPropertyAdditionalAmenitiesView(beachData: beachData, request: createBeachListing, id: id)
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
        
        print("Current selected items: \(selectedItems)")
    }
}

//import UIKit
//
//class EditPropertyAmenitiesView: BaseViewControllerPlain {
//    var coordinator: HostingServiceMenuCoordinator?
//    
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var nextBtn: PrimaryButton!
//    
//    var property: BeachHouseListing?
//    var beachData: BeachDatas?
//    var createBeachListing: CreateBeachListingRequest?
//    var selectedItems: [String] = []
//    var id: String?
//    
//    var amenitiesList: [RoomAmenities]?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "Edit Property"
//        setup()
//    }
//    
//    func setup(){
//        
//        amenitiesList = beachData?.amenities?.filter{ $0.amenityType == "General"}
//        
//        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.allowsMultipleSelection = true
//        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
//        
//        selectedItems = createBeachListing?.amenities ?? []
//        collectionView.reloadData()
//        nextBtn.isEnabled = !selectedItems.isEmpty
//    }
//
//    @IBAction func nextTapped(_ sender: Any) {
//        guard !selectedItems.isEmpty else { return }
//        
//        if let beachData = beachData{
//            if var createBeachListing = createBeachListing{
//                createBeachListing.amenities = selectedItems
//                print(createBeachListing)
//                
//                coordinator?.gotoEditPropertyAdditionalAmenitiesView(beachData: beachData, request: createBeachListing, id: id)
//            }
//        }
//    }
//    
//
//}
//
//extension EditPropertyAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return amenitiesList?.count ?? 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
//
//        cell.isUserInteractionEnabled = true
//        let view = SelectableCheckbox(frame: cell.bounds)
//        view.identifier = "Amenities Cell " + indexPath.description
//        let item = amenitiesList?[indexPath.row]
//        
//        let itemId = item?.id ?? ""
//        if selectedItems.contains(itemId) {
//            view.model.state = true
//        } else {
//            view.model.state = false
//        }
//        
//        view.model.subtitle = item?.name ?? ""
//        view.isUserInteractionEnabled = false
//        cell.applyView(view: view)
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let widthOfScreen: CGFloat = collectionView.bounds.width
////        let heightOfScreen = collectionView.bounds.height
//        return CGSize(width: widthOfScreen, height: 35)
//       
//    }
//    
//    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
//        let view = SelectableCheckbox(frame: cell.bounds)
//        guard let item = amenitiesList?[indexPath.row] else { return }
//        
//        let itemId = item.id ?? ""
//        
//        if selectedItems.contains(itemId) {
//            selectedItems.removeAll { $0 == itemId }
//            view.model.state = true
////            view.model.image = UIImage.uncheckIcon
//        } else {
//            selectedItems.append(itemId)
//            view.model.state = false
////            view.model.image = UIImage.checkIcon
//        }
//        
//        collectionView.reloadItems(at: [indexPath])
//            
//        nextBtn.isEnabled = true
//    }
//
//    
//}
