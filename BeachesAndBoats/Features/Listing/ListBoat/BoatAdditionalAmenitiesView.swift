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
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.60, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        amenitiesList = boatData?.amenities?.filter{ $0.amenityType == "Safety"}
        
//        titleLabel.text = "What are the features in your \(boatType ?? "")?"
        subtitleLabel.text = "Select the amenities available to guests in your \(boatType ?? "")."
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            
            
            if var createBoatListing = createBoatListing{
                let additionalAmenities = createBoatListing.amenities + selectedAmenities
                createBoatListing.amenities = additionalAmenities
                
                print("current amenities: \(createBoatListing.amenities)")
                print("additional amenities: \(selectedAmenities)")
                print(createBoatListing)
                
                coordinator?.gotoBoatAboutYouLanguageView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
            
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            let additionalAmenities = createBoatListing.amenities + selectedAmenities
            createBoatListing.amenities = additionalAmenities
            
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
            
        nextBtn.isEnabled = true
    }

    
}
