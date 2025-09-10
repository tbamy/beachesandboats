//
//  EditHouseRulesView.swift
//  BeachesAndBoats
//
//  Created by Tolu Akintayo on 23/07/2025.
//

import UIKit

class EditHouseRulesView: BaseViewControllerPlain {
    var coordinator: HostingServiceMenuCoordinator?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var property: BeachHouseListing?
    var beachData: BeachDatas?
    var createBeachListing: CreateBeachListingRequest?
    var id: String?
    
    var houseRulesList: [HouseRule]?
    var selectedItems: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit Property"
        setup()
    }
    
    func setup(){
        print(id)
        
        houseRulesList = beachData?.house_rules
        
        collectionView.backgroundColor = UIColor.background.lighter(by: 17)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        selectedItems = createBeachListing?.houseRules ?? []
        collectionView.reloadData()
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }

    @IBAction func nextTapped(_ sender: Any) {
        guard let id = id else { return }
        if let beachData = beachData{
            if var createBeachListing = createBeachListing{
                createBeachListing.houseRules = selectedItems
                print(createBeachListing)
                print(id)
                
                coordinator?.gotoEditCheckInAndOutRulesView(beachData: beachData, request: createBeachListing, id: id)
            }
        }
    }


}

extension EditHouseRulesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return houseRulesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell

        cell.isUserInteractionEnabled = true
        let view = ToggleSwitch(frame: cell.bounds)
        view.identifier = "House Rules Cell " + indexPath.description
        let item = houseRulesList?[indexPath.row]
        view.model.title = item?.name ?? ""
//        print("Rule: \(item?.description)")
        let itemId = item?.id ?? ""
        view.isToggled = selectedItems.contains(itemId)
        
        // Setup toggle action to update selectedRules
        view.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        view.toggleSwitch.tag = indexPath.row
        
        cell.applyView(view: view)
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard let itemId = houseRulesList?[index].id else { return }
        
        if sender.isOn {
            if !selectedItems.contains(itemId) {
                selectedItems.append(itemId)
            }
        } else {
            selectedItems.removeAll { $0 == itemId }
        }
        
        nextBtn.isEnabled = !selectedItems.isEmpty
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let widthOfScreen: CGFloat = collectionView.bounds.width
//        let heightOfScreen = collectionView.bounds.height
        return CGSize(width: widthOfScreen, height: 60)
       
    }


    
}

