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
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var numberOfPassengers: IncreaseDecreaseField!
    @IBOutlet weak var nextBtn: PrimaryButton!
    
    var boatData: BoatDatas?
    var createBoatListing: CreateBoatListingRequest?
    var boatType: String?
    
    var boatRulesList: [HouseRule]?
    var selectedRules: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Boats"
        checkAndLoadSavedListing()
        setup()
    }
    
    private func checkAndLoadSavedListing() {
        if let savedListing = AppStorage.boatListing {
            print("=== LOADING SAVED BOAT LISTING ===")
            print("House rules count: \(savedListing.houseRules?.count ?? 0)")
            
            // Use the saved listing
//            createBoatListing = savedListing
            
            // Load saved rules
            selectedRules = savedListing.houseRules ?? []
            numberOfPassengers.model = IncreaseDecreaseModel(id: "", type: "Number of passengers", subtitle: "", count: savedListing.noOfPassengers ?? 1)
            
            print("Loaded saved boat listing successfully")
            print("===============================")
        } else {
            print("No saved boat listing found, starting fresh")
        }
    }
    
    func setup(){
        stepOneProgress.setProgress(0.90, animated: true)
        stepOneProgress.tintColor = .B_B
        stepTwoProgress.setProgress(0, animated: false)
        
        boatRulesList = boatData?.house_rules
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.register(DynamicCollectionViewCell.self, forCellWithReuseIdentifier: "dynamicCell")
        
        let passengersCount = createBoatListing?.noOfPassengers ?? 1
        print(passengersCount)
        numberOfPassengers.model = IncreaseDecreaseModel(id: "", type: "Number of passengers", subtitle: "", count: passengersCount)
        
        let hasValidCount = passengersCount > 0
        nextBtn.isEnabled = hasValidCount && !selectedRules.isEmpty
        
        // Setup count change handlers
        numberOfPassengers.onValueChange = { [weak self] _ in
            self?.validateForm()
        }
        
        updateCollectionViewHeight(collectionView, collectionViewHeight)
        collectionView.reloadData()
        validateForm()
    }
    
    private func validateForm() {
        let hasValidCount = numberOfPassengers.count > 0
        let hasRules = !selectedRules.isEmpty
        
        nextBtn.isEnabled = hasValidCount && hasRules
    }
    
    private func updateCollectionViewHeight(_ collectionView: UICollectionView, _ heightConstraint: NSLayoutConstraint) {
        collectionView.layoutIfNeeded()
        heightConstraint.constant = collectionView.contentSize.height
        view.layoutIfNeeded()
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        if let boatData = boatData{
            if var createBoatListing = createBoatListing{
                createBoatListing.houseRules = selectedRules
                createBoatListing.noOfPassengers = numberOfPassengers.count
                
                guard numberOfPassengers.count > 0  else {
                    Toast.show(message: "Please select at least one passenger.")
                    return
                }
                
                print(createBoatListing)
                print("selected rules: \( createBoatListing.houseRules)")
                coordinator?.gotoBoatAddressView(boatData: boatData, createBoatListingData: createBoatListing, boatType: boatType ?? "")
            }
        }
    }
    
    @IBAction func saveAndExit(_ sender: Any) {
        if var createBoatListing = createBoatListing{
            createBoatListing.houseRules = selectedRules
            createBoatListing.noOfPassengers = numberOfPassengers.count
            
            AppStorage.boatListing = createBoatListing
            coordinator?.backToDashboard()
        }
    }


}

extension BoatRulesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return boatRulesList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dynamicCell", for: indexPath) as! DynamicCollectionViewCell
        
        let view = ToggleSwitch(frame: cell.bounds)
        view.identifier = "BoatRulesCell " + indexPath.description
        let item = boatRulesList?[indexPath.row]
        
        // Set title and initial toggle state
        view.model.title = item?.name ?? ""
        let itemId = item?.id ?? ""
        view.isToggled = selectedRules.contains(itemId)
        
        // Setup toggle action to update selectedRules
        view.toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(_:)), for: .valueChanged)
        view.toggleSwitch.tag = indexPath.row
        
        cell.applyView(view: view)
        return cell
    }
    
    @objc func toggleSwitchChanged(_ sender: UISwitch) {
        let index = sender.tag
        guard let itemId = boatRulesList?[index].id else { return }
        
        if sender.isOn {
            if !selectedRules.contains(itemId) {
                selectedRules.append(itemId)
            }
        } else {
            selectedRules.removeAll { $0 == itemId }
        }
        
        validateForm()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthOfScreen: CGFloat = collectionView.bounds.width
        return CGSize(width: widthOfScreen, height: 60)
    }
}
