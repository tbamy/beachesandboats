//
//  BoatRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 11/10/2024.
//

import UIKit

class BoatRulesView: BaseViewControllerPlain {
    var coordinator: AccountCoordinator?
    
    @IBOutlet weak var stepOneProgress: UIProgressView!
    @IBOutlet weak var stepTwoProgress: UIProgressView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var boatRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        setup()
    }
    
    func setup(){
        stepOneProgress.setProgress(0.90, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        boatRulesList = boatData?.rules
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
    }

    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            let request = CreateBoatListingRequest(type: createBoatListing?.type ?? [], name: createBoatListing?.name ?? "", description: createBoatListing?.description ?? "", from_when: createBoatListing?.from_when ?? "", to_when: createBoatListing?.to_when ?? "", amenities: createBoatListing?.amenities ?? [], preferred_languages: createBoatListing?.preferred_languages ?? [], brief_introduction: createBoatListing?.brief_introduction ?? "", rules: selectedItems, no_of_adults: 0, no_of_children: 0, no_of_pets: 0, country: "", state: "", city: "", street_address: "", destinations_prices: [], images: [])
            
            coordinator?.gotoBoatPeopleRules(boatData: boatData, createBoatListingData: request, boatType: boatType ?? "")
        }
    }


}

extension BoatRulesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boatRulesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = ToggleSwitch(frame: cell.bounds)
        view.identifier = "Boat Rules Cell " + indexPath.description
        let item = boatRulesList?[indexPath.row]
        view.model.title = item?.description ?? ""
//        print("Rule: \(item?.description)")
        let itemId = item?.ruleID ?? ""
        if selectedItems.contains(itemId) {
            view.model.state =  true
        } else {
            view.model.state = false
        }
        
        
        view.toggleSwitch.isUserInteractionEnabled = true
        cell.applyView(view: view)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 60)
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DynamicCollectionViewCell
        let view = ToggleSwitch(frame: cell.bounds)
        guard let item = boatRulesList?[indexPath.row] else { return }
        
        let itemId = item.ruleID
        view.toggleSwitch.isUserInteractionEnabled = true
        if selectedItems.contains(itemId) {
            selectedItems.removeAll { $0 == itemId }
            view.model.state = false
        } else {
            selectedItems.append(itemId)
            view.model.state = true
        }
        
        collectionView.reloadItems(at: [indexPath])
            
        nextBtn.isEnabled = true
    }

    
}
