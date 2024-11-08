//
//  PropertyAdditionalAmenitiesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 01/10/2024.
//

import UIKit

class PropertyAdditionalAmenitiesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var safetyAmenitiesCollectionView: UICollectionView!
    @IBOutlet weak var otherAmenitiesCollectionView: UICollectionView! 
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    
    var selectedItems: [String] = []
    
    var safetyAmenitiesList: [Amenity]?
    var otherAmenitiesList: [Amenity]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Beaches Houses"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.70, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        safetyAmenitiesList = beachData?.amenities.first{ $0.name == "Safety Amenities"}?.amenities
        otherAmenitiesList = beachData?.amenities.first{ $0.name == "Other Amenities"}?.amenities
        
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
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let beachData = beachData{
            let amenities = (createBeachListing?.amenities ?? []) + selectedItems
            let request = CreateBeachListingRequest(category_id: createBeachListing?.category_id ?? "", sub_cat_id: createBeachListing?.sub_cat_id ?? "", guest_booking_id: createBeachListing?.guest_booking_id ?? "", name: createBeachListing?.name ?? "", description: createBeachListing?.description ?? "", country: createBeachListing?.country ?? "", state: createBeachListing?.state ?? "", city: createBeachListing?.city ?? "", street_address: createBeachListing?.street_address ?? "", from_when: "", to_when: "", amenities: amenities, preferred_languages: [""], brief_introduction: "", house_rules: [], check_in_start: "", check_in_end: "", check_out_start: "", check_out_end: "", roominfo: [], full_apartment_cost: 0, full_apartment_discount: 0, full_apartment_amount_to_earn: 0)
            
            coordinator?.gotoAboutYouLanguageView(beachData: beachData, createBeachListingData: request)
        }
    }


}

extension PropertyAdditionalAmenitiesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return safetyAmenitiesList?.count ?? 0
        }else{
            return otherAmenitiesList?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = SelectableCheckbox(frame: cell.bounds)
        view.identifier = "Additional Amenities Cell " + indexPath.description
        
        if collectionView.tag == 0{
            let item = safetyAmenitiesList?[indexPath.row]
            let itemId = item?.amenityID ?? ""
            if selectedItems.contains(itemId) {
                view.model.state = true
            } else {
                view.model.state = false
            }
            
            view.model.subtitle = item?.name ?? ""
            view.isUserInteractionEnabled = false
            cell.applyView(view: view)
        }else{
            let item = otherAmenitiesList?[indexPath.row]
            let itemId = item?.amenityID ?? ""
            if selectedItems.contains(itemId) {
                view.model.state = true
            } else {
                view.model.state = false
            }
            
            view.model.subtitle = item?.name ?? ""
            view.isUserInteractionEnabled = false
            cell.applyView(view: view)
        }
        
        
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
        
        if collectionView.tag == 0{
            guard let item = safetyAmenitiesList?[indexPath.row] else { return }
            
            let itemId = item.amenityID
            
            if selectedItems.contains(itemId) {
                selectedItems.removeAll { $0 == itemId }
                view.model.state = false
            } else {
                selectedItems.append(itemId)
                view.model.state = true
            }
        }else{
            guard let item = otherAmenitiesList?[indexPath.row] else { return }
            
            let itemId = item.amenityID
            
            if selectedItems.contains(itemId) {
                selectedItems.removeAll { $0 == itemId }
                view.model.state = false
            } else {
                selectedItems.append(itemId)
                view.model.state = true
            }
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}

