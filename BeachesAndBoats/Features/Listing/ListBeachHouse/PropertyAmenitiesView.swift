//
//  PropertyAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class PropertyAmenitiesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var selectedItems: [String] = []
    
    var amenitiesList: [RoomAmenities]?
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beach Houses"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        amenitiesList = beachData?.amenities?.filter{ $0.amenityType == "General"}
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        loadSavedData()
        collectionView.reloadData()
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.amenities = selectedItems
                print(createBeachListing)
                
                coordinator?.gotoPropertyAdditionalAmenitiesView(beachData: beachData, createBeachListingData: createBeachListing)
            }
        }
    }
    
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBeachListing = createBeachListing{
            createBeachListing.amenities = selectedItems
            
            AppStorage.beachListing = createBeachListing
            coordinator?.backToDashboard()
        }

    }
    

}

extension PropertyAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
        if selectedItems.contains(itemId) {
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
//        guard let cell = collectionView.cellForItem(at: indexPath) as? DynamicCollectionViewCell,
//              let view = cell.contentView.subviews.first as? SelectableCheckbox,
//              let item = amenitiesList?[indexPath.row] else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = SelectableCheckbox(frame: cell.bounds)
        guard let item = amenitiesList?[indexPath.row] else { return }
        
        let itemId = item.id ?? ""
        
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
            view.model.state = false
        } else {
            selectedItems.append(itemId)
            view.model.state = true
        }
        
        nextBtn.isEnabled = !selectedItems.isEmpty
        collectionView.reloadItems(at: [indexPath])
    }

    
}

extension PropertyAmenitiesView {
    func loadSavedData() {
        guard let savedListing = AppStorage.beachListing else { return }
        
        // Load previously selected amenities
        selectedItems = savedListing.amenities ?? []
        nextBtn.isEnabled = !selectedItems.isEmpty
        
        // Reload collection view to show selected states
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
